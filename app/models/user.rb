require 'digest/sha1'
class User < ActiveRecord::Base
    after_create :create_userplan
    has_one :user_plan
	  has_many:user_notifications
		has_one:user_billing_information
		has_one:user_profile
    has_one :user_setting
    has_one :user_notification
		has_many:oldcreditcards
		has_one:user_creditcard
		has_many:subscriptions
		has_many:payments
    has_many :objective_users 
		has_many:objectives ,:through => "objective_users"
		has_many:groups
		has_many:group_users
    has_many :favorites
		has_many:invitations
		has_many:messages
		has_many:comments
		has_many:post_reads
		has_many:posts
		has_many:admin_logs
		has_many:message_users
    has_many:messages, :through => "message_users"
    has_many:user_posts
    has_many:posts, :through => :user_posts
    has_one :attachment, :as => :attachable,:dependent => :destroy
  belongs_to :attachable,:polymorphic=>true
	belongs_to :pricing_plan
    has_many :user_creditcards
    has_many :fb_sessions
  # Virtual attribute for the unencrypted password
  attr_accessor :password,  :password_confirmation#,:is_free_user,:pricing_plan_id

  validates_presence_of     :email

  
  validates_presence_of     :password, :message=>"can't be blank", :if => :password_required?
  validates_presence_of     :password_confirmation, :message=>"can't be blank",     :if => :password_required?
  validates_length_of       :password, :within => 6..32,  :message=>"Max 32 and Min 6", :if => :password_required?
  validates_length_of       :password_confirmation, :within => 6..32,  :message=>"Max 32 and Min 6" , :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :user_name,    :within => 5..50, :allow_blank => true,  :message=>"Username should be with 5 to 50 characters"
  validates_length_of       :email,    :within => 3..100, :message=>"Max 100 and Min 3"
  validates_length_of    :primary_email,:within => 3..100, :message=>"Max 100 and Min 3",:allow_blank=>true if :primary_email_required?
  validates_uniqueness_of   :email, :case_sensitive => false, :message=>"has already taken" , :if=> :email_required?
  validates_uniqueness_of   :user_name,  :case_sensitive => false, :message=>"has already taken",:allow_blank => true, :if=> :username_required?
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of :primary_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,:allow_blank=> true ,:if => :primary_email?
  before_save :encrypt_password   #, :email_check
  before_create :make_activation_code 
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :user_name, :email, :password, :password_confirmation, :close_code, :state, :activation_code, :activated_at,:is_free_user,:pricing_plan_id,:primary_email,:primary_activiation_code

  # Activates the user in the database.
  def email_check
      User.with_scope(
          :find => { :conditions => "email != 10000",
          :limit => 10 }) do
      User.find(:all)
     end
 end    
 
   
  def create_userplan
    @plan=PricingPlan.first
    self.user_plan=UserPlan.create(:day=>@plan.day,:max_group=>@plan.max_group,:max_users_in_group=>@plan.max_users_in_group)
  end
  
  def update_userplan
    @plan=PricingPlan.first
    self.user_plan.update_attributes(:day=>@plan.day,:max_group=>@plan.max_group,:max_users_in_group=>@plan.max_users_in_group)
  end
  
  def update_paiduser_plan(plan_id)
    @plan=PricingPlan.find_by_id(plan_id)
    self.user_plan.update_attributes(:amount=>@plan.amount,:max_group=>@plan.max_group,:max_users_in_group=>@plan.max_users_in_group)
  end

  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def close_code
      self.close_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end     
    
  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(email, password)
    u = find :first, :conditions => ['(email = ? OR user_name = ? ) AND (activated_at IS NOT NULL) AND (state IS NULL)', email, email] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end
  def make_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
  def reset_password
    # First update the password_reset_code before setting the 
    # reset_password flag to avoid duplicate email notifications.
    update_attributes(:password_reset_code => nil)
    @reset_password = true
  end  
                
          
  def recently_forgot_password?
    @forgotten_password
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  def is_existing_member(group_id)
    self.group_users.find(:first,:conditions=>['group_id = ? AND is_deleted=?',group_id,false]).nil?
  end
  
  def is_active_member?(group_id)
    mem=self.group_users.find_by_group_id(group_id)
    mem && mem.is_active
  end
  
  def active_groups
    self.groups.find(:all,:conditions=>['is_active=?',true])
  end
  
  def groups_owned
    self.groups.find(:all,:conditions=>['group_users.is_deleted=? AND groups.is_active=?',false,true],:include=>:group_users)
  end
  
  def all_groups_owned
    self.groups.find(:all,:conditions=>['group_users.is_deleted=?',false],:include=>:group_users)
  end
  
  def members_in_groups
    self.group_users.find(:all,:conditions=>['is_deleted=?',false])
  end
  
  def group_membership
    self.group_users.find(:all,:conditions=>['group_users.is_active=? AND is_deleted=?',true,false],:order=>'groups.name',:include=>:group)
  end 
  
  #~ def members_in_groups
    #~ Group.find_all_by_id(group_active_membership.collect{|group| group.group_id},:order=>'name')
  #~ end
  
  def group_active_membership
    self.group_users.find(:all,:conditions=>['group_users.is_active=? AND is_deleted=? AND groups.is_active=?',true,false,true],:include=>:group)
  end
  
  def other_active_members
    @members=[]
    @groups=Group.find_all_by_id(group_active_membership.collect{|group_user| group_user.group_id})
    @groups.each do |group|
      @members+=User.find_all_by_id(group.active_members.collect{|group_user| group_user.user_id unless group_user.user_id==self.id})
    end
    @members.uniq! unless @members.empty?
    return @members
  end
  
   def group_obj_search(search)
     @collect=[]
    all_group=self.group_users.find(:all,:conditions=>['is_deleted=? and groups.description LIKE?',false,"%#{search}%"],:include=>:group)
    all_group.each do |coll|
     @collect<<coll.group
    end
    all_obj=self.group_users.find(:all,:conditions=>['is_deleted=?',false]) 
    all_group.each do |coll|
      @collect<<coll.group.objectives.find(:all,:conditions=>['title LIKE? or description LIKE? ',"%#{search}%","%#{search}%"]) unless coll.group.objectives.empty?
    end
    return @collect
  end
  
    def group_obj_search_group(search,v)
    @collect=[]
    all_group=self.group_users.find(:first,:conditions=>['is_deleted=? and groups.id=? and groups.description LIKE?',false,v,"%#{search}%"],:include=>:group)
    @collect<< all_group.group if !all_group.nil?
    all_obj=self.group_users.find(:first,:conditions=>['is_deleted=? and groups.id=?',false,v],:include=>:group) 
    @collect<< all_obj.group.objectives.find(:all,:conditions=>['title LIKE? or description LIKE? ',"%#{search}%","%#{search}%"]) unless all_obj.group.objectives.nil?
    return @collect
  end
   
  def upcoming_objectives_all
    @g=group_active_membership
    @objectives=Objective.find(:all,:conditions=>{'group_id'=>@g.collect{|x| x.group_id},'due_date'=>Date.today..Date.today+7} )
    return @objectives
  end
  
  def objectives_on_duedate(year,month,date,group_id=nil)
    @g=[self.group_users.find_by_group_id(group_id)]
    @g=group_active_membership if group_id.nil?
    @objectives=Objective.find(:all,:conditions=>{'group_id'=>@g.collect{|x| x.group_id},'due_date'=>Date.new(year,month,date)} )
    return @objectives
  end
  
  def objectives_on_duedate_group(group_id,year,month,date)
    
  end

  def user_status_updates
    @leader_updates=self.user_posts.find(:all,:conditions=>{'posts.group_id'=>user_groups.collect{|group_id| group_id},'leader_update_read'=>false},:include=>:post,:order=>"posts.updated_at DESC")
    @other_updates= self.user_posts.find(:all,:conditions=>{'posts.group_id'=>user_groups.collect{|group_id| group_id}},:include=>:post,:order=>"posts.updated_at DESC")
    @status_updates=@leader_updates+@other_updates
    @status_updates.uniq!
    return @status_updates
  end
    
  def my_user_status_updates
    group_ids=user_groups.join(",")
    group_ids=0 if group_ids.blank?
    @collections=[]
    @collections<<self.user_posts.find(:all,:joins=>:post,:conditions=>["(posts.user_id=? OR posts.receiver_id=?) AND posts.group_id IN (#{group_ids})",self.id,self.id],:include=>:post)
    @comment=self.comments
    @collections<<self.user_posts.find(:all,:conditions=>{'posts.group_id'=>user_groups,:post_id=>@comment.collect{|comment| comment.post_id}},:include=>:post)
    @collections.flatten!
    @collections.uniq! unless @collections.nil?
    @collections=@collections.sort_by{|collection| collection.updated_at}.reverse unless @collections.nil? || @collections.empty?
    return @collections
  end
  
  def user_comments_group(group_ids)
    self.comments.find(:all,:conditions=>{'posts.group_id'=>group_ids.collect{|group_id| group_id}},:include=>:post)
  end
  
  def post_from_comments(comments)
    self.user_posts.find(:all,:conditions=>{:post_id=>comments.collect{|comment| comment.post_id}})
  end
  
  def third_party_posts(group_ids)
    self.user_posts.find(:all,:joins=>:post,:conditions=>["(posts.user_id= #{self.id} OR posts.receiver_id=#{self.id}) AND posts.group_id IN (#{group_ids.join(",")})"])
  end
  
  def leader_in_groups
    self.group_users.find(:all,:conditions=>['group_users.is_active=? AND is_deleted=? AND groups.is_active=? AND groups.group_leader_id=?',true,false,true,self.id],:include=>:group)
  end
  
  def is_leader?
    self.leader_in_groups.empty? ? false : true
  end
  
  def user_unread_status_updates
    self.user_posts.find(:all,:conditions=>['is_read="false"'],:include=>:post,:order=>'posts.created_at DESC')
  end
  
  def user_unread_group_updates(group_id)
    self.user_posts.find(:all,:conditions=>['is_read="false" AND posts.group_id=?',group_id],:include=>:post,:order=>'posts.created_at DESC')
  end
  
  def group_updates(group_id)
    @leader_updates=self.user_posts.find(:all,:conditions=>['posts.group_id=? AND  posts.is_by_leader IS NOT NULL AND leader_update_read=? ',group_id,false],:include=>:post,:order=>"posts.updated_at DESC")
    @other_updates=self.user_posts.find(:all,:conditions=>['posts.group_id=? ',group_id],:include=>[:post,:user],:order=>"posts.updated_at DESC")
    @group_udpates=@leader_updates+@other_updates
    @group_udpates.uniq!
    return @group_udpates
  end
   
  def my_group_updates(group_id)
    @collections=[]
    @collections<<self.user_posts.find(:all,:joins=>:post,:conditions=>['(posts.user_id=? OR posts.receiver_id=?)and posts.group_id=?',self.id,self.id,group_id])
    @comment=self.comments
    @collections<<self.user_posts.find(:all,:conditions=>{:post_id=>@comment.collect{|comment| comment.post_id},'posts.group_id'=>group_id},:include=>:post)
    @collections.uniq!
    @collections.flatten! unless @collections.empty?
    @collections=@collections.sort_by{|collection| collection.updated_at}.reverse unless @collections.nil? || @collections.empty?
    return @collections
  end
    
  def user_group_updates(group_id)
    @status_updates=[]
    @status_updates<<self.user_posts.find(:all,:conditions=>['posts.group_id=? AND posts.user_id=?',group_id,self.id],:include=>:post,:order=>"posts.updated_at DESC")
    @comment=self.comments
    @comment.each do|@com|
      @status_updates<<self.user_posts.find(:all,:conditions=>['post_id=? AND posts.group_id=?',@com.post_id,group_id],:include=>:post)
    end
    @status_updates.flatten!
    @status_updates.uniq!
    @status_updates=@status_updates.sort_by{|collection| collection.post.updated_at}.reverse unless @status_updates.nil? || @status_updates.empty?
    return @status_updates
  end  
  
  def user_groups
    self.user_active_memberships.map(&:group_id)
  end
  
  def active_group_membership
    self.group_users.find(:all,:conditions=>['group_users.is_active = ? AND is_deleted = ? AND groups.is_active=?',true,false,true],:include=>:group)
  end
  
  def user_active_memberships
    self.group_users.find(:all,:conditions=>['group_users.is_active = ? AND is_deleted = ?',true,false])
  end
  
  def inbox_messages(group_ids)
    self.message_users.find(:all,:conditions=>{'is_delete'=>false, 'status'=>"recieved", 'is_trash'=>false,'messages.group_id'=>group_ids},:include=>:message,:order=>"messages.created_at DESC")    
  end
  
  def inbox_messages_group(group_id)
    self.message_users.find(:all,:conditions=>['messages.group_id=? AND is_delete=? AND status=? AND is_trash!=?',group_id,false,"recieved",1],:include=>:message,:order=>"messages.created_at DESC") 
  end
  
  def inbox_group_messages(group_id)
    self.is_active_member?(group_id) ? self.inbox_messages([group_id]) : []
  end
  
  def unread_messages_group(group_id)
    self.active_member?(group_id) ? self.message_users.find(:all,:conditions=>['is_delete=? AND is_read=? AND status=? AND is_trash!=? AND messages.group_id=?',false,false, "recieved",1,group_id],:include=>:message,:order=>'messages.created_at DESC') : []
  end
  
  def unread_messages_all
    self.message_users.find(:all, :conditions=>['is_delete=? AND is_read=? AND status=? AND is_trash!=?',false,false, "recieved",1],:order=>'created_at DESC') 
  end
  
  def trashed_messages
    self.message_users.find(:all,:conditions=>{'is_delete'=>false,'is_trash'=>true,'messages.group_id'=>user_groups},:include=>:message)
  end
  
  def trashed_messages_group(group_id)
    self.active_member?(group_id) ? self.message_users.find(:all,:conditions=>['is_delete=? AND is_trash=? AND messages.group_id=?',false,true,group_id],:include=>:message) : []
  end
  
  def drafts
    self.message_users.find(:all,:conditions=>{'status'=>'draftmine' ,'is_trash'=>false,'messages.group_id'=>user_groups},:include=>:message, :order=>'messages.created_at DESC') 
  end
  
  def group_drafts(group_id)
    self.active_member?(group_id) ? self.message_users.find(:all,:conditions=>['status=? AND is_trash!=? AND messages.group_id=?', "draftmine",1,group_id], :include=>:message,:order=>'messages.created_at DESC') : []
  end
  
  def sentitems
    self.message_users.find(:all,:limit=>20,:conditions=>{'is_delete'=>false,'status'=>"sent",'is_trash'=>0,'messages.group_id'=>user_groups}, :include=>:message, :order=>'messages.updated_at DESC')
  end
  
  def group_sentitems(group_id)
    self.active_member?(group_id) ? self.message_users.find(:all,:limit=>20,:conditions=>['is_delete=? AND status=? AND is_trash!=? AND messages.group_id=?',false,"sent",1,group_id], :include=>:message,:order=>'messages.updated_at DESC') : []
  end
    
  def child_sent_items(parent_id)
    self.message_users.find(:all,:conditions=>['is_delete=? AND messages.parent_id=? AND is_trash!=? AND status=?',false,parent_id,true,"sent"],:include=>:message)
  end
  
  def sent_message(id)
    self.message_users.find(:all,:conditions=>['is_delete=? AND message_id=? AND is_trash!=? AND status=?',false,id,true,"sent"])
  end
  
  def last_inbox_message
    self.message_users.find(:last,:conditions=>['is_delete=? AND status=? AND is_trash=?',false,"recieved",false])
  end
  
  def group_color(obj)
    self.group_users.find_by_group_id(obj.group_id).color_code
  end
 def message_search(search)
    @collections=[]
    @collect=[]
    @collect << self.message_users.find(:all,:conditions=>['(messages.subject LIKE? OR messages.message LIKE?) AND is_delete=?',"%#{search}%","%#{search}%",0],:include=>:message)
    @collect << self.message_users.find(:all,:conditions=>['(messages.subject LIKE? OR messages.message LIKE?) AND status LIKE? AND is_delete=?',"%#{search}%","%#{search}%","%draft%",0],:include=>:message)
    @collect.flatten!
    if !@collect.empty?
    @collect.each do |coll|
      if coll.message.parent_id.nil? 
        @collections << coll.message 
      else
        #collection_reply= Message.find(:last,:conditions=>['parent_id=? AND  message LIKE?',coll.message.parent_id,"%#{search}%"])
        @collections <<  Message.find_by_id(coll.message.parent_id) 
      end
    end
  end
  @collections.uniq!
  return @collections
  end
  
  def message_group_search(search,v)
    @collections=[]
    @collect=[]
    @collect <<self.message_users.find(:all,:conditions=>['messages.group_id=? AND (messages.subject LIKE? OR messages.message LIKE?) AND is_delete=?',v,"%#{search}%","%#{search}%",0],:include=>:message) 
    @collect <<self.message_users.find(:all,:conditions=>['(messages.subject LIKE? OR messages.message LIKE?) AND (status LIKE?) AND is_delete=?',"%#{search}%","%#{search}%","%draft%",0],:include=>:message) 
    @collect.flatten! 
    if !@collect.empty?
    @collect.each do |coll|
      if coll.message.parent_id.nil? 
        @collections << coll.message 
      else
        @collections <<  Message.find_by_id(coll.message.parent_id) 
      end
    end
    end
       return @collections
     end
     
  def status_update_search(search)
    @collections=[]
      @collections<<self.user_posts.find(:all,:conditions=>['posts.content LIKE?',"%#{search}%"],:include=>:post)
      @coll= self.user_posts 
      if !@coll.empty?
        @coll.each do |coll|
          @collect=[]
          @collect=coll.post.comments.find(:all,:conditions=>['content LIKE?',"%#{search}%"])  if coll && coll.post
          @collections << coll if !@collect.empty?
        end
      end
     return @collections
    end
    
    def status_update_group_search(search,v)
      @collections=[]
        @collections<< self.user_posts.find(:all,:conditions=>['posts.group_id=? AND posts.content LIKE?',v,"%#{search}%"],:include=>:post)
      @coll= self.user_posts.find(:all,:conditions=>['posts.group_id=?',v],:include=>:post)
       if !@coll.empty?
        @coll.each do |coll|
          @collect=[]
          @collect=coll.post.comments.find(:all,:conditions=>['content LIKE?',"%#{search}%"]) if coll && coll.post
          @collections << coll if !@collect.empty?
        end
      end
      return @collections
    end
    
  def active_member?(group_id) 
    self.group_users.find_by_group_id(group_id,:conditions=>['is_active=? AND is_deleted=?',true,false])
  end 
  
  #~ def members_in_groups
    #~ self.group_users.find(:all,:conditions=>['group_users.is_active=? OR groups.user_id=? OR groups.group_leader_id=?',true,self.id,self.id],:include=>:group)
  #~ end
  
  def owned_group_users
    self.group_users.find(:all,:conditions=>{:group_id=>self.groups.map(&:id)})
  end
  
  def find_mail_items
    if user_setting
      send_items={}   
      send_items["Organization: "]=user_profile.organization if user_setting.organization
      send_items["Occupation: "]=user_profile.occupation if user_setting.occupation
      send_items["Office Email Address: "]=user_profile.office_email_address if user_setting.office_email_address
      send_items["Personal Email Address: "]=user_profile.personal_email_address if user_setting.personal_email_address
      send_items["Mobile Phone: "]=user_profile.mobile_phone if user_setting.mobile_phone
      send_items["Office Phone: "]=user_profile.office_phone if user_setting.ofice_phone
      send_items["Yahoo ID: "]=user_profile.yahoo_id if user_setting.yahoo_id
      send_items["Windows Live ID: "]=user_profile.windows_live_id if user_setting.windows_live_id
      send_items["AIM ID: "]=user_profile.aim_id if user_setting.AIM_id
      send_items["Skype ID: "]=user_profile.skype_id if user_setting.skype_id
      send_items["Mailing Address 1: "]=user_profile.mailing_address1 if user_setting.mailing_address1
      send_items["Mailing Address 2: "]=user_profile.mailing_address2 if user_setting.mailing_address2
      send_items["City: "]=user_profile.city if user_setting.city
      send_items["State: "]=user_profile.state if user_setting.state
      send_items["Country: "]=user_profile.country if user_setting.country
      send_items["Zipcode: "]=user_profile.zipcode if user_setting.zip
      return send_items
    else
      return false
    end
  end
  
  def send_contacts_changed_mail
    mail_items= find_mail_items
    if mail_items
      other_active_members.each do |u|
        UserMailer.deliver_contacts_changed(self,u,mail_items) if u.user_notification && u.user_notification.members_info_change
      end
    end
  end
  
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{user_name}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def make_activation_code

      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
    
    def close_code
         self.close_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
     end    

  def email_required?
    if User.find(:all,:conditions=>['email = ? AND state = ?', self.email,0]).length == 0
      return true
    else
      return false
    end   
  end 
  def username_required?
    if User.find(:all,:conditions=>['user_name = ? AND state = ?', self.user_name,0]).length == 0
      return true
    else
      return false
    end   
  end 

end

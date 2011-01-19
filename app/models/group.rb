class Group < ActiveRecord::Base
	  belongs_to :user
    belongs_to :group_leader,:class_name=>"User"
		has_many :objectives
		has_many :group_users
		has_many :posts
		has_many :admin_logs
		has_many :messages
		has_many :invitations
		has_many :favorites
    validates_presence_of :name, :message=>"Group name cannot be blank"
    validates_length_of :name, :within => 5..100, :too_long => "Group Name must not exceed 25 characters", :too_short => "Group Name must have at least 5 characters"
    validates_presence_of :description, :message=>"Goal cannot be blank"
    validates_length_of :description, :within => 5..4000, :too_long => "Goal must not exceed 4000 characters", :too_short => "Goal must have at least 5 characters "
    validates_format_of :leader_email_invite, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,:allow_blank => true,:message=>"Please enter a valid email"
    validates_length_of :leader_email_invite, :within => 3..100, :too_short=>"Email should be atleast 3 characters",:too_long=>"Email should be less than 100 characters",:allow_blank => true
    
  def self.upcoming_objectives(user,group_id)
    @group=Group.find_by_id(group_id)
    @objectives=@group.objectives.find(:all,:conditions=>['due_date >= ? AND due_date < ?',Date.today, Date.today+7])
    return @objectives.flatten!
  end
    
  def group_upcoming_objectives
    self.is_active ? self.objectives.find(:all,:conditions=>['due_date >= ? AND due_date < ?',Date.today, Date.today+7]) : []
  end
    
  #~ def self.groups_owned(user)
    #~ user.groups.find(:all,:conditions=>['group_users.is_deleted=?',false],:include=>:group_users)
  #~ end
  
  def other_group_members(user_id)
    self.group_users.find(:all,:conditions=>['user_id != ?',user_id])
  end
  
  def all_group_members
    self.group_users.find(:all,:conditions=>['users.state IS NULL AND is_deleted =?',false],:include=>:user)
  end
  
  def find_undeleted_members
    self.group_users.find(:all,:conditions=>['is_deleted= ?',false])
  end
  
  def active_members
    self.group_users.find(:all,:conditions=>['is_active=? AND is_deleted=? AND users.state is null',true,false],:include=>:user)
  end
  
  def group_plan
    self.user.user_plan
  end
  
  def allowed_to_activate?
    group_plan.max_users_in_group>active_members.count
  end
end

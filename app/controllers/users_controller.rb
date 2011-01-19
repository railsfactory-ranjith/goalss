require 'authenticated_system.rb'
 require 'user_authenticated_system.rb'
class UsersController < ApplicationController
    #require 'RMagick'
  # Be sure to include AuthenticationSystem in Application Controller instead
  include UserAuthenticatedSystem
    layout :change_layout,:except=>['check_user_account','post_user_comment','upload_file','list_filter']
  before_filter :must_be_logged_in, :only=>['dashboard', 'close_code', 'close_account', 'update']
  skip_filter :clear_attachment_session, :only => [:upload_file,:post_user_comment]
   # render new.rhtml
  def dashboard
    @user=current_user 
  end
  def new
    if session[:access_code]
      @uses=Demographic.find :all
      @industries=Industry.find :all
    else
      flash[:error]="Please enter the access code to signup "
      redirect_to :controller=>"betasignups", :action=>"signup_beta"
       end
   end

  def create
      cookies.delete :auth_token
    #if (params[:user][:email] == params[:user][:email1]) && !params[:user][:email].blank? && !params[:user][:email1].blank?
      @user = User.new(params[:user])
      @user_profile=UserProfile.new(params[:user_profile])  
      @user_profile.dob=convert_date(params[:date]) if !params[:date][:month].empty? && !params[:date][:day].empty? && !params[:date][:year].empty?
      user_valid = @user.valid?
      user_profile_valid = @user_profile.valid?
      if !@user_profile.dob.nil? 
         if user_valid  && user_profile_valid  && !params[:user][:email1].blank? && params[:user][:email]==params[:user][:email1]
            @user.is_free_user=true
            @user.access_code=session[:access_code]
            @user.save
            @user_profile.user_id=@user.id
            @user_profile.first_name=@user_profile.first_name.capitalize
            @user_profile.last_name=@user_profile.last_name.capitalize
            @user_profile.save
            self.current_user = @user
            if (session[:invited_member] && session[:invited_member].email==current_user.email) || (session[:facebook_invite_group_id])
                current_user.update_attributes(:activation_code=>nil,:activated_at=>Time.now)
              redirect_to :action=>"signup"
              flash[:notice]="Thanks for creating your account!"
            elsif session[:invited_leader] && session[:invited_leader].leader_email_invite==current_user.email
              current_user.update_attributes(:activation_code=>nil,:activated_at=>Time.now)
              redirect_to :action=>"signup"
              flash[:notice]="Thanks for creating your account!"
            else
              UserMailer.deliver_signup_notification(@user)
              flash[:notice] = "Thanks for creating your account! An email with your account information has been sent to you at: "
              flash[:notice1]="#{@user.email}"
              self.current_user=nil
              session[:access_code]=nil
              redirect_to :action=>"account_created"
            end
        else
            flash.now[:confirmation_email_error] = "can't be blank" if params[:user][:email1].blank?
      flash.now[:error] = "Email,Confirm Email mismatch" if !params[:user][:email1].blank? && params[:user][:email]!=params[:user][:email1]
      
            render :action => 'new'
        end
      else
        if !params[:date][:month].empty? && !params[:date][:day].empty? && !params[:date][:year].empty?
           flash.now[:dob_error]="Invalid date"
        else
           flash.now[:dob_error]="can't be blank"
       end
        flash.now[:confirmation_email_error] = "can't be blank" if params[:user][:email1].blank?
      flash.now[:error] = "Email,Confirm Email mismatch" if !params[:user][:email1].blank? && params[:user][:email]!=params[:user][:email1]
      
        render :action => 'new'
    end   
      #~ else
     #~ # flash[:error] = "Email, Confirm Email mismatch!" 
      #~ flash.now[:error] = "Email, Confirm Email cant be blank" if params[:user][:email].blank? || params[:user][:email1].blank?
      #~ flash.now[:error] = "Email,Confirm Email mismatch" if params[:user][:email]!=params[:user][:email1]
      #~ render :action => 'new'
    #~ end   
  end

  def activate
    self.current_user=params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if user_logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Signup complete!"
        redirect_to :action=>"signup"
    else
        flash[:error] = "Oops!!  Signup Incomplete!"
        redirect_back_or_default('/')
    end
   end
  
  def signup
  

  end
  
  def forgot_password
	return unless request.post?
   	#if @user = User.find_by_email(params[:user][:email])
   	if @user = User.find(:first,:conditions=>['email = ? AND state is null ' ,params[:user][:email]])
	  @user.forgot_password
      @user.save
	  UserMailer.deliver_forgot_password(@user) 
      flash[:notice] = "A password reset link has been sent to your email address" 
      redirect_back_or_default('/')
	else
      if params[:user][:email]!=""
        flash[:error] = "Could not find a user with that email address" 
      else
        flash[:error] = "Email should not be blank"   
      end     
      redirect_back_or_default('/user_forgot_password')
    end
  end
  
  def reset_password
    @user = User.find_by_password_reset_code(params[:id])
    return if @user unless params[:user]
     if ((params[:user][:password] && params[:user][:password_confirmation]) && (!params[:user][:password].blank? && !params[:user][:password_confirmation].blank?))
        if (params[:user][:password] == params[:user][:password_confirmation])
    #if ((params[:user][:password] && params[:user][:password_confirmation]) && (!params[:user][:password].blank? && !params[:user][:password_confirmation].blank?))
      self.current_user = @user #for the next two lines to workactivities#
      current_user.password_confirmation = params[:user][:password_confirmation]
      current_user.password = params[:user][:password]
      @user.reset_password
       if current_user.save
			  flash[:notice] ="Password reset success."
        UserMailer.deliver_password_changed(current_user)
			  redirect_back_or_default('/')
          end	
        else
          flash.now[:error] = "Password doesn't match confirmation" 
        end  
      else
        flash.now[:error] = "Password & confirmation password should not be blank" 
      end
end      

 def edit
	 puts"EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE"
 @user=current_user
   @groups=current_user.groups.paginate :page=>params[:page],:per_page=>ENTRIES_PER_PAGE 

  #@user=current_user
#    @q=current_user.groups
   # @groups=current_user.groups.all.paginate :page=>params[:page],:per_page=>ENTRIES_PER_PAGE 
     #@groups=@q.paginate :page=>params[:page],:per_page=>ENTRIES_PER_PAGE 
    @active_groups=current_user.groups_owned
    @user_plan=current_user.user_plan
  end  
  
  def update
    @user_plan=current_user.user_plan
    @user=current_user
    @active_groups=current_user.groups_owned
    @groups=current_user.groups.paginate :page=>params[:page],:per_page=>ENTRIES_PER_PAGE 
    @user_profile = @user.user_profile 
		if params[:attachment]
			@attachment = Attachment.new(params[:attachment])
			@attachment.save
			crop_image(@attachment.public_filename)
	  end 		
		if params[:update] 
      if  @user_profile.update_attributes(:first_name=>(params[:user_profile][:first_name].capitalize),:last_name=>(params[:user_profile][:last_name].capitalize), :state=>params[:user_profile][:state], :zipcode=>params[:user_profile][:zipcode],:country=>params[:user_profile][:country])
        flash[:notice]="Successfully Updated."
	      redirect_to :action=>"edit",:id=>params[:id] 
      else
          render :action=>"edit",:id=>params[:id]         
      end 
    else
       redirect_to :action=>"edit",:id=>params[:id] 
   end       
    
  end    
  
  
	def crop_image(image)
		
		old_image = Magick::ImageList.new("#{RAILS_ROOT}/public/#{image}")
                new_image=old_image.crop_resized(50,50)
                path=image.split('/')
                name=path.last.split('.').first
                name_extern=path.last.split('.').last 
                new_image.write("#{RAILS_ROOT}/public/#{path[1]}/#{path[2]}/#{path[3]}/#{name}_size1.#{name_extern}")
		
	end

  #~ def convert_date(date)
    #~ begin
       #~ date=date[:day]+date[:month]+date[:year]
       #~ Date.parse(date)
       #~ rescue 
       #~ err="invalid"
       #~ end
  #~ end  
  
  def rpx
    url = URI.parse "#{APP_CONFIG[:rpx_auth_info_site]}"
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')
    request = Net::HTTP::Get.new("#{url.path}?apiKey=#{APP_CONFIG[:rpx_api_key]}&token=#{params[:token]}")
    response, data = http.request(request)
    user = ActiveSupport::JSON.decode(data)
    if user['profile'] and user['profile']['preferredUsername']
      @user = User.find_by_identifier_url(user['profile']['identifier'])
      if @user.nil?
        @user = User.new
        #@user.email=>user['profile']['email']
        @user.signup_type=user['profile']['providerName']
        @user.identifier_url=user['profile']['identifier']
        @user.email=user['profile']['email']
        #@user.confirmed_at=Time.now
        @user.state="active"
        @user.is_rpx=1
       # @user.personal_storage_size=note_setting.default_storage_size if note_setting
        @user.save(false)
        success_or_fail_login #emila validation done  here
      else
        success_or_fail_login #emila validation done  here
      end
    else
      flash[:notice] = "Not able to fetch your details using Rpx...Try again with Rpx openID or Provide your details to signup"         
      redirect_to '/signup'
    end 
   end
  
  def success_or_fail_login
    if (@user.email.nil? || @user.email.blank?) #|| (@user.confirmed_at.nil?) # || (!@user.confirmation_code.nil?)
       redirect_to verify_email_path(@user.id)
    else
     # self.current_user =@user
        if @user.activation_code == nil 
            self.current_user=@user
          flash[:notice] = "Logged in successfully"  
          redirect_to :controller=>"users",:action=>"edit",:id=>current_user.id    
        else     
          redirect_to :action=>'signup3', :id=>@user.id
        end  
    end
  end

  def close_code
	  puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	 
    @user = User.find_by_id(params[:id])
    @user.close_code =  Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    @user.save
    UserMailer.deliver_close_code(@user)
    flash[:notice]="Close your account link has been sent to your Email address."
    if current_user.is_free_user
      redirect_to :action=>"edit",:id=>params[:id]  
    else
      redirect_to :controller=>"paid_users",:action=>"edit",:id=>current_user.id
    end
  end
  
  
  
  
  
  
  

  def close_account_reason
puts "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"	  
    close_code=User.find_by_close_code(params[:id])
    puts close_code
    self.current_user=User.find(:first,:conditions=>['id =? ', close_code.id]) if !close_code.nil?
    current_user.update_attributes(:close_code=>nil) if !current_user.nil?
    if close_code 
	    puts"WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
      flash[:error]="Wrongs code"
      if !current_user.nil?
        if current_user.is_free_user
          redirect_to :action=>"edit",:id=>current_user.id
        else
          redirect_to :controller=>"paid_users",:action=>"edit",:id=>current_user.id
        end
      else    
        redirect_to '/'
      end
    end    
  end
  
  def close_account
    if params[:commit]=="Yes, close my Account" 
      if  params[:user]
        @user = User.find_by_id(current_user.id)   
        if @user.is_free_user
          @user.update_attributes(:close_code => nil, :state=>0, :reason_for_delete=>params[:user].keys)
          @user.groups.each do |group|
            group.update_attribute(:is_active,false)
          end
          flash[:notice]="Your account has been closed"
          self.current_user=nil
          redirect_to '/'
        else
          redirect_to :controller=>"paid_users",:action=>"close_profile",:id=>current_user.id
        end    
      else
        flash[:error]="Please Select any one reason"
        redirect_to :action=>"close_account_reason"
      end
    else
      if current_user.is_free_user
        redirect_to :action=>"edit",:id=>current_user.id 
      else
        redirect_to :controller=>"paid_users",:action=>"edit", :id=>current_user.id 
      end
    end    
  end

  def change_layout
    action=%w{new create forgot_password reset_password account_created invite invite_leader}
    action.include?(action_name) ? "before_login" : "after_login"  
  end    

  def edit_profile
      @user = current_user
      img="true"
      if params[:attachment]
        @attachment=Attachment.new(params[:attachment])
        img=['image/pjpeg', 'image/jpeg', 'image/gif', 'image/png', 'image/x-png', 'image/jpg','image/bmp','image/tiff','image/tif']
          if  img.include?(@attachment.content_type)
            @user.attachment = @attachment
            crop_image(@user.attachment.public_filename)
            img="true"
          else
            img="false"
            flash["file_sigup"]="Invalid File Format"
          end     
      end  
      @user_profile=UserProfile.find_by_user_id(current_user.id)
      if @user_profile.update_attributes(params[:user_profile]) && @user.save && img=="true"
        flash[:notice]="Successfully updated"
        redirect_to :controller=>"activities",:action=>"index"
      else
        #if @user_profile.errors.blank? && !params[:attachment]
         # redirect_to :controller=>"activities",:action=>"index"
        #else
        flash.now[:notice]="Please enter atleast one field else skip this page" if @user_profile.errors.blank? && !params[:attachment]
          render :action=>'signup', :id=>current_user.id
        #end  
      end   


  end    

   def signup3
       @user=User.find_by_id(params[:id])
   end

  def rpx_create
      @user=User.find_by_id(params[:id])
      if (params[:user][:email] == params[:user][:email1]) && !params[:user][:email].blank? && !params[:user][:email1].blank?
      #@user = User.new(params[:user])
      @user_profile=UserProfile.new(params[:user_profile])  
      @user_profile.dob=convert_date(params[:date]) if !params[:date][:month].empty? && !params[:date][:day].empty? && !params[:date][:year].empty?
     # user_valid = @user.valid?
      user_profile_valid = @user_profile.valid?
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      @user.activated_at = Time.now
      @user.state = nil
      @user.email=params[:user][:email]
      @user.user_name=params[:user][:user_name]
     # @user.reset_password
      @user.save
      if    !@user_profile.dob.nil? 
         if  user_profile_valid 
           #@user.save
          # @u.update_attributes(params[:user])
           @user_profile.user_id=@user.id
           @user_profile.save
            @user.activate
           self.current_user = @user
             redirect_to :controller=>"users",:action=>"edit",:id=>current_user.id
        else
             render :action => 'signup3',:id=>params[:id]
        end
      else
        if !params[:date][:month].empty? && !params[:date][:day].empty? && !params[:date][:year].empty?
           flash.now[:dob_error]="Invalid date"
        else
           flash.now[:dob_error]="can't be blank"
        end
        render :action => 'signup3',:id=>params[:id]
      end   
    else
     # flash[:error] = "Email, Confirm Email mismatch!" 
      flash.now[:error] = "Email, Confirm Email cant be blank" if params[:user][:email].blank? || params[:user][:email1].blank?
      flash.now[:error] = "Email,Confirm Email mismatch" if params[:user][:email]!=params[:user][:email1]
      render :action => 'signup3',:id=>params[:id]
    end   
  end
  
  def invite
    @user=Invitation.find_by_invitation_code(params[:invitation_code])
    unless @user.nil?
      if !@user.email.nil?
        if !current_user.nil? && current_user.email==@user.email
          session[:invited_member]=@user
          redirect_to :controller=>"activities",:action=>"index"
        else
          redirect_to :controller=>"session",:action=>"new"
          session[:invited_member]=@user
        end
      else
        session[:facebook_invite_group_id]=@user.group_id 
        redirect_to :action=>"new"
      end  
    end  
    #@user.update_attribute(:invitation_code,nil)    
  end
  
  def invite_leader
    @leader_group=Group.find_by_invitation_code(params[:invitation_code])
    if !current_user.nil? && current_user.email==@leader_group.leader_email_invite
      session[:invited_leader]= @leader_group
      redirect_to :controller=>"activities",:action=>"index"
    else
      redirect_to :controller=>"session",:action=>"new"
      session[:invited_leader]=@leader_group
    end
    #@leader_group.update_attribute(:invitation_code,nil)
  end
  
  def check_user_account
    if  current_user.is_free_user.nil? || current_user.is_free_user
      @free_plan=PricingPlan.find(1)
      @groups=current_user.groups_owned
    else
      redirect_to :controller=>"groups",:action=>"new"
    end
  end
  
  def settings
    remove_session_files
    @fav_str=''
    @user_profile=current_user.user_profile
    @user_setting=current_user.user_setting
    @user_notification=current_user.user_notification
    @favourites=current_user.favorites
    @groups=current_user.user_active_memberships
    @groups1 =Group.find_all_by_id(@groups.map(&:group_id).uniq)
    fav_function
  end
  def settings_update
    @fav_str=''
    @user = current_user
    img="true"
     if params[:attachment]
        @attachment=Attachment.new(params[:attachment])
        img=['image/pjpeg', 'image/jpeg', 'image/gif', 'image/png', 'image/x-png', 'image/jpg','image/bmp']
        if  img.include?(@attachment.content_type)
          @user.attachment = @attachment
          crop_image(@user.attachment.public_filename)
          img="true"
        else
          img="false"
          flash.now["file"]="Invalid File Format"
        end
      end  
    @groups=current_user.user_active_memberships
    @groups1 =Group.find_all_by_id(@groups.map(&:group_id).uniq)
    fav_function
    @favourites=current_user.favorites
    @user_profile=current_user.user_profile
    @latest=current_user.user_profile
    @user_setting=current_user.user_setting
    @user_notification=current_user.user_notification
    if @latest.country != params[:user_profile][:country] || @latest.organization != params[:user_profile][:organization]  || @latest.occupation != params[:user_profile][:occupation] || @latest.office_email_address != params[:user_profile][:office_email_address] || @latest.personal_email_address != params[:user_profile][:personal_email_address] || @latest.mobile_phone != params[:user_profile][:mobile_phone] || @latest.office_phone != params[:user_profile][:office_phone] || @latest.yahoo_id != params[:user_profile][:yahoo_id] || @latest.windows_live_id != params[:user_profile][:windows_live_id] || @latest.aim_id != params[:user_profile][:aim_id] || @latest.skype_id != params[:user_profile][:skype_id] || @latest.mailing_address1 != params[:user_profile][:mailing_address1] || @latest.mailing_address2 != params[:user_profile][:mailing_address2] || @latest.city != params[:user_profile][:city] || @latest.state != params[:user_profile][:state] || @latest.country != params[:user_profile][:country] || @latest.zipcode != params[:user_profile][:zipcode] || @latest.other_info != params[:user_profile][:other_info]
		  @latest.attributes=(params[:user_profile])
    end
    params[:user_profile][:time_zone]=params[:user_profile][:time_zone].delete("UTC") unless params[:user_profile][:time_zone].blank?   
    time_zone=params[:user_profile][:time_zone]
    date_format=params[:user_profile][:date_format]
    att=params[:user_profile]
    att.delete(:time_zone)
    att.delete(:date_format)
    @user_profile.attributes=(att)
    contacts_changed=@user_profile.changed?   
    password_correct=validate_change_password(params[:old_password],params[:user][:password],params[:user][:password_confirmation])
    if (@user_profile.valid? && password_correct && img =="true")
      puts params[:user_profile].inspect
      @user_profile.update_attributes(:time_zone=>time_zone)
      @user_profile.update_attributes(:date_format=>date_format)
      @user_profile.update_attributes(params[:user_profile])
      @user_profile.update_attributes(:first_name=>params[:user_profile][:first_name].capitalize,:last_name=>params[:user_profile][:last_name].capitalize)
      current_user.send_contacts_changed_mail if contacts_changed
      if @user_setting.nil?
        @user_setting=UserSetting.new(params[:user_setting])
        @user_setting.user_id=current_user.id
        @user_setting.save
      else
        @user_setting.update_attributes(params[:user_setting])
      end
      current_user.password_confirmation = params[:user][:password_confirmation]
      current_user.password = params[:user][:password]
      current_user.reset_password 
      if @user_notification.nil?
        @user_notification=UserNotification.new(params[:user_notification])
        @user_notification.user_id=current_user.id
        @user_notification.save
      else
        @user_notification.update_attributes(params[:user_notification])
      end
      if !params[:favorites].nil? and !params[:favorites].blank?
        (current_user.favorites).each do |each_fav|
        each_fav.destroy
      end  
      params[:favorites].each do|k,v|
        if v.to_i > 0
          @favourite=Favorite.new
          @favourite.group_id=v.to_i
          @favourite.user_id=current_user.id
          @favourite.save
        end 
      end        
    end  
    (current_user.members_in_groups).each do |each_group|
      each_group.update_attributes(:color_code => params["color1_#{each_group.group_id}"])
    end  
      flash[:notice]="Settings Updated"
      redirect_to :action=>"settings"
    else
        render :action=>"settings"
    end
  end
  
  def show_favorites
    
  end
  
  def discontinue
    @group_member=current_user.group_users.find_by_group_id(params[:id])
    @group_member.update_attributes(:is_deleted=>true,:is_active=>false)
    redirect_to :action=>"settings"
  end
  
  def favorite_user_group
    @groups1 =[]
    str =[]
      if !params[:fav_str].blank?
        f1 = params[:fav_str].split(":")
        for f in f1
           f1 =f.split(",")
           
           str[f1[0].to_i] = f1[1]
        end 
      end     
    for i in 1..5
      if params["favorites_#{i}"] 
        if  !params["favorites_#{i}"].blank?
          str[i] = params["favorites_#{i}"]
        else
           str[i]  =nil
        end          
      end
    end
    current_user.user_active_memberships.each do |g|
      @groups1<< Group.find_by_id(g.group_id)
    end
    g =[]
    for i in 1..str.length-1
      @groups1 =@groups1 - [Group.find_by_id(str[i])]
      g << "#{i},#{str[i]}"
    end  
    @fav_str =g.join(":")
    @str = str
    render :update do |page|
      page.replace 'fav_group', :partial => 'favorite_group'
    end  
  end  
  
  def  fav_function
    i=1
    str=[]
    for  fav in current_user.favorites
      str[i] = fav.group_id
      i=i+1
    end  
    g =[]

    for i in 1..str.length-1
      @groups1 =@groups1 - [Group.find_by_id(str[i])]
      g << "#{i},#{str[i]}"
    end  

    @fav_str =g.join(":")
    @str = str   
 end  
 
  def profile_thirdparty
    @favorites=Favorite.find_all_by_user_id(current_user.id)
    @user = User.find_by_id(params[:id])
    @common_groups=@user.active_group_membership.map(&:group_id).uniq & current_user.active_group_membership.map(&:group_id).uniq unless @user.nil?
    if (@user && @common_groups && !@common_groups.empty?) || current_user==@user
      @groups=Group.find_all_by_id(@common_groups)
      @objectives=[]
      @groups.each do |group|
        group.objectives.each do|obj|
          @objectives<<obj if obj.responsible_members.map(&:user_id).include?(@user.id)
        end
      end
      @objectives = @objectives.flatten.uniq
      @user_settings=UserSetting.find_by_user_id(params[:id])    
    else
      redirect_to :action=> "unauthorized"
    end
  end 
  
  def  thirdparty_activity
    @favorites=Favorite.find_all_by_user_id(current_user.id)
    @user = User.find_by_id(params[:id])  				
    @common_groups = @user.active_group_membership.map(&:group_id).uniq & current_user.active_group_membership.map(&:group_id).uniq unless @user.nil?
    if @user && @common_groups && !@common_groups.empty?
      !params[:limit].nil?  ?  @limit = params[:limit].to_i+20 :  @limit = 20
      if session[:filter_group] || params[:group_id]
        session[:filter_group]=params[:group_id] if params[:group_id]
        @group=Group.find_by_id(session[:filter_group])
      else
        session[:filter_group]=nil if params[:filter]=="no"
      end
      find_thirparty_posts(session[:filter_group] ? [session[:filter_group]] : @common_groups)
      if params[:limit]
        render :update do |page|  
          page.replace_html "my_activity",:partial=>'third_party_message'	
        end						
      end
    else
      redirect_to :action=> "unauthorized"
    end
  end  

  def find_thirparty_posts(group_ids)
    @collections=@user.third_party_posts(group_ids)
    @comments=@user.user_comments_group(group_ids)
    @collections<<@user.post_from_comments(@comments)
    @collections.flatten!
    @collections.uniq! unless @collections.nil?
    @collections=@collections.sort_by{|collection| collection.updated_at}.reverse 
    @collections=@collections.paginate(:page=>params[:page],:per_page=>ENTRIES_PER_PAGE) unless @collections.nil?
    @objectives=Objective.upcoming_objectives_groups(group_ids)
  end

	def upload_file
    session[:attachment] ||=[]
    session[:status_update]=params[:status_value]
  end	
  
  def post_user_comment
      unless params[:groups]
      @user_member_in=[]
      @groups=[]
      @current_membership_with_user=[]
      GroupUser.find_all_by_user_id(params[:third_party]).each do|u|
        @user_member_in<<Group.find_by_id(u.group_id)
      end
      @user_member_in.each do|g|
        c=GroupUser.find(:first,:conditions=>['group_id= ? AND user_id = ?',g.id,current_user.id])
        @current_membership_with_user<< c unless c.nil?
      end
      @current_membership_with_user.each do  |group|
        @groups << Group.find_by_id(group.group_id) unless group.nil?
      end
    else
      params[:groups].each do |name,id|
        @group=Group.find_by_id(id)
        @status_update=Post.new(:user_id=>current_user.id,:group_id=>id,:content=>params[:status],:receiver_id=>params[:id])
        @status_update.is_by_leader=true if (@group.group_leader_id==current_user.id || @group.user==current_user) && params[:post]=="is_by_leader"
        @status_update.save
        @members=@group.group_users.find(:all,:conditions=>['is_active = ? AND is_deleted = ? AND (user_id=? || user_id=?)',true,false,params[:id],current_user.id])
        @members.each do |member|
          @user_post=UserPost.new
          @user_post.user_id=member.user_id
          @user_post.post_id=@status_update.id
          @user_post.is_read=1 if current_user.id==member.user_id
          @user_post.save
          if !session[:attachment].nil?
            attached
          end
        end
      end
      flash[:post_comment]="Update posted"
      redirect_to request.referer
    end
  end
  
  def list_filter
    @user = User.find_by_id(params[:id]) 
    @common_groups = @user.group_users.map(&:group_id).uniq and current_user.group_users.map(&:group_id).uniq
  end
  
  def account_created
    
  end
  
  def unauthorized
    
  end
  
  private
  
  def validate_change_password(old_password,password,password_confirm)
    if !old_password.blank? || !password.blank? || !password_confirm.blank?
      if User.authenticate(current_user.email, old_password)
        if (!password.blank? && !password_confirm.blank?) 
          current_user.password=password
          current_user.password_confirmation=password_confirm
          if current_user.valid?
            if(password == password_confirm)
              return true
            else
              flash.now[:error]="Password mismatch"
              return false
            end
          else
            flash.now[:password_error]=current_user.errors[:password].to_a[0]
            flash.now[:password_confirm_error]=current_user.errors[:password_confirmation].to_a[0]
            return false
          end
        else
          flash.now[:error]="Password/Confirm Password Can't be blank"
          return false
        end
      else
        flash.now[:old_password_error]="Old password incorrect"
        return false
      end
    else
      return true
    end
  end
  def footer()
params[:gid]=params[:id] if params[:id]
#params[:gid]=a
if params[:gid]!="0"
        @group=Group.find_by_id(params[:gid])
        @collections=[]
         cs=current_user.user_posts.find(:all,:order=>'created_at DESC') 

         for c in cs
           
           if c.post.group_id==@group.id
             @collections<<c
           end  
          end
         @c=current_user.user_posts.find(:all,:conditions=>['is_read="false"'],:order=>'created_at DESC') 
         @objective=@group.objectives.find(:all,:conditions=>['due_date >= ? AND due_date < ?',Date.today, Date.today+7])
         @favorites=Favorite.find_all_by_user_id(current_user.id)
          if !@collections.nil?
         @collections=@collections.paginate(:page=>params[:page],:per_page=>10)
       end
else

     @collections=[]
  @collections=current_user.user_posts.find(:all,:order=>'created_at DESC') 

     @c=current_user.user_posts.find(:all,:conditions=>['is_read="false"'],:order=>'created_at DESC') 
  # @objectives=Objective.find(:all,:conditions=>['due_date >= ? AND due_date < ?',Date.today, Date.today+7])
      objectives
     @favorites=Favorite.find_all_by_user_id(current_user.id)
    if !@collections.nil?
     @collections=@collections.paginate(:page=>params[:page],:per_page=>10)
   end
   
  end

   respond_to do |format|
      format.js do
       responds_to_parent do
            render :update do |page|
              page << "close_pop()"
              page.replace_html "recent_activity_left_container",:partial=>'activities/collection'
            
          end
          end
        end   
end      
end

end

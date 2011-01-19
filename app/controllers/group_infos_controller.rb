class GroupInfosController < ApplicationController
  layout "after_login", :except=>['edit','update','edit_group','update_group','display_member','display_contacts','edit_objective_owners','update_objective_owners']
  before_filter :must_be_logged_in
  
  def new
    @group=Group.find_by_id(params[:id])
    @count=params[:count]  if params[:count]
    render :update do |page|
      page.insert_html :bottom, :add_obj, :partial=>"objectives", :object=> @count
      page.replace_html :obj_link, :partial=>"obj_link", :object=> @count
      page.replace_html :submit_button,:partial=>"submit_button"
    end
  end
  
  def objective_cancel
    @count=0
    render :update do |page|
      page.replace_html :obj_link, :partial=>"obj_link", :object=> @count
      page.replace_html :add_obj, ""
      page.replace_html :submit_button,""
    end
  end
    
    
  def create 
    k=true
    @group=Group.find_by_id(params[:id])
    i=0
    obj={}
    params[:group].each do |k,v|
      i+=1
      @objective=Objective.new(v)
      if (!params["accept"+i.to_s]  && params[:group]["objective"+i.to_s][:due_date].blank?)
        k=false
        obj["due_date_err#{i}"]="Please enter the due date or set as no due date"
      else
        obj["due_date_err#{i}"]=""
      end
      if  @objective.valid?
        obj["errors#{i}"]=""
      else
        k=false
        obj["errors#{i}"]=@objective.errors["title"].to_a[0]
      end
    end
    if k
      params[:group].each do |k,v|
        @objective=Objective.new(v)
        @objective.group_id=@group.id
        @objective.save
        @grp=GroupUser.find_all_by_group_id(@group.id)
        @grp.each do |grp|	    
        @user=User.find_by_id(grp.user_id)
          if @user.id!=current_user.id
            @user_not=UserNotification.find(:first, :conditions=>['user_id=? AND objective_update=?', grp.user_id, 1])
            UserMailer.deliver_objective(@user,@objective) if @user_not
          end
        end
        @status_update=Post.new(:user_id=>current_user.id,:group_id=>@group.id,:content=>"added new objective",:objective_id=>@objective.id,:is_group_log=>true)
        @status_update.save
        @members=@objective.group.group_users.find(:all,:conditions=>['is_active = ? AND is_deleted = ?',true,false])
        @members.each do |member|
          @user_post=UserPost.new
          @user_post.user_id=member.user_id
          @user_post.is_read=true if current_user.id==member.user_id
          @user_post.post_id=@status_update.id
          @user_post.save
        end
        if !params[k].nil? || !params[k].blank?
          params[k][:owners].split(",").each do|o|
            @objective_owner=ObjectiveUser.new
            @objective_owner.user_id=o
            @objective_owner.objective_id=@objective.id
            @objective_owner.save
          end
        end
      end
      render :update do |page|
        page.redirect_to :action=>"group_info",:id=>params[:id]
      end
    else
      render :update do |page| 
        obj.each do |k,v|
          page.replace_html k,v unless v.nil?
        end
      end
    end
  end
  
  def show
  end
  
  def edit
    @objective=Objective.find_by_id(params[:id])
  end
  
  def update
    @objective=Objective.find_by_id(params[:id])
    @objective.attributes=params[:objective]
    k=true
    k=false if params[:objective][:due_date].blank? && !params[:accept]
    if @objective.valid? && k
      @objective.update_attributes(params[:objective])
      flash[:notice]="Objectives updated"
      update_objectives
      @grp=GroupUser.find_all_by_group_id(@objective.group_id)
      @grp.each do |grp|	    
        @user=User.find_by_id(grp.user_id)
        if @user.id!=current_user.id
          @user_not=UserNotification.find(:first, :conditions=>['user_id=? AND objective_update=?', grp.user_id, 1])
          UserMailer.deliver_objective(@user, @objective) if @user_not
        end
      end
      render :update do |page|
        page.redirect_to :action=>"group_info",:id=>@objective.group_id
      end
      else
      render :update do |page| 
        page.replace_html "errorpop",@objective.errors["title"].to_a[0]
        page.replace_html "errors","Please set enter the due date or set as no due date" if params[:objective][:due_date].blank? && !params[:accept]
      end
    end
  end
  
  def destroy
    @objective=Objective.find_by_id(params[:id])
    if @objective.delete
      flash[:notice]="Objectives deleted sucessfully"
      Post.delete_all(['objective_id = ?',@objective.id])
      ObjectiveUser.delete_all(['objective_id = ?',@objective.id])
    end
    redirect_to :action=>"group_info",:id=>@objective.group_id
  end
    
  def group_info
    session[:friends] = [] 
    session[:personal_message]= [] 
    session[:filter_group]=params[:id] if params[:filter]
    @group=Group.find_by_id(params[:id])
    if (current_user.active_member?(params[:id]) &&  @group.is_active) || current_user==@group.user || current_user==@group.group_leader
      if check_group(params[:id])== true
        @count=1
        @leader=false
        @plan= PricingPlan.find(1)
        days=(Time.now-@group.created_at)/86400
        if @group.user.is_free_user &&  @group.is_active == false && days > @plan.day
          redirect_to :controller=>"group_updates", :action=>"change_paid_user",:id=>@group.id
        else
          group_objectives
          find_group_members 
        end
      else
        redirect_to :controller=>"group_infos", :action=>"wrong_group"  , :id=>params[:id]       
      end
    else
      redirect_to :controller=>"users",:action=>"unauthorized"
    end
   end
 
  def check_group(group_id)
      groups=current_user.group_users
      have_group = 0
      groups.each do |group|
         #~ have_group = 1 if group.group_id == group_id.to_i && group.group.is_active == true
         have_group = 1 if group.group_id == group_id.to_i 
      end
      return true if have_group == 1
      return false if have_group == 0
  end    
  
  def wrong_group
       @group=Group.find_by_id(params[:id])
       if  check_group(params[:id])== false
              @favorites=current_user.favorites
       else        
           redirect_to :controller=>"group_infos", :action=>"group_info"  , :id=>params[:id]
           
        end     
  end

  
  def suspend_group
    @group=Group.find_by_id(params[:id])
    if @group.is_active
      @group.update_attribute(:is_active,false)
      flash[:group_sus]="Group Activites Suspended"
    else
      @plan=@group.user.user_plan
      valid=@group.user.groups_owned.count < @plan.max_group
      if @group.user.state.nil? && valid
        @group.update_attribute(:is_active,true)
        flash[:group_sus]="Group Activites Re-Activated"
      else
        flash[:group_sus_err]="Sorry, your current plan allows you to have only #{@plan.max_group} active groups"
        flash[:group_sus_err]="Sorry, group cannot be activated" unless @group.user.state.nil?
      end
    end
    redirect_to :action=>"group_info",:id=>params[:id]
  end
  
  def edit_group
    @group=Group.find_by_id(params[:id])
  end
  
  def update_group
    @group=Group.find_by_id(params[:id])
    if @group.update_attributes(params[:group])
     render :update do |page|
        page.redirect_to :action=>"group_info",:id=>@group.id
      end
    else
      render :update do |page| 
        page.replace_html "errorpop",@group.errors["name"].to_a[0]
        page.replace_html "errorpop1",@group.errors["description"].to_a[0]
      end
    end
  end
  
  def display_member
    @group=Group.find_by_id(params[:id])
    @members=User.find_all_by_id(@group.active_members.collect{|u| u.user_id},:order=>"user_profiles.first_name ASC",:include=>:user_profile)
  end
  
  def add_group_owner
    if params[:user]
      render :update do |page|
        params[:user].each do |k,v|
          page.insert_html "owners1",k
        end
      end
    end
  end
  
  def edit_objective_owners
    @objective_owners=[]
    Objective.find(params[:id]).users.each do |u|
      @objective_owners<<u.id if u.state.nil?
    end
    @group=Objective.find(params[:id]).group
    @member=[]
    @group_members=@group.active_members
    @group_members.each do |m|
      @member<<m.user
    end
    @members=(@member.sort_by{|collection| collection.user_profile.first_name})
end
  
  def update_objective_owners
    @objective=Objective.find_by_id(params[:id])
    ObjectiveUser.delete_all(['objective_id = ?',params[:id]])
    params[:objective_owner].each do |k,v|
      @objective_owner=ObjectiveUser.new
      @objective_owner.objective_id=@objective.id
      @objective_owner.user_id=v
      @objective_owner.save
    end
    update_objectives
    redirect_to :action=>"group_info",:id=>@objective.group.id
  end
  
  def gmail
    render :partial=>"gmailcontacts"
  end
  
  def fbook
    render :partial=>"face_bookcontacts"
  end
  
  def invite_from_grouphopper
    render :partial=>"inv_grouphopper"
  end
  
  def invite_from_anywhere
    render :partial=>"from_anywhere"
  end
  
  def invite_members
    session[:friends] ||= [] 
    session[:personal_message]||= [] 
    session[:personal_message]=params[:personal_message] if params[:personal_message]
    @message=session[:personal_message]
    if params[:direct_mail]
      @invalid_mail=[]
      @direct_mails=params[:direct_mail].split /[,;\s\n]/
      @direct_mails.each do |mail|
        unless mail.strip.empty?
          if mail.match /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
            member=[]
            member[0] = ""
            member[1] = mail.strip.downcase
            session[:friends] << member
          else
            @invalid_mail<<mail
            flash.now[:mail_error]="Invalid Email ids are not Added"
          end
        end
      end
      @invalid_mail=@invalid_mail.join(', ')
      session[:friends].uniq!
      session[:friends]=contacts_uniq(session[:friends])
    end
    @group=Group.find_by_id(params[:id])
    session[:group_invite]  =  @group.id
    if params[:contact]
      @contacts = params[:contact]
      @contacts.each do |contact|
        if contact[1]=="0"
          @contacts.delete(contact[0]) 
        else
          session[:friends] << contact
        end  
      end
      session[:friends].uniq!
      session[:friends]=contacts_uniq(session[:friends])
    end
    @contacts=session[:friends]
    @message=session[:personal_message]
  end
  
  def display_contacts   
    if (params[:username] && params[:pwd])
      begin
        @contacts=Contacts::Gmail.new(params[:username], params[:pwd]).contacts
        flash[:error]=""
      rescue
        flash[:error]="Sorry Invalid email or password"
      end
    end
    if (params[:goal_flo_email] || params[:user_name])
      @result=[]
      unless params[:user_name].blank? 
        @result_name=User.find(:all,:conditions=>['user_name LIKE ? AND (state IS NULL)',"%#{params[:user_name]}%"])
        @result<<@result_name
      end
      unless params[:goal_flo_email].blank? 
        @result_mail= User.find(:all,:conditions=>['email LIKE ? AND (state IS NULL)',"%#{params[:goal_flo_email]}%"])
        @result<<@result_mail
      end
      @result.uniq!
      if @result.empty? || @result[0].empty?
        flash[:error]="Sorry, No contacts found"
      end
    end
    
  end
  
  def update_objectives
     @status_update=Post.new
      @status_update.user_id=current_user.id
      @status_update.group_id=@objective.group.id
      @status_update.content="edited the responsible member for " if params[:action]=="update_objective_owners"
      @status_update.content="edited the objective " if params[:action]=="update"
      @status_update.objective_id=@objective.id
      @status_update.is_group_log=true
      @status_update.save
      @members=@objective.group.group_users.find(:all,:conditions=>['is_active = ? AND is_deleted = ?',true,false])
      @members.each do |member|
        @user_post=UserPost.new
        @user_post.user_id=member.user_id
        @user_post.is_read= true if current_user.id==member.user_id
        @user_post.post_id=@status_update.id
        @user_post.save
      end
    end
  def final_contacts
    session[:personal_message]=params[:personal_message] if params[:personal_message]
    @message=session[:personal_message]
    if session[:friends].nil? || session[:friends].empty?
      flash[:invite_error]="Please Invite members"
      render :action=>"invite_members",:id=>params[:id]
    else
      session[:friends].each do |k,v|
        code=Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join)
        @inv=Invitation.new
        @inv.first_name=k
        @inv.email=v
        @inv.group_id=params[:id]
        @inv.invited_at=Time.now
        @inv.user_id=current_user.id
        @inv.invitation_code=code
        @inv.message=session[:personal_message]
        @inv.save
        UserMailer.deliver_invite_members(current_user,@inv) 
      end
      redirect_to :action=>"group_info",:id=>params[:id]
      flash[:invite_notice]="Invitations sent sucessfully"
      session[:friends]=[]
      session[:personal_message]=nil
    end
  end
  
  def disable_member
    @group=Group.find_by_id(params[:group_id])
    @group_users=GroupUser.find_all_by_group_id_and_user_id(params[:group_id],params[:member_id])
    @group_users.each do |group_user|
      group_user.update_attribute(:is_active,false)
    end
    flash.now[:member]="Member Disabled"
    update_members
  end
  
  def activate_member
    @group=Group.find_by_id(params[:group_id])
    if @group.allowed_to_activate?
      @group_user=GroupUser.find_by_group_id_and_user_id(params[:group_id],params[:member_id])
      @group_user.update_attribute(:is_active,true)
      flash.now[:member]="Member Activated"
    else
      flash.now[:member_error]="Sorry your current plan does not allow you to activate a member"
    end
    update_members
  end
  
  def update_members
    group_objectives
    find_group_members
    render :update do |page|
      page.replace_html "members_list",:partial=>"members_list"
      page.replace_html "group_objectives",:partial=>"group_objectives"
    end
  end
  
  def find_group_members
    @allow_edit_group=true if @group.is_active && (@group.group_leader_id==current_user.id || @group.user==current_user)
    @leader_name=User.find_by_id(@group.group_leader_id)
    @leader_name=@group.user if @leader_name.nil?
    @group_leader=(current_user==@group.user || current_user==@leader_name)
    @members=[]
    @group_members=@group_leader ? @group.all_group_members : @group.active_members
    @users=@group_members.map(&:user_id).uniq
    @members=User.find_all_by_id(@users)
    @members=@members.sort_by{|collection| collection.user_profile.first_name}
  end
  
  def group_objectives
    @favorites=current_user.favorites
    @group_color=GroupUser.group_color(@group.id,current_user.id)
    @objectives=@group.objectives.paginate(:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
  end
end

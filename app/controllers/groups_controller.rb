require 'rubygems'
#require 'contacts'
class GroupsController < ApplicationController
  #before_filter :user_login_required
  before_filter :must_be_logged_in
  layout "after_login", :except=>['display_contacts','more_footer']

  def index
    @group=Group.find_by_id(params[:id])
    @objectives=Objective.find(:all,:conditions=>['group_id = ?',@group.id])
    @invitations=Invitation.find(:all,:conditions=>['group_id = ?',@group.id])
    @message=""
    unless @invitations.empty?
      @message=@invitations[0].message
    end
  end
  
  def new
    session[:friends]=[]
    session[:personal_message]=[]
    @new_group=Group.new
  end
  
  def create
   @new_group=Group.new(params[:new_group])
    if allow_group_create && @new_group.valid?
      if (params[:new_group][:due_date].blank? && !params[:no_due_date])
        flash.now[:due_Date_error]="Please fill the due date or set as no due date"
        render :action=>"new"
      else
        @new_group.due_date=nil if params[:no_due_date]
        @new_group.user_id=current_user.id
        @new_group.group_leader_id=current_user.id
        @new_group.is_active=true
        @new_group.save
        @group_user=GroupUser.new
        @group_user.group_id=@new_group.id
        @group_user.color_code="ffffff"
        @group_user.user_id=current_user.id
        @group_user.save
        flash[:notice]="#{@new_group.name}"
        redirect_to :action=>'new_objectives', :id=>@new_group.id
      end
    else
      flash.now[:due_Date_error]="Please fill the due date or set as no due date" if (params[:new_group][:due_date].blank? && !params[:no_due_date])
      render :action=>"new"
    end
  end
  
  def edit
    @group=Group.find(params[:id])
  end
  
  def update
    @group=Group.find_by_id(params[:id])
    if (params[:group][:due_date].blank? && !params[:no_due_date]) || (params[:no_due_date] && !params[:group][:due_date].blank?)
      flash.now[:due_Date_error]="Please fill the due date or set as no due date"
      i=0
    else
      params[:group][:due_date]=nil if params[:no_due_date]
      i=1
    end  
    @group=Group.new(params[:group])   
    if @group.valid? && i!=0 
      @group=Group.find_by_id(params[:id])
      @group.update_attributes(params[:group]) 
      flash[:notice] = "#{@group.name} Was Successfully Updated."
      redirect_to :action=>'edit_objectives', :id=>@group.id
    else 
      flash.now[:due_Date_error]="Please fill the due date or set as no due date" if (params[:group][:due_date].blank? && !params[:no_due_date]) || (params[:no_due_date] && !params[:group][:due_date].blank?)
      render :action=>"edit"
    end
  end
    
  def objectives
    @count=params[:count] if params[:count]
    render :update do |page|
      page.insert_html :bottom, :new_obj, :partial=>"objectives", :object=> @count
      page.replace_html :obj_link, :partial=>"obj_link", :object=> @count
      #page.visual_effect :SlideDown, "obj_block_#{@count}"
    end
  end
  
  def new_objectives
    @objective=Objective.new
    @group_id =params[:id]
    @count=1
  end
  
  def create_objectives
    k=true
    for i in 1..(params[:objective].length)/3
      if(!params["no_due_date"+i.to_s] && params[:objective]["due_date"+i.to_s].blank?)
        flash.now["due_date_error"+i.to_s]="Please either fill the due date or set as no due date"
        k=false
      end
      if params[:objective]["label"+i.to_s].blank?
        k=false
        flash.now["objective_error"+i.to_s]="Objective name cannot be blank"
      elsif params[:objective]["label"+i.to_s].length<5
        k=false
        flash.now["objective_error"+i.to_s]="Objective name should be atleast 5 characters"
      end
      if params[:objective]["description"+i.to_s].delete("\n").length>500
        k=false
        flash.now["description_error"+i.to_s]="Description should be less the 500 characters"
      end
    end
    if k
      for i in 1..(params[:objective].length)/3
        @objective=Objective.new
        if (params["no_due_date"+i.to_s] && !params[:objective]["due_date"+i.to_s])
          @objective.due_date=nil
        else
          @objective.due_date=params[:objective]["due_date"+i.to_s]
        end
        @objective.title=params[:objective]["label"+i.to_s]
        @objective.description=params[:objective]["description"+i.to_s]
        @objective.group_id=params[:id]
        @objective.save
      end
      redirect_to :action=>"invite_members",:id=>params[:id] 
      flash[:notice]="Objectives created sucessfully"
    else
      render :action=>"new_objectives",:id=>params[:id]
    end
  end
  
  def edit_objectives
    @objectives=Objective.find(:all,:conditions=>['group_id = ?',params[:id]]) 
  end
  
  def update_objectives
    if objectives_update
      flash[:notice]="Objectives updated sucessfully"
      redirect_to :action=>"invite_members",:id=>params[:id] 
    else
      render :action=>"edit_objectives",:id=>params[:id]
    end
  end

  def invite_members
    session[:friends] ||= [] 
    session[:personal_message]||= [] 
    session[:personal_message]=params[:personal_message] if params[:personal_message]
    @message=session[:personal_message]
    add_direct_contacts
    @group=Group.find_by_id(params[:id])
    session[:group_invite]  =  @group.id
    @invitation=Invitation.find_all_by_group_id(params[:id])
    @inv=@invitation.map(&:email)
    @message=""
    unless @invitation.nil?
      if !@invitation.empty? && !params[:contact] 
        @message=@invitation[0].message 
        @invitation.each do|i|
          member=[]
          member[0] = i.first_name 
          member[1] = i.email
          session[:friends] << member
        end 
        session[:friends].uniq!
      end  
    end
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
    @contacts=contacts_uniq(session[:friends])
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
      else 
        flash[:error]=""
      end
    end
  end
  
  def add_direct_contacts
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
      @contacts=contacts_uniq(session[:friends])
      render :update do |page|
        page.replace_html "inv_mem",:partial=>"invitees_list"
      end
    end
  end
  
  def final_contacts
    if params[:contact].nil? && params[:direct_mail].nil? && !params[:personal_message].strip.empty?
      flash[:error]="Without Invitees you can't add personal messages"
      redirect_to :action=> 'review_group',:id=>params[:id]
    else
      Invitation.delete_all(["group_id = ?",params[:id]])
      unless (params[:contact].nil? || params[:contact].blank?)
        @contacts = params[:contact]
        if params[:personal_message]
          @message=params[:personal_message]
          session[:personal_message]=params[:personal_message]
        else
          @message=""
        end
        @contacts.each do |contact|
          @inv=Invitation.new
          unless contact[1]=="0"
            @inv.first_name=contact[0]
            @inv.email=contact[1].strip.downcase
          end
          @inv.message=@message
          @inv.group_id=params[:id]
          @inv.user_id=current_user.id
          @inv.save
        end
      end
      unless params[:direct_mail].nil?
        @direct_mails=params[:direct_mail].split /[,;]/
        @direct_mails.each do |mail|
          @inv=Invitation.new
          @inv.email=mail
          @inv.message=params[:personal_message] if params[:personal_message]
          @inv.group_id=params[:id]
          @inv.user_id=current_user.id
          @inv.save
        end
      end
      redirect_to :action=> 'review_group',:id=>params[:id]
    end
  end
  
  def review_group
    @group=Group.find_by_id(params[:id])
    @objectives=Objective.find(:all,:conditions=>['group_id = ?',@group.id])
    @invitations=Invitation.find(:all,:conditions=>['group_id = ?',@group.id])
    @message=""
    unless @invitations.empty?
      @message=@invitations[0].message
    end
  end
  
  def finish
    @group=Group.find_by_id(params[:id])
    @inv=Invitation.find(:all,:conditions=>['group_id = ?',params[:id]])
    unless @inv.empty?
      @inv.each do |invitation|
        code=Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join)
        invitation.update_attribute(:invitation_code,code)
        UserMailer.deliver_invite_members(current_user,invitation) 
      end
    end
    UserMailer.deliver_group_created(current_user,@group)
    #~ sleep 30
    #~ redirect_to :controller=>"users", :action=>"edit", :id=>current_user.id
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
  def review_edit_objectives
    @objectives=Objective.find(:all,:conditions=>['group_id = ?',params[:id]]) 
  end
  def review_edit_group
     @group=Group.find(params[:id])
  end
  def review_update_objectives
    if objectives_update
      flash[:notice]="Objectives updated sucessfully"
      redirect_to :action=>"review_group",:id=>params[:id] 
    else
      render :action=>"review_edit_objectives",:id=>params[:id]
    end
  end
  def review_update_group
    @group=Group.find_by_id(params[:id])
    if (params[:group][:due_date].blank? && !params[:no_due_date]) || (params[:no_due_date] && !params[:group][:due_date].blank?)
      flash.now[:due_Date_error]="Please fill the due date or set as no due date"
      render :action=>'review_edit_group'
    else
      if params[:no_due_date]
        params[:group][:due_date]=nil
      end
      if @group.update_attributes(params[:group])
        flash[:notice] = 'Group Was Successfully Updated.'
        redirect_to :action=>'review_group', :id=>@group.id
      else
        render :action=>"review_edit_group"
      end
    end
  end
  
  def objectives_update
    old=Objective.find(:all,:conditions=>['group_id = ?',params[:id]]).count
    k=true
    for i in 1..(params[:objective].length)/3
      if(!params["no_due_date"+i.to_s] && params[:objective]["due_date"+i.to_s].blank?)
        flash.now["due_date_error"+i.to_s]="Please either fill the due date or set as no due date"
        k=false
      end
      if params[:objective]["label"+i.to_s].blank?
        k=false
        flash.now["objective_error"+i.to_s]="Objective name cannot be blank"
      elsif params[:objective]["label"+i.to_s].length<5
        k=false
        flash.now["objective_error"+i.to_s]="Objective name should be atleast 5 characters"
      end
      if params[:objective]["description"+i.to_s].length>500
        k=false
        flash.now["description_error"+i.to_s]="Description should be less the 500 characters"
      end
    end
    if k
      @obj=Objective.find(:all,:conditions=>['group_id = ?',params[:id]])
      for i in 1..(params[:objective].length)/3
        if i<=old
          @objective=Objective.find(@obj[i-1].id)
          if (params["no_due_date"+i.to_s] && !params[:objective]["due_date"+i.to_s])
            @objective.update_attribute(:due_date,nil)
          else
            @objective.update_attribute(:due_date,params[:objective]["due_date"+i.to_s])
          end
          @objective.update_attribute(:title,params[:objective]["label"+i.to_s])
          @objective.update_attribute(:description,params[:objective]["description"+i.to_s])
        else
          @objective=Objective.new
          if (params["no_due_date"+i.to_s] && !params[:objective]["due_date"+i.to_s])
            @objective.due_date=nil
          else
            @objective.due_date=params[:objective]["due_date"+i.to_s]
          end
          @objective.title=params[:objective]["label"+i.to_s]
          @objective.description=params[:objective]["description"+i.to_s]
          @objective.group_id=params[:id]
          @objective.save
        end
      end
    end
    return k
  end
  def list
    session[:filter_group]=nil if params[:filter]
    if session[:filter_group] && session[:filter_group]!="0"
      @group=Group.find_by_id session[:filter_group]
      if @group.is_active || current_user==@group.user || current_user==@group.group_leader
        @groups=[Group.find_by_id(params[:gid])]
        @objectives=@group.group_upcoming_objectives
      else
        @groups,@objectives=[],[]
      end
    else
      @user_groups=current_user.group_active_membership+current_user.owned_group_users
      @user_groups.uniq!
      @groups=Group.find_all_by_id(@user_groups.collect{|g| g.group_id})
      @objectives=current_user.upcoming_objectives_all
    end
    @favorites=current_user.favorites
  end 
  
  def footer_dashboard
    session[:filter_group]=params[:gid]
    @group=Group.find_by_id(params[:gid])
    @favorites=Favorite.find_all_by_user_id(current_user.id)
    if @group.is_active || current_user==@group.user || current_user==@group.group_leader
      @groups=[Group.find_by_id(params[:gid])]
      @objectives=@group.group_upcoming_objectives
    else
      @groups,@objectives=[],[]
    end
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "group_landing_activity_left_container",:partial=>'group_landing'
        page.replace_html "footer_dashboard",:partial=>'footer_group_dashboard'
      end			
    end    
  end
  def more_footer
      @groups=current_user.group_users.find(:all,:conditions=>['group_users.is_active=? AND is_deleted=?',true,false],:order=>'groups.name',:include=>:group)
      
    end
    
  def allow_group_create
    #@plan=current_user.pricing_plan unless current_user.is_free_user
    #@plan=PricingPlan.find :first if current_user.is_free_user
    @plan=current_user.user_plan
    #if @plan.max_group>current_user.groups.size
    if @plan.max_group>current_user.groups_owned.count
      return true
    else
      flash[:plan_warning]="Sorry, your current plan does not support you to create a new group"
      return false
    end
  end
    
end

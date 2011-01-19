class GroupActivitiesController < ApplicationController
  layout "after_login"
  #before_filter :user_must_be_logged_in
  skip_filter :clear_attachment_session
  layout "after_login", :except=>['create','status_comment','post_comment','comment_attachment','display_groups']
  def new
  end
  def create
    @groups= current_user.group_active_membership
    if !params[:groups].nil? && !params[:groups].blank?
      params[:groups].each do|k,v|
        post_status_update(v,params[:post])
      end
    remove_session_files
    refer_index_group_update if !params[:grp_id].blank?
      if request.xml_http_request?
        render :update do |page|    
       
          page <<"close_pop()" 
          page.replace_html "count_file", ""  
          page<<"clear_status_update()"           
          page.replace_html "group_update_left_container",:partial=>'group_updates/collection' if !params[:grp_id].blank?
        end			
      end 
      #redirect_to request.referer
    elsif params[:id]
      post_status_update(params[:id],params[:post])
      flash[:status_update]="Status Update Posted"
      remove_session_files
      redirect_to request.referer
    end
  end
 
  def add_group_member
    if session[:invited_member] 
      group_id=session[:invited_member].group_id
      @user= session[:invited_member].user
      @invitation=session[:invited_member]
      @invitation.update_attribute(:invitation_code,nil)    
    elsif session[:invited_leader]
      group_id=session[:invited_leader].id 
      @user= session[:invited_leader].user
      @leader_group=session[:invited_leader]
      @leader_group.update_attribute(:invitation_code,nil)      
    elsif session[:facebook_invite_group_id] 
      group_id=session[:facebook_invite_group_id] 
      @group=Group.find_by_id(session[:facebook_invite_group_id])
      @user= @group.user
    end
    if group_id && @user
      @group=Group.find_by_id(group_id)
      if @group.allowed_to_activate?
        @group_user=current_user.group_users.find_by_group_id(group_id)
        if @group_user
          @group_user.update_attributes(:is_active=>true,:is_deleted=>false)
        else
          @member=GroupUser.new(:user_id=>current_user.id,:group_id=>group_id,:color_code=>"ffffff") 
          @member.save
        end
        @group.update_attribute(:group_leader_id,current_user.id) if session[:invited_leader] 
        UserMailer.deliver_member_added(current_user,@user,@group)
        remove_inv_session
        flash[:notice]="Congratulations! successfully joined to the group"
        redirect_to :controller=>"group_infos",:action=>"group_info",:id=>group_id
      else
        remove_inv_session
        flash[:warning]="Sorry, Unable to add you in group"
        redirect_to :controller=>"activities",:action=>"index"
      end
    else
      redirect_to :controller=>"activities",:action=>"index"
    end
  end

  def create_group
    @current_plan=current_user.user_plan
    @no_of_groups_owned=current_user.groups_owned.count
    @max_group=@current_plan.max_group
    if @no_of_groups_owned>=@max_group
      flash[:warning]="Sorry, you have crossed the limits, please upgrade your plan to create new groups"
      redirect_to :back
    else
      redirect_to :controller=>"groups",:action=>"new"
    end
  end
  
  def status_comment
  end
  
  def comment_attachment
    @comment=Comment.find_by_id params[:id]
  end
  
  def post_comment
    @comment=Comment.new(:post_id=>params[:id],:user_id=>current_user.id,:content=>params[:comment])
    @post=Post.find_by_id params[:id]
    @comment.receiver_id=@post.receiver_id unless @post.receiver_id.nil?
    @comment.receiver_id=params[:receiver_id] if !params[:receiver_id].nil?                  
    @comment.save
    if params[:attachment]
      @attach=Hash.new
      params[:attachment].each do|k,v|
        unless params[:attachment][k].nil?
          @attach["uploaded_data"]=params[:attachment][k]
          @attachment=Attachment.new(@attach)
          @comment.attachments<<@attachment
        end
      end
    end
    @post.update_attribute(:updated_at,Time.now)
    @user_post=current_user.user_posts.find_by_post_id(@post.id)
    current_user.user_posts.create(:post_id=>@post.id,:is_read=>true) if @user_post.nil?
    @group_members=@post.group.active_members
    @group_members.each do |mem|
      user_post=mem.user.user_posts.find_by_post_id(@post.id)
      mem.user.user_posts.create(:post_id=>@post.id) if user_post.nil?
    end
    @user_posts=UserPost.find(:all,:conditions=>['post_id=?',@post.id])
    @user_posts.each do |user_post|
      user_post.update_attributes(:is_read=>user_post.user_id==current_user.id,:updated_at=>Time.now) 
    end
    redirect_to :back
  end
  
  def attachment_file
    @count=params[:count] if params[:count]
    render :update do |page|
      page.insert_html :bottom, :new_upload, :partial=>"upload_new",:object=> @count
      page.replace_html :attachment, :partial=>"attachment",:object=> @count
    end
  end
  
  def display_groups
    @groups= current_user.group_active_membership
  end
  private
  def is_member_allowed(group)
    #~ @group=Group.find_by_id(group_id)
    #~ @owner_plan=@group.user.pricing_plan
    #~ if @owner_plan.nil?
      #~ @max_members=PricingPlan.find(:first).max_users_in_group
    #~ else
      #~ @max_members=@owner_plan.max_users_in_group
    #~ end
    @max_members=group.user.user_plan.max_users_in_group
    if @max_members>group.group_users.find(:all,:conditions=>['is_deleted= ?',false]).count
      return current_user.group_users.find(:first,:conditions=>['group_id=? AND is_deleted=?',group.id,false]).nil?
    else
      return false
    end
  end
  def refer_index_group_update
    @group=Group.find_by_id(params[:grp_id])
    @plan= PricingPlan.find(1)
    days=(Time.now-@group.created_at)/86400
    if current_user.is_free_user && @group.is_active == false && days > @plan.day
      render :action=>"change_paid_user" ,:id=>@group.id
      else
    @collections=@group.posts.find(:all,:order=>'created_at DESC') 
    @favorites=Favorite.find_all_by_user_id(current_user.id)
    @limit=20
    @objectives= Objective.find_all_by_group_id(@group.id,:conditions=>['due_date >= ? AND due_date < ?',Date.today, Date.today+7])
    @group_color=GroupUser.group_color(@group.id,current_user.id)
    @unread= current_user.user_posts.find(:all, :conditions => ["posts.group_id= ? and is_read = ?",@group.id, 0], :include=>"post").size
     if !@collections.nil?
     @collections=@collections.paginate(:page=>params[:page],:per_page=>10)
   end 
    end
    end
end

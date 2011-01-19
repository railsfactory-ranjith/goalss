class GroupUpdatesController < ApplicationController
 layout "after_login",:except=>['other_groups_footer']
 skip_filter :clear_attachment_session, :only => [:new_group_update]
 before_filter :must_be_logged_in
  def index
    group_id=params[:id]
    if params[:gid]
      group_id=params[:gid] 
      params[:id]=params[:gid] 
      session[:filter_group]=params[:gid] 
    end
    @group=Group.find_by_id(group_id)
    if (current_user.active_member?(group_id) &&  @group.is_active) || (current_user==@group.user || current_user==@group.group_leader)
      if check_group(group_id)== true
        @plan= PricingPlan.find(1)
        days=(Time.now-@group.created_at)/86400
        if current_user.is_free_user && @group.is_active == false && days > @plan.day
          render :action=>"change_paid_user" ,:id=>@group.id
        else
          find_group_updates
          @posts=@group.posts.find(:all,:conditions=>["receiver_id is null"],:select=>'id',:order=>'created_at ASC') 
          @last_post=@posts.last unless @posts.empty?
          session[:last_group_update]=@last_post.id unless @last_post.nil?
          @posts=@group.posts.find(:all,:conditions=>["receiver_id is null"],:select=>'id',:order=>'created_at ASC') 
          @last_comment=Comment.find(:last,:conditions=>['posts.group_id=?',group_id],:include=>:post)
          session[:last_group_comment]=@last_comment.id unless @last_comment.nil?
        end 
      else
        redirect_to :action=>"wrong_group"  , :id=>group_id
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
           redirect_to :controller=>"group_updates", :action=>"index"  , :id=>params[:id]
           
        end     
    end
    
    
  
  def save_user_detail
    @group=Group.find_by_id(params[:gid])
    @id=params[:gid]
    @unread_user_posts = current_user.user_posts.find(:all, :conditions => ["posts.group_id= ? AND is_read = ?", @group.id, 0], :include=>"post")
    @unread_user_posts.each do |user_post|
      user_post.update_attributes(:is_read=>1)   if user_post.leader_update_read
    end  
    @favour=current_user.favorites.find(:all,:conditions=>['group_id=?',params[:gid]])
    find_group_updates
     if request.xml_http_request?
      render :update do |page|      
        page.replace_html "group_update_left_container", :partial=>'collection', :object=>@id
        page.replace_html "footer_replace#{params[:gid]}","#{truncate(@group.name,10)}(#{@unread})" if !@favour.blank? 
        page.replace_html "activity_count",:partial=>"activities/activity_count"
      end			
    end       
  end
  
  def send_leader_mail
    @id=params[:gid]
    @group=Group.find_by_id(params[:gid])
    @user_post=current_user.user_posts.find(:first, :conditions=>['post_id = ? AND user_id = ?', params[:id], current_user.id],:order=>'created_at DESC')
    @user_post.update_attributes(:is_read=>1,:leader_update_read=>true)
    UserMailer.deliver_send_read_recepit(@user_post) 
    find_group_updates
    @favour=current_user.favorites.find(:all,:conditions=>['group_id=?',params[:gid]])
    params[:id]=params[:gid] if params[:gid] && params[:id]
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "group_update_left_container",:partial=>'collection',:object=>@id
        page.replace_html "footer_replace#{params[:gid]}","#{truncate(@group.name,10)}(#{@unread})" if !@favour.blank? 
        page.replace_html "activity_count",:partial=>"activities/activity_count"
      end
    end  
  end    
  
  def older_post
    @group=Group.find_by_id(params[:gid])
    find_group_updates
    @limit=params[:limit].to_i+20
    @id=params[:gid]
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "group_update_left_container",:partial=>'collection',:object=>@id
      end			
    end 
  end 
  def change_paid_user
        @group=Group.find_by_id(params[:id])
    end
      
  def other_groups_footer
    @membership=current_user.group_membership
  end

  def new_group_update
    @group=Group.find_by_id params[:group]
    @id=params[:group]
    @posts=@group.posts.find(:all,:conditions=>["receiver_id is null"],:select=>'id',:order=>'created_at ASC') 
    @last_post=@posts.last unless @posts.empty?
    @last_comment=Comment.find(:last,:conditions=>['posts.group_id=?',params[:group]],:include=>:post)
    find_group_updates
    if session[:last_group_update] && @last_post && (session[:last_group_update]<@last_post.id || (session[:last_group_comment] && @last_comment && session[:last_group_comment] <@last_comment.id)) 
      render :update do |page|      
        page.replace_html "group_update_left_container",:partial=>'collection',:object=>@id
        page.replace_html "activity_count",:partial=>"activities/activity_count"
      end			 
    else
      render :nothing=>true
    end
  end

  def find_group_updates
    #~ @collections=@group.posts.find(:all,:conditions=>["receiver_id is null"],:order=>'updated_at DESC') 
    @leader_updates=@group.posts.find(:all,:conditions=>["receiver_id is null AND is_by_leader IS NOT NULL AND user_posts.user_id=? AND user_posts.leader_update_read=?",current_user.id,false],:include=>:user_posts,:order=>'posts.updated_at DESC') 
    @other_updates=@group.posts.find(:all,:conditions=>["receiver_id is null"],:order=>'updated_at DESC') 
    @collections=@leader_updates+@other_updates
    @collections.uniq!
    @favorites=Favorite.find_all_by_user_id(current_user.id)
    @limit=20
    @objectives= Objective.find_all_by_group_id(@group.id,:conditions=>['due_date >= ? AND due_date < ?',Date.today, Date.today+7])
    @group_color=GroupUser.group_color(@group.id,current_user.id)
    @unread= current_user.user_posts.find(:all, :conditions => ["posts.group_id= ? and is_read = ? and posts.receiver_id is null",@group.id, 0], :include=>"post").size
    @collections=@collections.paginate(:page=>params[:page],:per_page=>10)  
  end

end

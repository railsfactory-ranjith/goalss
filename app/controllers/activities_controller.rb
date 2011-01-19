class ActivitiesController < ApplicationController
layout "after_login", :except=>['more_footer','attachment','new_create','display_groups']
skip_filter :clear_attachment_session, :only => [:upload_file,:new_create,:create,:new_updates,:display_groups]
before_filter :must_be_logged_in
  def index
    session[:filter_group]=nil if params[:filter]
    recent_activity
    @last=current_user.user_posts.find(:last)
    session[:last_update]=@last.id unless @last.nil?
    @last_comment=Comment.find(:last,:conditions=>{'post_id'=>current_user.user_posts.find(:all).collect{|post| post.post_id}})
    session[:last_comment]=@last_comment.id unless @last_comment.nil?
    @invitation=session[:invited_member] if session[:invited_member]
    @invitation=session[:invited_leader] if session[:invited_leader] 
    @invitation=Group.find_by_id(session[:facebook_invite_group_id])  if session[:facebook_invite_group_id]
    @group=Group.find_by_id(session[:facebook_invite_group_id]) if session[:facebook_invite_group_id]
    @group=Group.find_by_id(session[:invited_member].group_id) if session[:invited_member]
    @group=session[:invited_leader] if session[:invited_leader]
  end
  
  def create
    @groups=current_user.active_group_membership
    if !params[:groups].nil? && !params[:groups].blank? 
      params[:groups].each do|k,v|
        post_status_update(v,params[:post])
      end
      remove_session_files
      redirect_to :action=>"footer1" ,:gid=>params[:id]
    elsif params[:id]
      post_status_update(params[:id],params[:post])
      flash[:status_update]="Status Update Posted"
      remove_session_files
      if params[:control]=="myactivity"
        footer_myactivity
      else
        footer1 
      end
    end
  end
  
  def save_user_detail
    @collections=session[:filter_group] ? current_user.group_updates(session[:filter_group]) : current_user.user_status_updates
    @collections.each do |c|
      c.update_attributes(:is_read=>1)  if c.leader_update_read
    end 
    recent_activity     
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "recent_activity_left_container",:partial=>'collection'
        page.replace_html "top_activity",:partial=>'top_activity'
        page.replace_html "footer_filter",:partial=>'footer_filter'
      end			 
    else
      footer1        
    end
  end
  
  def send_leader_mail
    @c=current_user.user_posts.find_by_id(params[:id])
    @c.update_attributes(:is_read=>1,:leader_update_read=>true)
    UserMailer.deliver_send_read_recepit(@c) 
    recent_activity
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "recent_activity_left_container",:partial=>'collection'
        page.replace_html "top_activity",:partial=>'top_activity'
        page.replace_html "footer_filter",:partial=>'footer_filter'
      end			
    end   
  end   
  
  def recent_activity
    session[:filter_group] ? filter(session[:filter_group]) : recent_activity_updates
  end
  
  def my_activities
    session[:filter_group]=nil if params[:filter]
    session[:filter_group] ? my_activity_filter(session[:filter_group]) : find_my_activity
  end
  
  def my_activity_save_user_detail
    @collections=session[:filter_group] ? current_user.my_group_updates(session[:filter_group]) : current_user.my_user_status_updates
    for c in @collections
      c.update_attributes(:is_read=>1)  if c.leader_update_read
    end
    session[:filter_group] ? my_activity_filter(session[:filter_group]) : find_my_activity
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "my_activity_left_container",:partial=>'my_collection'
        page.replace_html "footer_myactivity",:partial=>'footer_myactivity'
      end			
    end   
  end

  def my_activity_send_leader_mail
    @c=current_user.user_posts.find_by_id(params[:id])
    @c.update_attributes(:is_read=>1,:leader_update_read=>true)
    UserMailer.deliver_send_read_recepit(@c) 
    session[:filter_group] ? my_activity_filter(session[:filter_group]) : find_my_activity
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "my_activity_left_container",:partial=>'my_collection'
        page.replace_html "top_my_activity",:partial=>'top_my_activity'
        page.replace_html "footer_myactivity",:partial=>'footer_myactivity'
      end			
    end   
  end
  
  def footer1()
    params[:gid]=params[:id] if params[:id]
    @group=Group.find_by_id(params[:gid])
    my_activity_filter(params[:gid])
    if request.xml_http_request? 
      render :update do |page| 
        page.replace_html "top_activity",:partial=>"activities/top_activity"
         page.replace_html "recent_activity_left_container",:partial=>'collection'
        page.replace_html "footer_filter",:partial=>'footer_filter'
      end
    end  
  end
  
  def footer()
    params[:gid]=params[:id] if params[:id] && !params[:gid]
    session[:filter_group]=params[:gid] unless params[:gid].blank? || params[:gid]=="0"
    if session[:filter_group]
      filter(session[:filter_group])   
    else
     index
    end
    if  params[:action]!="footer" 
      respond_to do |format|
        format.js do
          responds_to_parent do
            render :update do |page|
              page << "close_pop()"
              page.replace_html "top_activity",:partial=>"activities/top_activity"
              page.replace_html "recent_activity_left_container",:partial=>'activities/collection'
              page.replace_html "footer_filter",:partial=>'footer_filter'
            end
          end
        end   
      end      
    else
      if request.xml_http_request? 
        render :update do |page| 
          page.replace_html "top_activity",:partial=>"activities/top_activity"
          page.replace_html "recent_activity_left_container",:partial=>'collection'
          page.replace_html "footer_filter",:partial=>'footer_filter'
        end
      end  
    end
  end
  
	def upload_file
    session[:attachment] ||=[]
    session[:status_update]=params[:status_value]
    @attach=Hash.new
    if params[:attachment]
      params[:attachment].each do|k,v|
        if !params[:attachment][k].nil?
          @attach["uploaded_data"]=params[:attachment][k]
          @attachment=Attachment.new(@attach)
          @attachment.save
          session[:attachment]<< @attachment.id
        end
      end
      footer  if params[:control]=="activity"
      footer_myactivity if params[:control]=="myactivity"
      if params[:control]=="group"
        respond_to do |format|
          format.js do
            responds_to_parent do
              render :update do |page|
                page << "close_pop()"
                page.replace_html "count_file", "(#{session[:attachment].count})"
                page.replace_html "attach_notify","File attached"
              end
            end
          end   
        end   
      end
    else
      redirect_to request.referer
    end
  end	
    
  def footer_myactivity
    params[:gid]=params[:id] if params[:id]
    session[:filter_group]=params[:gid] if params[:gid]!="0"  && !params[:gid].blank?
    if session[:filter_group]
      my_activity_filter(session[:filter_group])
    else
      my_activities
    end
    if  params[:action]!="footer_myactivity" && params[:action]!="create" && params[:action]!="new_create" && params[:action]!="my_activity_save_user_detail"
      respond_to do |format|
        format.js do
          responds_to_parent do
            render :update do |page|
              page << "close_pop()"
              page.replace_html "top_my_activity",:partial=>'activities/top_my_activity'
              page.replace_html "my_activity_left_container",:partial=>'activities/my_collection'
              page.replace_html "footer_myactivity",:partial=>'footer_myactivity'
            end
          end
        end   
      end     
    else
      if request.xml_http_request?
        render :update do |page|    
          if params[:action]=="new_create"
            page <<"close_pop()" 
          end
          page.replace_html "top_my_activity",:partial=>'top_my_activity'
          page.replace_html "my_activity_left_container",:partial=>'my_collection'
          page.replace_html "footer_myactivity",:partial=>'footer_myactivity'
        end			
      end 
    end
  end
  def expand_post
    @post=Post.find_by_id(params[:id])
    render :update do |page|
      #~ page.replace_html params[:div],simple_format(wrap_text(@post.content,80))+%Q{<a  style="color: rgb(255, 120, 0);"onclick="new Ajax.Request('/activities/less_post/#{params[:id]}?div=#{params[:div]}', {asynchronous:true, evalScripts:true}); return false;" href="#">Less</a>}
      page.replace_html params[:div],"<pre>"+h(wrap_text(@post.content,80))+%Q{<a  style="color: rgb(255, 120, 0);"onclick="new Ajax.Request('/activities/less_post/#{params[:id]}?div=#{params[:div]}', {asynchronous:true, evalScripts:true}); return false;" href="#">Less</a></pre>}
    end
  end
  def less_post
    @post=Post.find_by_id(params[:id])
    render :update do |page|
      #~ page.replace_html params[:div],simple_format(wrap_text(truncate(@post.content,100),80))+%Q{<a style="color: rgb(255, 120, 0);" onclick="new Ajax.Request('/activities/expand_post/#{params[:id]}?div=#{params[:div]}', {asynchronous:true, evalScripts:true}); return false;" href="#">More</a>}
      page.replace_html params[:div],"<pre>"+h(wrap_text(truncate(@post.content,100),80))+%Q{<a style="color: rgb(255, 120, 0);" onclick="new Ajax.Request('/activities/expand_post/#{params[:id]}?div=#{params[:div]}', {asynchronous:true, evalScripts:true}); return false;" href="#">More</a></pre>}
    end
  end
  def expand_comment
    @comment=Comment.find_by_id(params[:id])
    render :update do |page|
      #~ page.replace_html params[:div],simple_format(wrap_text(@comment.content,50))+%Q{<a  style="color: rgb(255, 120, 0);"onclick="new Ajax.Request('/activities/less_comment/#{params[:id]}?div=#{params[:div]}', {asynchronous:true, evalScripts:true}); return false;" href="#">Less</a>}
      page.replace_html params[:div],"<pre>"+h(wrap_text(@comment.content,50))+%Q{<a  style="color: rgb(255, 120, 0);"onclick="new Ajax.Request('/activities/less_comment/#{params[:id]}?div=#{params[:div]}', {asynchronous:true, evalScripts:true}); return false;" href="#">Less</a></pre>}
    end
 end
  def less_comment
    @comment=Comment.find_by_id(params[:id])
    render :update do |page|
      #~ page.replace_html params[:div],simple_format(wrap_text(truncate(@comment.content,60),60))+%Q{<a style="color: rgb(255, 120, 0);" onclick="new Ajax.Request('/activities/expand_comment/#{params[:id]}?div=#{params[:div]}', {asynchronous:true, evalScripts:true}); return false;" href="#">More</a>}
      page.replace_html params[:div],"<pre>"+h(wrap_text(truncate(@comment.content,60),60))+%Q{<a style="color: rgb(255, 120, 0);" onclick="new Ajax.Request('/activities/expand_comment/#{params[:id]}?div=#{params[:div]}', {asynchronous:true, evalScripts:true}); return false;" href="#">More</a></pre>}
    end
  end

  def attachment
    @post=Post.find(params[:id])
    @dup=DupAttachment.find_all_by_post_id(params[:id])
  end

  def new_create
    session[:allow_to_clear] = false
    @groups= current_user.active_group_membership
    if !params[:groups].nil? && !params[:groups].blank? 
      params[:groups].each do|k,v|
        post_status_update(v,params[:post])
      end
      remove_session_files
      if params[:control]=="activity" && session[:filter_group]
        footer_share
      elsif params[:control]=="activity" && !session[:filter_group]
        index
        if request.xml_http_request?
          render :update do |page|     
            page <<"close_pop()"          
             page.replace_html "recent_activity_left_container",:partial=>'collection'
             page.replace_html "top_activity",:partial=>'top_activity'
             page.replace_html "footer_filter",:partial=>'footer_filter'
            end			
        end    
      else
       footer_myactivity 
      end
    elsif params[:id]
      post_status_update(params[:id],params[:post])
      flash[:status_update]="Status Update Posted"
      remove_session_files
      redirect_to :back ,:gid=>params[:id]
    end
  end
  
  def display_groups
    session[:allow_to_clear] = false
    @groups= current_user.active_group_membership
  end
  
   def decline_inv
    if session[:invited_member]
      @invitation=session[:invited_member] 
      UserMailer.deliver_invitation_declined(current_user,@invitation.user,@invitation.group)
      @invitation.update_attribute(:invitation_code,nil)
    elsif session[:invited_leader]
      @invitation=session[:invited_leader] 
      UserMailer.deliver_invitation_declined(current_user,@invitation.user,@invitation)
      @invitation.update_attribute(:invitation_code,nil)
    end
    remove_inv_session
    render :update do |page|
      page.replace_html "msg","You have declined the invitation"
    end
  end
  
  def my_activity_filter(group_id)
    @group=Group.find_by_id group_id
    @favorites=current_user.favorites 
    if current_user.is_active_member?(group_id)
      @objectives=@group.group_upcoming_objectives
      @collections=current_user.my_group_updates(group_id)
      a=0
      @unread=@collections.count{|x| a+=1 if x.is_read==false}
      @objectives=@group.group_upcoming_objectives
    else
      @objectives,@collections,@unread=[],[],0
    end
    paginate_collections
  end
  
  def filter(group_id)
    @group=Group.find_by_id group_id
    if current_user.is_active_member?(group_id) 
      @objectives=@group.group_upcoming_objectives
      @collections=current_user.group_updates(@group.id)
      @unread=current_user.user_unread_group_updates(@group.id).count
    else
      @objectives,@collections,@unread=[],[],0
    end
    paginate_collections
    @favorites=current_user.favorites
  end

  def recent_activity_updates
    @favorites=current_user.favorites
    @collections=current_user.user_status_updates 
    @unread=current_user.user_unread_status_updates.count
    paginate_collections
    @objectives=current_user.upcoming_objectives_all
  end
  
  def no_filter_my_activity
    @collections=[]
    @collections=current_user.my_user_status_updates
    a=0
    @unread=@collections.count{|x| a+=1 if x.is_read==false}
   end
    
  def more_footer
    @groups=current_user.group_membership
  end
  
  def new_updates
	  
	  
	  puts "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH"
    @last=current_user.user_posts.find(:last)
    @last_comment=Comment.find(:last,:conditions=>{'post_id'=>current_user.user_posts.find(:all).collect{|post| post.post_id}})
    @favorites=current_user.favorites
    if session[:last_update] && @last && (session[:last_update]<@last.id || (session[:last_comment] && @last_comment && session[:last_comment] <@last_comment.id))
      session[:last_update]=@last.id unless @last.nil?
      session[:last_comment]=@last_comment.id unless @last_comment.nil?
        case params[:control]
          when "activities"
            session[:filter_group] ? filter(session[:filter_group]) : find_recent_activity
          when "recent_activities"
            session[:filter_group] ?  my_activity_filter(session[:filter_group]) : find_my_activity
        end
      paginate_collections
      render :update do |page|      
        page.replace_html "recent_activity_left_container",:partial=>'collection' if params[:control]=="activities"
        page.replace_html "footer_filter",:partial=>'footer_filter' if params[:control]=="activities"
        page.replace_html "footer_myactivity",:partial=>'footer_myactivity' if params[:control]=="recent_activities"
        page.replace_html "my_activity_left_container",:partial=>'my_collection' if params[:control]=="recent_activities"
        page.replace_html "activity_count",:partial=>'activity_count' 
      end		
    else
      render :nothing=>true
    end
  end
  
  def find_recent_activity
    @collections=current_user.user_status_updates 
    @unread=current_user.user_unread_status_updates.count
    @objectives=current_user.upcoming_objectives_all
    paginate_collections
  end
  
  def find_my_activity
    @favorites=current_user.favorites 
    @collections=current_user.my_user_status_updates
    a=0
    @unread=@collections.count{|x| a+=1 if x.is_read==false}
    @objectives=current_user.upcoming_objectives_all
    paginate_collections
  end
  
  def download_file
    a = Attachment.find_by_id(params[:id])
    send_file RAILS_ROOT+"/public"+a.public_filename
  end
  
  def paginate_collections
    @collections=@collections.paginate(:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
  end
  
end

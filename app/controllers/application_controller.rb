# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'authenticated_system.rb'
 require 'user_authenticated_system.rb'
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  ENTRIES_PER_PAGE=10
 # protect_from_forgery # See ActionController::RequestForgeryProtection for details
    include ExceptionNotifiable
    include UserAuthenticatedSystem
    include AuthenticatedSystem
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  before_filter :clear_attachment_session
  #~ ActiveMerchant::Billing::Base.gateway_mode = :test 
  
=begin
  before_filter :prepare_for_mobile

private

def mobile_device?
  if session[:mobile_param]
      puts "if"
    session[:mobile_param] == "1"
  else
      puts "else"
    request.user_agent =~ /Mobile|webOS/
  end
end
helper_method :mobile_device?

def prepare_for_mobile
    puts "prepare_for_mobile"
  session[:mobile_param] = params[:mobile] if params[:mobile]
  request.format = :mobile if mobile_device?
end
=end

def clear_attachment_session
if session[:allow_to_clear]
      session[:attachment] = nil
      session[:status_update]=nil
else
session[:allow_to_clear] = true
end    
end  

#use in before filter
  def must_be_logged_in
    if current_user.nil? || !current_user.state.nil?
        flash[:notice] = "you need to be logged in to access this section"
    redirect_back_or_default('/')
    return
    end
  end
  def must_be_admin_user_logged_in
    if current_admin.nil?
        flash[:notice] = "you need to be logged in to access this section"
    redirect_back_or_default('/admin')
    return
    end
    #~ if session[:admin_user] && session[:admin_user] == true 
        #~ flash[:notice] = "you need to be logged in to access this section"
    #~ redirect_back_or_default('/')
    #~ return
    #~ end
  end
  
  def contacts_uniq(arr)
    unless arr[0].nil?
      temp=[]
      temp<< arr[0]
      k=true
      arr.each do |i|
        unless i.include?(nil)
          temp.each do |j|
            if j.include?(i[1])
              k=false
            end
          end
          temp<< i if k
          k=true
        end
      end
      return temp
    end
end

  def creditcard_gateway
     @gateway  =  ActiveMerchant::Billing::PaypalExpressRecurringGateway.new(
     #~ :login => 'sedin1_1276506469_biz@gmail.com' ,
        #~ :password => '276506409',
        #~ :signature => 'AzeGAKVf4cnFsz5U3DTNc0cWCKPUAbEC1EzvvolKoV4kdT6uPwWYfeUc '
        
                #~ :login => 'sedin1_1276506469_biz_api1.gmail.com' ,
                #~ :password => '1276506478',
                #~ :signature => 'AzeGAKVf4cnFsz5U3DTNc0cWCKPUAbEC1EzvvolKoV4kdT6uPwWYfeUc' 



                #~ :login => 'sedin2_1276837882_biz_api1.gmail.com' ,
                #~ :password => '1276837891',
                #~ :signature => 'AFcWxV21C7fd0v3bYYYRCpSSRl31AR.EspGl3ziSs0pXt1OSBhpHpK2H'
                
                
                
                #~ :login => 'sedin1_1276780888_biz_api1.gmail.com' ,
                #~ :password => '1276780896',
                #~ :signature => 'Ak.AULYvvULdXvHRic-oDtENmEGsAK6ITsakgsJXj.RaIumaqyt4Ao1g'
                
                                
                :login => 'sedint_1276779670_biz_api1.yahoo.in' ,
                :password => '1276779675',
                :signature => 'AFcWxV21C7fd0v3bYYYRCpSSRl31AZhmDj5NFV1ftuNaeuS-6YYFO8nH'
                
                
                
       #~ :login => 'sedin1_1266820278_biz_api1.gmail.com' ,
        #~ :password => '1266820284',
        
        #~ :signature => 'A.dX9BS5svfwy7iKkP3L-KhdX97QABLEfJMsGVIaVdOfMg.KnFKf4PC7'
        )
end

  def log_updates_for
     @log=AdminLog.new(:user_id=>@group.user_id,:admin_id=>current_admin.id,:comment=>"#{@mess} #{@group.name} ",:group_id=>@group.id)
      @log.save
  end
      
      
  def more_footer
          @groups=current_user.group_users.find(:all,:conditions=>['is_active = ? AND is_deleted = ?',true,false])
        end
  def select_groups
     if (params[:group].split(',').count==1)
     if params[:footer] =="no"  
      session[:filter_group]=nil
    else
      session[:filter_group]=params[:group]  
    end
    end
    grp_id=[]
     @favorites=Favorite.find_all_by_user_id(current_user.id)
      if !params[:group].blank? 
      m=params[:group].split(',')
      p=Hash[*m.collect{|v|[v,v]}.flatten]
      p.each do |k,v|
        params[:all]="all" if v =="all" 
      end
      p.delete("all")
      p.delete("")
      if p.nil? || p.blank?
        @favorites.each do |favorite|
          grp_id<< favorite.group_id
        end
       params[:groups]=Hash[*grp_id.collect{|v|[v,v]}.flatten]
        else
     params[:groups]=p
     end
    end
    if !params[:locations].blank?
      n=params[:locations].split(',')
      q=Hash[*n.collect{|v|[v,v]}.flatten]
      q.each do |k,v|
        params[:all_loc]="all_loc" if v=="all_loc"
      end
      q.delete("all_loc")
      q.delete("")
          if q.nil? || q.blank?
            params[:location]=Hash["goal_obj"=>"goal_obj", "status_update"=>"status_update", "message"=>"message"] 
      else
        params[:location]=q
      end
    end
     if params[:group].blank? && params[:locations].blank?
       group_blank
    end
  end
  def group_blank
      grp_id=[]
    @group_user=current_user.group_users.find(:all)
        @group_user.each do |group|
     grp_id<< group.group.id 
    end
       params[:groups]=Hash[*grp_id.collect{|v|[v,v]}.flatten]
      params[:location]=Hash["goal_obj"=>"goal_obj", "status_update"=>"status_update", "message"=>"message"] 
      end
  def remove_session_files
    session[:attachment]=[]
    session[:status_update]=[]
  end
  
  def pagination_for_items
  @page=params[:page].to_i
  @groupid=params[:gid]
  @group=Group.find_by_id(params[:gid])
  objectives
  @favorites=Favorite.find_all_by_user_id(current_user.id)
  @coll=current_user.message_users.find(:all,:conditions=>['status=? AND is_trash!=?', @item,1], :order=>'created_at DESC') 
  @c=current_user.message_users.find(:all, :conditions=>['is_read=? AND status=? AND is_trash!=?', "false", @item,1],:order=>'created_at DESC') 
  @ch=0
  @cc=[]
  @page=params[:page].to_i
  for c in @coll
      if c.message.group_id==@group.id
        if c.message.id == params[:id].to_i
        c.update_attributes(:is_read=>1)
        end
	     @cc<< c
     end
    end
    @ch=@cc.count
    @collections=@cc.paginate(:page=>params[:page],:per_page=>10)
  end
   
      
      def pagination_for_main
    	  @page=params[:page].to_i
	  objectives
         @favorites=Favorite.find_all_by_user_id(current_user.id)
         @collections=current_user.message_users.paginate(:page=>params[:page],:limit=>20,:conditions=>['status=? AND is_trash!=?', @item,1], :order=>'created_at DESC',:per_page=>10) 
         for c in @collections
           if c.message.id == params[:id].to_i
           c.update_attributes(:is_read=>1)
           end
         end     
         @c=current_user.message_users.find(:all, :conditions=>['is_read=? AND status=? AND is_trash!=?', "false", @item,1],:order=>'created_at DESC') 
          @ch=@c.count  
  end
  def post_status_update(group_id,is_leader=nil)
      @group=Group.find_by_id(group_id)
      @status_update=Post.new
      @status_update.user_id=current_user.id
      @status_update.is_by_leader=true if (is_leader && (current_user.id==@group.user_id || current_user.id==@group.group_leader_id))
      @status_update.group_id=@group.id
      @status_update.content=params[:status]
      @status_update.save
      if session[:attachment]
        session[:attachment].each do |attach|
          @attachment=Attachment.find_by_id(attach)
          unless @attachment.nil?
            @attachment.update_attributes(:attachable_id=>@status_update.id,:attachable_type=>@status_update.class.name)
          end
        end
      end
      @members=@group.active_members
      @members.each do |member|
        @user_post=UserPost.new
        @user_post.user_id=member.user_id
        @user_post.is_read=1 if member.user_id==current_user.id
        @user_post.leader_update_read=0 if is_leader
        @user_post.leader_update_read=1 if member.user_id==current_user.id
        @user_post.post_id=@status_update.id
        @user_post.save
        if session[:attachment]
        session[:attachment].each do |attach|
       @dup=DupAttachment.find(:first, :conditions=>['attach_id=? AND post_id=?', attach, @status_update.id])
       @dup_attach=DupAttachment.new
       @dup_attach.post_id=@status_update.id
       if @dup.nil?
        @dup_attach.attach_id=attach
        @dup_attach.save
      end
      end
      end
    end
  end
  def footer_share()
params[:gid]=params[:id] if params[:id]
#params[:gid]=a
    @group=Group.find_by_id(session[:filter_group])
    #~ @collections=[]
    #~ cs=current_user.user_posts.find(:all,:order=>'created_at DESC') 
    #~ for c in cs
      #~ if c.post.group_id==@group.id
         #~ @collections<<c
      #~ end  
    #~ end
    @collections=current_user.group_updates(session[:filter_group])
    @c=current_user.user_posts.find(:all,:conditions=>['is_read="false"'],:order=>'created_at DESC') 
    @objectives=@group.group_upcoming_objectives
    @favorites=Favorite.find_all_by_user_id(current_user.id)
    @collections=@collections.paginate(:page=>params[:page],:per_page=>10)
    if request.xml_http_request? 
      render :update do |page| 
        page << "close_pop()"
        page.replace_html "recent_activity_left_container",:partial=>'activities/collection'
      end
    end  
  end
 def convert_date(date)
    begin
       date=date[:day]+date[:month]+date[:year]
       Date.parse(date)
       rescue 
       err="invalid"
       end
  end   
  
  def remove_inv_session
    session[:invited_member]=nil
    session[:invited_leader]=nil
    session[:facebook_invite_group_id]=nil
  end  
  def attached
    session[:attachment].each do |attach|
      @attachment=Attachment.find_by_id(attach)
      unless @attachment.nil?
        @attachment.update_attributes(:attachable_id=>@status_update.id,:attachable_type=>@status_update.class.name)
      end
      @dup=DupAttachment.find(:first, :conditions=>['attach_id=? AND post_id=?', attach, @status_update.id])
      @dup_attach=DupAttachment.new
      @dup_attach.post_id=@status_update.id
      if @dup.nil?
        @dup_attach.attach_id=attach
        @dup_attach.save
      end
    end
  end
  
  def is_member_allowed(group)
    group.allowed_to_activate?
  end
    
  def sorted_sort
  @grou=[]
  @user.each do|user|
    @grou<< Group.find(:all,:conditions=>['user_id=? AND group_leader_id=?',current_user.id,user.id])
  end
  @grou.flatten!
  @groups=@grou.paginate :page=>params[:page],:per_page=>ENTRIES_PER_PAGE 
end
end

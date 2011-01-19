class MessagesController < ApplicationController
  include UserAuthenticatedSystem
  layout "after_login",:except=>['find_group_members','more_groups','attachment','reply_message']
  before_filter :must_be_logged_in
  skip_filter :clear_attachment_session, :only => [:update_inbox]
  def new
    @groups=find_groups
     session[:files]=[]
 end
  def create
    if params["send.x"]
      if params[:recipients]
	      if current_user.id
	      if current_user.id!=0 
		      recipient_ids=params[:recipients][:name].split(",")
        @message=Message.new(:group_id=>params[:message][:group_id], :subject=>params[:message][:subject], :message=>params[:message][:message])
        @message.user_id=current_user.id
        @attach=Hash.new
        if params[:attachment]
          count=params[:attachment].count.to_i
          for j in 0..count
            if !params[:attachment]["fileff_#{j}"].nil?
              @attach["uploaded_data"]=params[:attachment]["fileff_#{j}"]
              @attachment=Attachment.new(@attach)
              @message.attachments<<@attachment
            end
          end
  end
  
        if @message.valid?
          @message.save
	 @attachm=Attachment.find(:all, :conditions=>['attachable_id=?', session[:attachid]])
	 for attachm in @attachm
		attachm.update_attributes(:attachable_id=>@message.id)
	end
	 @messuser=MessageUser.find(:all, :conditions=>['is_delete=? AND message_id=? AND status=?',false, session[:attachid], "draft"])
	 for messuser in @messuser
		 MessageUser.delete(messuser)
	 end
	@suser=MessageUser.find(:all, :conditions=>['is_delete=? AND message_id=? AND status=?',false, session[:attachid], "draftmine"])
	MessageUser.delete(@suser)
          @message_user=MessageUser.new(:message_id=>@message.id,:user_id=>current_user.id,:status=>"sent",:is_read=>1,:is_trash=>0)
          @message_user.save
          recipient_ids.each do |r|
		
		  if r!="\r\n  "
            @message_user=MessageUser.new(:message_id=>@message.id,:user_id=>r,:status=>"recieved",:is_read=>false,:is_trash=>false)
            @message_user.save

	    
    @user=User.find_by_id(r.to_i)
    
	    end
    end
   
          @ms=MessageUser.find(:all, :conditions=>['message_id=?', @message.id])
          for ms in @ms
            ms.update_attributes(:is_read=>0, :is_trash=>0)
          end
          flash[:message_sent]="Message sent"
          #redirect_to :action=>"inbox"
          redirect_to :action=>"sentitems"
        else
          render :action=>"new"
        end    
end
end
end
    else
	      if params[:recipients]
      @message=Message.new(params[:message])
      @message.user_id=current_user.id
      @message.is_draft=true
      else
	      @message=Message.new(:group_id=>params[:message][:group_id], :subject=>params[:message][:subject], :message=>params[:message][:message])
	      @message.user_id=current_user.id
	      @message.is_draft=true
	     
	      end
      @attach=Hash.new
      if params[:attachment]
        count=params[:attachment].count.to_i
        for j in 0..count
          if !params[:attachment]["fileff_#{j}"].nil?
            @attach["uploaded_data"]=params[:attachment]["fileff_#{j}"]
            @attachment=Attachment.new(@attach)
            @message.attachments<<@attachment
          end
        end
      end
      if @message.valid?
        @message.save
	@message_user=MessageUser.new(:message_id=>@message.id,:user_id=>current_user.id,:status=>"draftmine",:is_read=>true, :is_trash=>0)
              @message_user.save
	 @attachm=Attachment.find(:all, :conditions=>['attachable_id=?', session[:attachid]])
	 for attachm in @attachm
		attachm.update_attributes(:attachable_id=>@message.id)
	end
	 @messuser=MessageUser.find(:all, :conditions=>['message_id=? AND status=?', session[:attachid], "draft"])
	 for messuser in @messuser
		 MessageUser.delete(messuser)
	 end
	  suser=MessageUser.find(:first, :conditions=>['message_id=? AND status=?', session[:attachid], "draftmine"])
	  MessageUser.delete(suser)
        if params[:recipients]
          recipient_ids=params[:recipients][:name].split(",") if params[:recipients]
          unless recipient_ids.nil? || recipient_ids.empty?
            recipient_ids.each do |r|
		     if r!="\r\n  "
              @message_user=MessageUser.new(:message_id=>@message.id,:user_id=>r,:status=>"draft",:is_read=>true,:is_trash=>false)
              @message_user.save
      end
            end
          end
  
  else
	
if params[:recipients]
			     if r.to_i==current_user.id
				     @message_user=MessageUser.new(:message_id=>@message.id,:user_id=>r,:status=>"draftmine",:is_read=>true,:is_trash=>false)
              @message_user.save
	      else
	   @message_user=MessageUser.new(:message_id=>@message.id,:user_id=>current_user.id,:status=>"draft",:is_read=>true,:is_trash=>false)
              @message_user.save
      end
end
	       if params[:attachment]
          count=params[:attachment].count.to_i
          for j in 0..count
            if !params[:attachment]["fileff_#{j}"].nil?
              @attach["uploaded_data"]=params[:attachment]["fileff_#{j}"]
              @attachment=Attachment.new(@attach)
              @message.attachments<<@attachment
            end
          end
  end
	      end
      end 
      @ms=MessageUser.find(:all, :conditions=>['message_id=? AND status=?', @message.id, "draftmine"])
      for ms in @ms
        ms.update_attributes(:is_read=>0, :is_trash=>0)
      end
      flash[:message]="Message saved"
      redirect_to :action=>"drafts"
    end
    
  end
  
  
  
  def edit
    @message=Message.find_by_id(params[:id])
    @groups=find_groups
    session[:attachid]=@message.id
    @messuser=MessageUser.find(:all, :conditions=>['message_id=? AND status=?', @message.id, "draft"])
    @attachm=Attachment.find(:all, :conditions=>['attachable_id=? AND attachable_type=?', params[:id], "Message"])
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "image_test",:partial=>'edit_image'
      end			
    end       
  end
  
  def update
    @message=Message.find_by_id(params[:id])
    @message.update_attributes(params[:message])
    attachfiles_message(params[:attachment],@message) if params[:attachment]
    redirect_to :action=>"inbox"
  end
  
  def save_file
	  
	     @att=Attachment.find(:first, :conditions=>['id=?', params[:id]])
	     Attachment.delete(@att)
	   @attachm=Attachment.find(:all, :conditions=>['attachable_id=? AND attachable_type=?', params[:mid], "Message"])
  if request.xml_http_request?
          render :update do |page|      
          
	     page.replace_html "image_test",:partial=>'edit_image'
           end			
      end       
  end
  
  def find_group_members
    @group=Group.find_by_id(params[:id])
    @group_users=@group.active_members
    @group_members=[]
    @group_users.each do |user|
      @group_members<<user.user unless user.user==current_user
    end
    @group_members=(@group_members.sort_by {|user| user.user_profile.first_name.downcase})
  end
   
  def find_groups
    group_ids=current_user.group_active_membership.map(&:group_id)
    @groups=Group.find_all_by_id(group_ids)
  end
    
  def attachment
    @message=Message.find(params[:id])
  end
  
  # Coding for "Inbox page" starts here
  
  def inbox
    session[:filter_group]=nil if params[:filter]
    session[:filter_group]= params[:gid] if params[:gid] 
    if session[:filter_group]
      params[:gid]=session[:filter_group]
      @groupid=params[:gid]
      inbox_messages_group(session[:filter_group])  
    else
      inbox_messages
      @limit=20
    end
    find_inbox_messages
    @last_msg=current_user.last_inbox_message
    session[:last_message]=@last_msg.id if @last_msg
    if request.xml_http_request?
      render :update do |page|      
        page.show "loader"
        page.replace_html "recent_activity_left_container",:partial=>'inbox_collection'
        page.replace_html "recent_div",:partial=>'activ'
        page.replace_html "up_objectives",:partial=>'upcoming_objectives'
        page.hide "loader"
      end			
    end  
  end
  
  def find_inbox_messages
    @page=params[:page].to_i
    @favorites=current_user.favorites
    @collections=find_message(@collections)
    @ch=get_count(@collections)
    @collections=@collections.paginate(:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
  end
  
  def inbox_messages
    group_ids=current_user.user_active_memberships.map(&:group_id)
    @collections=current_user.inbox_messages(group_ids)
    @objectives=current_user.upcoming_objectives_all
  end

  def inbox_messages_group(group_id)
    @collections=current_user.inbox_group_messages(group_id)  
    group_objectives(group_id)
  end

  def find_message(collections)
    messages=[]
    for c in collections
       message= Message.find_by_id(c.message_id)
       if message.parent_id.nil?
           messages << message
        else
           message=Message.find_by_id(message.parent_id)
           messages << message
        end    
    end
    @collections=messages.uniq
 return @collections
  end
 
  def save_user_detail
    if session[:filter_group]
      @collections=current_user.inbox_group_messages(session[:filter_group])  
      @collections.each do |col|
        col.update_attribute(:is_read,true)
      end
      inbox_messages_group(session[:filter_group])
    else
      @coll=current_user.message_users.find(:all,:conditions=>['is_trash=?',false])
      @coll.each do |col|
        col.update_attribute(:is_read,true)
      end
      inbox_messages
    end
    find_inbox_messages
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "recent_activity_left_container",:partial=>'inbox_collection'
        page.replace_html "recent_div",:partial=>'activ'
      end			       
    end			       
  end
   
  def read_save_user_detail
    read=true
    read=false if params[:unread]
    ids=params[:ids].split(",")
    ids.delete("")
    ids.each do |id|
      @message=Message.find_last_by_parent_id id 
      if @message.nil?
        @msg_user=current_user.message_users.find_all_by_message_id id
      else
        @msg_user=current_user.message_users.find_all_by_message_id @message.id 
      end
      @msg_user.each do |msg_user|
        msg_user.update_attribute(:is_read,read) unless msg_user.nil?
      end
    end
    @groupid=session[:filter_group]  if session[:filter_group] 
    (@groupid && !@groupid.blank?) ? inbox_messages_group(session[:filter_group]) : inbox_messages
    find_inbox_messages
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "recent_activity_left_container",:partial=>'inbox_collection'
        page.replace_html "recent_div",:partial=>'activ'
      end			
    end       
  end
  
  def read_save_trash_detail
    ids=params[:ids].split(",")
    ids.delete("")
    ids.each do |id|
      @messages=Message.find(:all,:conditions=>['parent_id=?',id],:select=>'id')
      @msg_user=current_user.message_users.find(:all,:conditions=>['messages.parent_id=?',id],:include=>:message)
      @msg_user=@msg_user+current_user.message_users.find(:all,:conditions=>['message_id=?',id])
      @messages.each do |message|
        @msg_user=@msg_user+current_user.message_users.find(:all,:conditions=>['message_id=?',message.id])
      end
      @msg_user.each do |msg|
        msg.update_attributes(:is_trash=>true,:is_delete=>false) unless msg.nil?
      end
    end  
    @groupid=params[:group_id] if params[:group_id] 
    @groupid=session[:filter_group] if session[:filter_group]
    (@groupid && !@groupid.blank?) ? inbox_messages_group(session[:filter_group]) : inbox_messages
    find_inbox_messages
    flash[:message_inbox]="Message(s) moved to Storage"
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "recent_activity_left_container",:partial=>'inbox_collection'
        page.replace_html "recent_div",:partial=>'activ'
      end			
    end       
  end
  

  # Coding for "Sent Items page" starts here
  
  def sentitems
    session[:filter_group]=nil if params[:filter]
    session[:filter_group] =params[:gid] if params[:gid]
    if session[:filter_group]
      params[:gid]=session[:filter_group]
      group_objectives(session[:filter_group])
      @collections=current_user.group_sentitems(session[:filter_group])
    else
      @collections=current_user.sentitems
      @limit=20
      @objectives=current_user.upcoming_objectives_all
    end
    @count=@collections.count
    find_collections
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "recent_activity_left_container",:partial=>'sent_collection'
        page.replace_html "up_obj",:partial=>'upcoming_objectives'
        page.replace_html "recent_div",:partial=>'activ'
      end			
    end    
  end
  
  def find_sent_items(collections)
    @temp=[]
    @collections=[]
    collections.each do|col|
      if col.message.parent_id.nil?
        @temp<<col.message.id
        @collections<<col
      else
        @collections<< col unless @temp.include?(col.message.parent_id)
        @temp<<col.message.parent_id
      end
    end
    return sort_sentitems(@collections)
  end
  
  def sort_sentitems(collections)
    @final=Hash.new
    collections.each do|msg|
      @m=Message.find_last_by_parent_id(msg.message_id,:conditions=>['messages.user_id=? AND message_users.status=?',current_user.id,"sent"],:include=>:message_users)
      @m=Message.find_last_by_id(msg.message_id,:conditions=>['messages.user_id=? AND message_users.status=?',current_user.id,"sent"],:include=>:message_users) if @m.nil?
      @final[@m.created_at]=msg
    end
    @final=@final.sort.reverse
    @collections=[]
    @final.each do |k,v|
      @collections<<v
    end
    return @collections
  end
  
  def read_sent_save_trash_detail
    ids=params[:ids].split(",")
    ids.each do |id|
      @message=Message.find_by_id(id)
      @messages=Message.find_all_by_parent_id(id)
      @msg_user=current_user.message_users.find(:all,:conditions=>['message_id=?',id])
      @msg_user+=current_user.message_users.find(:all,:conditions=>{'message_id'=>@messages.collect{|message| message.id}})
      @msg_user.each do |msg_user|
        msg_user.update_attribute(:is_trash,true)
      end
    end
    if session[:group_filter]
      group_objectives(session[:group_filter])
      @collections=current_user.group_sentitems(session[:group_filter])  
    else
      @objective=current_user.upcoming_objectives_all
      @collections=current_user.sentitems
    end
    flash.now[:message_sent]="Message(s) moved to Storage"
    find_collections
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "recent_activity_left_container",:partial=>'sent_collection'
        page.replace_html "recent_div",:partial=>'sentactive'
      end			
    end       
  end
  
  def unsave_sent_user_detail
    if session[:filter_group]
      group_objectives(session[:filter_group])
      @collections=current_user.group_sentitems(session[:filter_group])
    else
      @collections=current_user.sentitems
      @objectives=current_user.upcoming_objectives_all
    end
    @collections.each do |c|
      c.update_attributes(:is_trash=>1)
    end  
    @collections=session[:filter_group] ? current_user.group_sentitems(session[:filter_group]) : current_user.sentitems
    flash.now[:message_sent]="Message(s) Moved to Storage"
    find_collections
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "recent_activity_left_container",:partial=>'sent_collection'
        page.replace_html "recent_div",:partial=>'sentactive'
      end			
    end       
  end
  
  # Coding for "Drafts page" starts here
  
  def drafts
    session[:filter_group]=nil if params[:filter]
    session[:filter_group]=params[:gid] if params[:gid]
    if session[:filter_group]
      params[:gid]=session[:filter_group]
      group_objectives(session[:filter_group])
      @collections=current_user.group_drafts(session[:filter_group])
    else
      @collections=current_user.drafts
      @limit=20
      @objectives=current_user.upcoming_objectives_all
    end
    @ch=@collections.count
    @collections=@collections.paginate(:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    @favorites=current_user.favorites
    @page=params[:page].to_i
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "recent_activity_left_container",:partial=>'draft_collection'
        page.replace_html "up_obj",:partial=>"upcoming_objectives"
        page.replace_html "recent_div",:partial=>'activ'
      end			
    end  
  end
  
  def read_draft_save_trash_detail
    @page=params[:page].to_i
    @favorites=current_user.favorites
    ids=params[:ids].split(",")
    ids.each do |id|
      @msg_user=MessageUser.find_by_id id
      @msg_user.update_attribute(:is_trash,true) unless @msg_user.nil?
    end
    if session[:filter_group]
      group_objectives(session[:filter_group])
      @collections=current_user.group_drafts(session[:filter_group])
     else
      @objectives=current_user.upcoming_objectives_all
      @collections=current_user.drafts
    end
    @ch=@collections.count 
    @collections=@collections.paginate(:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    flash.now[:draft]="Message(s) moved to Storage"
    render :update do |page|      
      page.replace_html "recent_activity_left_container",:partial=>'draft_collection'
      page.replace_html "recent_div",:partial=>'draftactive'
    end			      
  end
  
   def unsave_draft_user_detail
	   @page=params[:page].to_i
	   @objective=current_user.upcoming_objectives_all
     @favorites=Favorite.find_all_by_user_id(current_user.id)
     @collections=current_user.message_users.paginate(:page=>params[:page],:limit=>20,:conditions=>['status=? AND is_trash!=?', "draftmine",1], :order=>'created_at DESC',:per_page=>ENTRIES_PER_PAGE) 
     @c=current_user.message_users.find(:all, :conditions=>['is_read=? AND status=? AND is_trash!=?', "false", "draftmine",1],:order=>'created_at DESC') 
     @ch=0
      for c in @collections
           c.update_attributes(:is_trash=>1)
   end      
   @collections=current_user.message_users.paginate(:page=>params[:page],:limit=>20,:conditions=>['status=? AND is_trash!=?', "draftmine",1], :order=>'created_at DESC',:per_page=>ENTRIES_PER_PAGE) 
   @c=current_user.message_users.find(:all, :conditions=>['is_read=? AND status=? AND is_trash!=?', "false", "draft",1],:order=>'created_at DESC') 
     
     if request.xml_http_request?
          render :update do |page|      
          page.replace_html "recent_activity_left_container",:partial=>'draft_collection'
	  page.replace_html "recent_div",:partial=>'draftactive'
     end			
   end       
  end
  
  def more_groups
    find_groups
  end
  
 def message_thread
    @leader=false
    @message=Message.find_by_id(params[:id])
    @message=Message.find_by_id(@message.parent_id) unless @message.parent_id.nil?
    if check_group(@message.group_id,params[:id])==true
            message_user=MessageUser.find(:first,:conditions=>[' message_id=? and user_id=?',@message.id,current_user.id])
            message_user.update_attributes(:is_read=>1)
            @message_thread=Message.thread_messages(@message.id)
            @message_thread.each do |msg|
              message_user=MessageUser.find(:first,:conditions=>['is_delete=? AND message_id=? and user_id=?',false,msg.id,current_user.id])
              message_user.update_attributes(:is_read=>1)
            end
            @leader=true if @message.group.user_id==current_user.id || @message.group.group_leader_id==current_user.id
            @group_users=@message.group.active_members
            @user_profile=[]
            @message.message_users.each do |user|
            @user_profile<<user.user
            end
            @count_limit= (@message_thread.count)/10
            @count_limit=@count_limit+1 if ((@message_thread.count%10)!=0)
            if params[:page]!=@count_limit
                @message_thread=@message_thread.paginate(:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
            else
                @message_thread=@message_thread.paginate(:page=>params[:page],:per_page=>9)
            end
            @group=@message.group
            @objectives=current_user.upcoming_objectives_all
    else
        redirect_to wrong_message_path
    end
    
  end

    def check_group(group_id,message_id)
      #groups=current_user.group_users
      group=Group.find_by_id(group_id)
      message=Message.find_by_id(message_id)
      message_users=message.message_users
      have_message = 0
      message_users.each do |m_user|
         have_message = 1 if m_user.user_id == current_user.id
      end
      return true if have_message == 1
      return false if have_message == 0
  end    
  
  def wrong_message
             
  end

 
  def post_in_message_thread
    @mess=Message.find(params[:id])
    if @mess.parent_id.nil?
      @parent_message=@mess
    else
      @parent_message=Message.find_by_id @mess.parent_id
    end
    close=nil
    @message=Message.new(:message=>params[:message][:message],:subject=>@parent_message.subject,:parent_id=> @parent_message.id,:user_id=>current_user.id,:group_id=>@parent_message.group.id)
    @message.is_focused=true if params[:mess_focus]
    attachfiles_message(params[:attachment],@message) if params[:attachment]
    if @message.valid?
      @message.save   
      #~ @messages=Message.find(:all,:conditions=>['parent_id=?',@parent_message.id],:select=>'id')
      @parent_message.update_attributes(:updated_at=>Time.now)      
      @parent_message.message_users.each do |msg_user|
        move_trash_to_inbox(msg_user.user)
        unless msg_user.user==current_user
          @message_user=MessageUser.new(:message_id=>@message.id,:user_id=>msg_user.user_id,:status=>"recieved",:is_read=>0,:is_trash=>0)
          @message_user.save
        end
      end
    end
    @sent_message=MessageUser.new(:message_id=>@message.id,:user_id=>current_user.id,:status=>"sent",:is_read=>1,:is_trash=>0)
    @sent_message.save
    close=true if params[:conclude_thread]
    @parent_message.update_attributes(:updated_at=>Time.now,:is_closed=>close)
    @message_thread=Message.thread_messages(@parent_message.id)
    redirect_to :action=>"message_thread",:id=> @parent_message.id, :page=>params[:page]
    flash[:message_thread]="Your Reply has been sent"
  end
  
  def move_trash_to_inbox(user)
    @trash_to_inbox=user.message_users.find(:all,:conditions=>['status=? AND messages.parent_id=? AND is_trash=?',"recieved",@parent_message.id,true],:include=>:message)
    @trash_to_inbox=@trash_to_inbox+user.message_users.find(:all,:conditions=>['status=? AND message_id=? AND is_trash=?',"recieved",@parent_message.id,true])
    @trash_to_inbox.each do |msg|
      msg.update_attribute(:is_trash,false)
    end
  end
  
  def trash
    session[:filter_group] ? trash_filter(session[:filter_group]) : all_trash_messages
    @favorites=current_user.favorites
  end
  
  def delete_all_trash
    @trash=session[:filter_group] ? current_user.trashed_messages_group(session[:filter_group]) : current_user.trashed_messages
    @trash.each do |trash|
      trash.update_attributes(:is_delete=>true)
    end      
    trash
    @message="<span style='color:green; font:12px; margin-left:250px;'>Message(s) moved from Storage</span>"
    count=find_trash_count(@trash)
    render :update do |page|
      page.replace_html "trashed_messages123",:partial=>"trashed_messages"
      page.replace_html "trash_count",count+@message
      page.replace_html "pagin",""
    end
  end
  
  def undelete
    message_ids=params[:message_id].split(",")
    message_ids.each do |msg|
      @message=Message.find_by_id msg
      @messages=Message.find_all_by_parent_id(msg)
      @message_user=current_user.message_users.find(:all,:conditions=>['message_id=?',msg])
      @message_user+=current_user.message_users.find(:all,:conditions=>{'message_id'=>@messages.collect{|message| message.id}})
      @message_user.each do |msg_user|
        msg_user.update_attribute(:is_trash,false)
      end
    end
    group_id=params[:group_id]if params[:group_id]
    group_id= session[:filter_group]if session[:filter_group]
    group_id ? trash_filter(group_id) : all_trash_messages
    count=find_trash_count(@trash)
    @favorites=current_user.favorites
    @message="<span style='color:green; font:12px; margin-left:250px;'>Message(s) moved from Storage</span>"
    render :update do |page|      
      page.replace_html "trashed_messages123",:partial=>'trashed_messages'
      #~ page.replace_html "trash_count","#{count+@message}"
      page.replace_html "trash_count",count
      page.replace_html "trash_footer",:partial=>"message_footer"
    end	
  end
  
  def reply_message
    @message=Message.find_by_id(params[:id])
    @users=@message.group.active_members
    @group_users=[]
    @users.each do|grp_user|
      @group_users<<grp_user.user if grp_user.user.state.nil?
    end
    @reciever=User.find_by_id(params[:ur])
  end
  
  def post_reply
    @message=Message.new(params[:message])
    @message.user_id=current_user.id
    @parent_message=Message.find_by_id(params[:id])
    @message.group_id=@parent_message.group.id
    attachfiles_message(params[:attachment],@message) if params[:attachment] if params[:attachment]
    @message.save
    @m=MessageUser.new(:message_id=>@message.id,:user_id=>current_user.id,:status=>"sent",:is_read=>1,:is_trash=>0)
    @m.save
    params[:ids].each do |rec|
      u=User.find_by_email(rec)
      @m=MessageUser.new(:message_id=>@message.id,:user_id=>u.id,:is_read=>0,:status=>"recieved",:is_trash=>0)
      @m.save  
    end
    flash[:thread_reply]="Your Message has been sent"
    #redirect_to :action=>"message_thread",:id=>params[:id]
    redirect_to :action=>"sentitems"
  end
  
  def trash_thread
    @message=Message.find_by_id(params[:id])
    if @message.parent_id
      redirect_to :action=>"message_thread",:id=>@message.parent_id
    else
      redirect_to :action=>"message_thread",:id=>@message.id
    end
  end
  
  def footer
    @favorites=current_user.favorites
    if params[:group_id]
      session[:filter_group]=params[:group_id]
      trash_filter(params[:group_id])
      count=find_trash_count(@trash)
      render :update do |page|      
        page.replace_html "trashed_messages123",:partial=>'trashed_messages'
        page.replace_html "up_obj",:partial=>'upcoming_objectives'
        page.replace_html "trash_footer",:partial=>'message_footer'
        page.replace_html "trash_count",count
      end	
    else
      session[:filter_group]=nil
      all_trash_messages
      count=find_trash_count(@trash)
      render :update do |page|      
        page.replace_html "trashed_messages123",:partial=>'trashed_messages'
        page.replace_html "up_obj",:partial=>'upcoming_objectives'
        page.replace_html "trash_footer",:partial=>'message_footer'
        page.replace_html "trash_count",count
      end	
    end
  end
  
  def find_trash_count(trash)
    if trash.count.zero?
      "Messages in Storage (#{@trash.count})"
    else
      %Q{Messages in Storage (#{@trash.count})<a onclick="if (confirm('Are you Sure?')) { new Ajax.Request('/messages/delete_all_trash', {asynchronous:true, evalScripts:true}); }; return false;" href="#">Delete All</a> }
    end
  end
    
  def trash_filter(group_id)
    @trashed_inbox_msgs=current_user.trashed_messages_group(group_id)
    temp=[]
    @trash_new=[]
    @trashed_inbox_msgs.each do |msg|
      unless temp.include?(msg.message_id)
        @message=Message.find_by_id(msg.message.parent_id)
        @message=msg.message if @message.nil?
        @trash_new<<@message
        temp<<@message.id
      end
    end
    @trash_new.uniq!
    @trashed_msgs=[]
    @trash_new.each do |msg|
      @a=current_user.message_users.find(:last,:conditions=>['message_id=?',msg.id])
      if @a.nil?
        @messages=Message.find_all_parent_id(msg.id)
      end
      @a=current_user.message_users.find(:last,:conditions=>{'message_id'=>@messages.collect{|msg| msg.id}}) if @a.nil?
      @trashed_msgs<<@a
    end
    @trash=@trashed_msgs
    @trash=(@trash.sort_by {|collection| collection.updated_at}).reverse
    @trash=@trash.paginate(:page=>params[:page],:per_page=>ENTRIES_PER_PAGE) unless @trash.nil?
    group_objectives(group_id)
  end
  
  def group_objectives(group_id)
    @group=Group.find_by_id(group_id)
    @objectives=(@group.is_active && current_user.is_active_member?(group_id)) ? @group.group_upcoming_objectives : []
  end
  
  def attachfiles_message(attach,message)
    if attach
      @attach=Hash.new
      count=attach.count.to_i
      for j in 0..count
        if !attach["fileff_#{j}"].nil?
          @attach["uploaded_data"]=attach["fileff_#{j}"]
          @attachment=Attachment.new(@attach)
          message.attachments<<@attachment
        end
      end
    end
  end
  def attachment
    @message=Message.find(params[:id])
    @dup=@message.attachments
  end
  
  def all_trash_messages
    @trashed_inbox_msgs=current_user.trashed_messages
    temp=[]
    @trash_new=[]
    @trashed_inbox_msgs.each do |msg|
      unless temp.include?(msg.message_id)
        @message=Message.find_by_id(msg.message.parent_id)
        @message=msg.message if @message.nil?
        @trash_new<<@message
        temp<<@message.id
      end
    end
    @trash_new.uniq!
    @trashed_msgs=[]
    @trash_new.each do |msg|
      @a=current_user.message_users.find(:last,:conditions=>['message_id=?',msg.id])
      if @a.nil?
        @messages=Message.find_all_parent_id(msg.id)
      end
      @a=current_user.message_users.find(:last,:conditions=>{'message_id'=>@messages.collect{|msg| msg.id}}) if @a.nil?
      @trashed_msgs<<@a
    end
    @trash=@trashed_msgs
    @trash=(@trash.sort_by {|collection| collection.updated_at}).reverse
    @trash=@trash.paginate(:page=>params[:page],:per_page=>ENTRIES_PER_PAGE) unless @trash.nil?
    @objectives=current_user.upcoming_objectives_all
  end  
  
  def chat
    render :layout =>false
  end
  
  def get_message
    @abc= "hi"
  end

  def get_count(collections)
    @ch=0
    @messages=collections
    @messages.uniq!
    @temp=[]
    @messages.each do | message|
      if message.parent_id.nil?
        @temp<<message.id
        last_message=Message.find(:last,:conditions=>['parent_id= ?', message.id])
        last_message=message if last_message.nil?
        last_reply= MessageUser.find(:last,:conditions=>['is_delete=? AND message_id = ? AND user_id = ?',false, last_message.id, current_user.id]) if !last_message.nil?
        @ch+= 1 if !last_reply.nil? && last_reply.is_read==false
      else
        unless @temp.include?(message.parent_id)
          @temp<<message.parent_id
          @mess =current_user.message_users.find(:last,:conditions=>['is_delete=? AND messages.parent_id=?',false,message.parent_id],:include=>:message) 
          @ch+= 1 if @mess && !@mess.is_read
        end
      end
    end
    return @ch
  end
  
  def find_collections
    @page=params[:page].to_i
    @collections=find_sent_items(@collections)
    @collections=@collections.paginate(:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    @favorites=current_user.favorites
  end
  
  def update_inbox
    @last_msg=current_user.last_inbox_message
    if @last_msg && session[:last_message] && session[:last_message].to_i<@last_msg.id
      inbox
    else
      render :nothing => true, :layout => true
    end
  end
end

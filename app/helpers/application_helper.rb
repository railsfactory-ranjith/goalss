# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def sort_link_helper(text, parameter, options)
    update = options.delete(:update)
    action = options.delete(:action)
    controller = options.delete(:controller)
    page = options.delete(:page)
    per_page = options.delete(:per_page)
    id = options.delete(:id)
    key = parameter
    #key += " DESC" if params[:order] == parameter
    options = {
        :url => {:controller=>controller,:action => action,:id => id, :order => key, :page => page ,:per_page => per_page},
        :update => update,
        :loading =>"Element.show('ajax_image1')",
        :complete => "Element.hide('ajax_image1')",
        }
    if text=="img"
      #link_to("<img id= #{text} src='/images/blue_up_arrow.jpg' alt='up arrow' style='margin:0 2px;'onclick='imagefirst()'/>", options,{ :class=>"arrow_top"})
      #link_to_remote("<img id='img2' src='/images/blue_up_arrow.jpg' alt='up arrow' style='margin:0 2px;'	/>", options,{ :class=>"arrow_top",:id=>"div1"})
      elsif text=="img1"
     # link_to("<img id= #{text} src='/images/blue_up_arrow.jpg' alt='up arrow' style='margin:0 2px;'onclick='imagesecond()'/>", options,{ :class=>"arrow_top"})
      elsif text=="img2"
      #link_to("<img id= #{text} src='/images/blue_up_arrow.jpg' alt='up arrow' style='margin:0 2px;'onclick='imagethird()'/>", options,{ :class=>"arrow_top"})
      elsif text=="img_creat1"
    #  link_to("<img id= #{text} src='/images/blue_up_arrow.jpg' alt='up arrow' style='margin:0 2px;'onclick='imagecreat()'/>", options,{ :class=>"arrow_top"})
      elsif text=="img_active1"
     # link_to("<img id= #{text} src='/images/blue_up_arrow.jpg' alt='up arrow' style='margin:0 2px;'onclick='imageactive()'/>", options,{ :class=>"arrow_top"})
    end
  end
  def des_sort_link_helper(text, parameter, options)
    update = options.delete(:update)
    action = options.delete(:action)
    controller = options.delete(:controller)
    page = options.delete(:page)
    per_page = options.delete(:per_page)
    id = options.delete(:id)
    key = parameter
    key += " DESC" 
    options = {
        :url => {:controller=>controller,:action => action,:id => id, :order => key,:page => page ,:per_page => per_page},
        :update => update,
        :loading =>"Element.show('ajax_image1')",
        :complete => "Element.hide('ajax_image1')",
    }
    #link_to_remote("<img id= #{text} src='/images/blue_down_arrow.jpg' alt='up arrow' onclick= ''; />", options,{:class=>"arrow_top"})
    #link_to_remote("<img id='img1' src='/images/blue_down_arrow.jpg' alt='up arrow'  />", options,{:class=>"arrow_top",:id=>"div1"})
    if text=="img3"
      #link_to("<img id= #{text} src='/images/blue_down_arrow.jpg' alt='down arrow' style='margin:0 2px;'onclick='imagefour()'/>", options,{ :class=>"arrow_top"})
      #link_to_remote("<img id='img2' src='/images/blue_up_arrow.jpg' alt='up arrow' style='margin:0 2px;'	/>", options,{ :class=>"arrow_top",:id=>"div1"})
    elsif text=="img4"
      #link_to("<img id= #{text} src='/images/blue_down_arrow.jpg' alt='down arrow' style='margin:0 2px;'onclick='imagefive()'/>", options,{ :class=>"arrow_top"})
    elsif text=="img5"
      #link_to("<img id= #{text} src='/images/blue_down_arrow.jpg' alt='down arrow' style='margin:0 2px;'onclick='imagesix()'/>", options,{ :class=>"arrow_top"})
    elsif text=="img_creat2"
      #link_to("<img id= #{text} src='/images/blue_down_arrow.jpg' alt='down arrow' style='margin:0 2px;'onclick='imagecreat1()'/>", options,{ :class=>"arrow_top"})
    elsif text=="img_active2"
      #link_to("<img id= #{text} src='/images/blue_down_arrow.jpg' alt='down arrow' style='margin:0 2px;'onclick='imageactive1()'/>", options,{ :class=>"arrow_top"})
    end
  end
  def list_country
    @country=["Afghanistan","Albania","Algeria","Andorra","Angola","Antigua and Barbuda","Argentina","Armenia","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bhutan","Bolivia","Bosnand Herzegovina","Botswana","Brazil","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Cape Verde","Central African Republic","Chad","Chile","China","Colombi","Comoros","Congo (Brazzaville)","Congo","Costa Rica","Cote d'Ivoire","Croatia","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","East Timor (Timor Timur)","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Fiji","Finland","France","Gabon","Gambia, The","Georgia","Germany","Ghana","Greece","Grenada","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kiribati","Korea, North","Korea, South","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Mauritania","Mauritius","Mexico","Micronesia","Moldova","Monaco","Mongolia","Morocco","Mozambique","Myanmar","Namibia","Nauru",	"Nepaal","Netherlands","New Zealand","Nicaragua","Niger","Nigeria","Norway","Oman","Pakistan","Palau","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Qatar","Romania","Russia","Rwanda","Saint Kitts and Nevis","Saint Lucia","Saint Vincent","Samoa","San Marino","Sao Tome and Principe","Saudi Arabia","Senegal","Serbia and Montenegro","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","Spain","Sri Lanka","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Togo","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","Tuvalu","Uganda","Ukraine","United Arab Emirates","United Kingdom","United States","Uruguay","Uzbekistan","Vanuatu","Vatican City","Venezuela","Vietnam","Yemen","Zambia","Zimbabwe"]
  end
  def list_time_zones
    @time_zones=["-12:00", "-11:00", "-10:30", "-10:00", "-09:30", "-09:00", "-08:30", "-08:00", "-07:00", "-06:00", "-05:00", "-04:30", "-04:00", "-03:30", "-03:00", "-02:30", "-02:00", "-01:00", "-00:44", "-00:25", "00:00", "+00:20", "+00:30", "+01:00", "+02:00", "+03:00", "+03:30", "+04:00", "+04:30", "+04:51", "+05:00", "+05:30", "+05:40", "+05:45", "+06:00", "+06:30", "+07:00", "+07:20", "+07:30", "+08:00", "+08:30", "+08:45", "+09:00", "+09:30", "+09:45", "+10:00", "+10:30", "+11:00", "+11:30", "+12:00", "+12:45", "+13:00", "+13:45", "+14:00"]
  end
  def list_date_format
    @date_format=["MM/DD/YY","DD/MM/YY","YY/MM/DD"]
  end
  def list_creditcard
    @card_type=["mastercard","visa","American DreamCard","Platinum MasterCard"]
  end
  def wrap_text(txt, col = 80)
    txt.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/,"\\1\\3\n") 
  end
  def truncate_text_val(text)
      truncate(text, :length => 15)
  end
    def truncate_text(text)
    truncate(text, :length => 13)
  end
  def groups_link_helper(text, parameter, options)
    update = options.delete(:update)
    action = options.delete(:action)
    controller = options.delete(:controller)
    page = options.delete(:page)
    per_page = options.delete(:per_page)
    id = options.delete(:id)
    key = parameter
    key += " DESC" if params[:order] == parameter
    options = {
        :url => {:controller=>controller,:action => action,:id => id, :order => key, :page => page ,:per_page => per_page},
        :update => update,
                :loading =>"Element.show('ajax_image1')",
        :complete => "Element.hide('ajax_image1')"
    }
    if key !=parameter
     link_to("<img id= #{text} src='/images/dwn-arro.gif' alt='up arrow' style='margin:0 2px;'	/>", 
     options,{ :class=>"arrow_top"})
    else
      link_to("<img id= #{text} src='/images/account_up_arrow.jpg' alt='up arrow' style='margin:0 2px;'	/>", 
      options,{ :class=>"arrow_top"})
    end
  end
  
  def find_group_color(obj)
    @color="#"+GroupUser.find(:first,:conditions=>['group_id = ? AND user_id = ?',obj.group.id,current_user.id]).color_code.to_s
  end
  
  def find_leader(group)
    if User.find_by_id(group.group_leader_id)
      @leader_name=User.find_by_id(group.group_leader_id)
      @leader_first_name=User.find_by_id(group.group_leader_id).user_profile.first_name
      @leader_last_name=User.find_by_id(group.group_leader_id).user_profile.last_name
    else
      @leader_first_name="No leader" 
      @leader_last_name="" 
    end
  end
  
  def is_member_allowed(group)
    group.allowed_to_activate?
  end
  
  def is_member_active(m,g)
    member=GroupUser.find(:first,:conditions=>['user_id = ? AND group_id = ?',m.id,g.id])
    if member && member.is_active? 
      true
    else
      false
    end
  end

  def back_ground_color(gid)
    @color=current_user.group_users.find(:first, :conditions=>['group_id = ?', gid])
    if @color.nil? || @color.color_code.nil?
      @group_color="ffffff"
    else
    @group_color=@color.color_code
    end
  end  
  def back_ground_color_thrid_party(gid,user)
    @color=user.group_users.find(:first, :conditions=>['group_id = ?', gid])
    if @color.nil? || @color.color_code.nil?
      @group_color="ffffff"
    else
    @group_color=@color.color_code
    end
  end  
  
  def group_name(id)
     @group=Group.find_by_id(id)
    return @group.name.upcase
  end
   def group_names(id)
    @group=Group.find_by_id(id)
    return @group.name.upcase
  end
  def find_elapsed_time(post_time)
    diff=Time.now-post_time
    case diff
      when 0..59
        "#{pluralize(diff.to_i,"second")} ago"
      when 60..3599
        "#{pluralize((diff/60).to_i,"minute")} ago"  
      when 3600..86399
        "#{pluralize((diff/3600).to_i,"hour")} ago" 
      when 86400..604799
        "#{pluralize((diff/86400).to_i,"day")} ago"
      when 604800..2419199
        "#{pluralize((diff/604800).to_i,"week")} ago"
      when 2419200..31535900
        "#{pluralize((diff/2419200).to_i,"month")} ago"
      else
        "#{pluralize((diff/31536000).to_i,"year")} ago"
    end
  end
  
  def user_time_format(time)
      if current_user.user_profile.time_zone
        a=current_user.user_profile.time_zone.split(':')
        if a[1] ==  "30"
            a[1] = 0.5
        end    
       
        val=(a[0].to_i*3600) + (a[1].to_f*3600)
        time=time+val
       
    end  
    if current_user.user_profile.date_format
      case current_user.user_profile.date_format.downcase
        when "mm/dd/yy"
          time.strftime("%m/%d/%Y %I:%M%p")
        when "dd/mm/yy"
          time.strftime("%d/%m/%Y %I:%M%p")
        when "yy/mm/dd"
          time.strftime("%Y/%m/%d %I:%M%p")
        else
          time.strftime("%m/%d/%Y %I:%M%p")
      end
    else
      time.strftime("%m/%d/%Y %I:%M%p")
    end
end
 def user_date_format(time)
    if current_user.user_profile.date_format
      case current_user.user_profile.date_format.downcase
        when "mm/dd/yy"
          time.strftime("%m/%d/%Y")
        when "dd/mm/yy"
          time.strftime("%d/%m/%Y")
        when "yy/mm/dd"
          time.strftime("%Y/%m/%d")
        else
          time.strftime("%m/%d/%Y")
      end
    else
      time.strftime("%m/%d/%Y")
    end
 end



  
  def find_username(member)
    if member.user_name.blank?
      member.user_profile.first_name
    else
      member.user_name
    end
  end

  def truncate_group_name(gname)
    if gname.length <= 11
       @group_name=gname
    else
       @group_name=truncate(gname, :length => 11)
    end   
  end
  
  def user_activity_link(user_id)
    if current_user.id==user_id
      "/activities/my_activities"
    else
      "/users/#{user_id}/thirdparty_activity"
    end
  end
  
  def remove_session_files
    #~ if session[:attachment]
      #~ unless session[:attachment].empty?
        #~ session[:attachment].each do |attach|
          #~ @file=Attachment.find_by_id(attach)
          #~ @file.delete unless @file.nil?
        #~ end
      #~ end
    #~ end
    session[:attachment]=[]
    session[:status_update]=[]
  end
  
  def full_name(user)
    "#{user.user_profile.first_name} #{user.user_profile.last_name}"
  end
  
   def new_activities(group_id)
    current_user.user_posts.count(:all, :conditions => ["posts.group_id= ? and is_read = ? and posts.receiver_id is null",group_id, 0], :include=>"post")
    #current_user.message_users.count(:all,:conditions=>['messages.group_id=? AND is_read!=?',group_id,1],:include=>:message)
  end
  def my_new_activities(group_id)
    current_user.user_posts.count(:all, :conditions => ["posts.group_id= ? and is_read = ? and (posts.receiver_id=? or posts.user_id=?)",group_id, 0,current_user.id,current_user.id], :include=>"post")
    #current_user.message_users.count(:all,:conditions=>['messages.group_id=? AND is_read!=?',group_id,1],:include=>:message)
  end
  def user_image(user)
    if user.attachment
     # image_tag(user.attachment.public_filename(:thumb))
      image_tag(user.attachment.public_filename(:size1))
    else
      %Q{<img alt="img" src="/images/img_not_avl2.jpg"/>}
    end
  end
   
  def invite_user_image(user)
    unless user.nil?
      if user.attachment
        image_tag(user.attachment.public_filename(:thumb),:height=>"35px",:width=>"35px")
      else
        %Q{<img alt="img" src="/images/img_not_avl2.jpg" height="35px",width="35px"/>}
      end
    else
     ""
    end
  end

   def assign_filter
    params[:id]=session[:filter_group] if session[:filter_group]
    params[:gid]=session[:filter_group] if session[:filter_group]
  end
  
  def find_last_reply(message_id)
    @last_reply= Message.find(:last, :conditions=>['parent_id=?',message_id])
    if !@last_reply.nil?
        @body=@last_reply.message
        @message_read_status=MessageUser.find(:last,:conditions=>['message_id = ?  and user_id = ?', @last_reply.id, current_user.id])
    else
        @body=Message.find_by_id(message_id).message    
        @message_read_status=MessageUser.find(:last,:conditions=>['message_id = ?  and user_id = ?',message_id, current_user.id])        
    end   
    if  @message_read_status.is_read == true
        @read = true
    else
        @read = false
    end
   end  

  def favourite_group_color(group_id)
    group_color=current_user.group_users.find_by_group_id(group_id)
    if !group_color.nil?
      group_color.color_code
    else
      "000000"
    end
  end
  
  def show_comment(post)
    @group_user=current_user.group_users.find(:first,:conditions=>['group_id=?',post.group_id])
    return true if post.group.is_active && @group_user && @group_user.is_active
  end
  
  def comment_attachment(comment)
    unless comment.attachments.empty?
      if comment.attachments.count==1
        #~ link_to comment.attachments[0].filename,comment.attachments[0].public_filename
        link_to comment.attachments[0].filename, download_file_activities_path(:id=>comment.attachments[0].id)
      else  
       %Q{ <a href="/group_activities/comment_attachment?id=#{comment.id}" id="comment_file<%=comment.id%>">Attachments</a><script>new Control.Modal($('comment_file<%=comment.id%>'), {className:'modal_container',width: 0,height: 0});</script>}
      end
    end
  end
  
  def last_send_message(parent_message)
    @send=Message.find(:last,:conditions=>['parent_id=?',parent_message.id])
    @send=parent_message if @send.nil?
    return @send
  end
  
  def read_status_search(collection)
    @read= current_user.message_users.find(:last,:conditions=>['messages.parent_id=?',collection.id],:include=>:message)
    @read= current_user.message_users.find(:last,:conditions=>['message_id=?',collection.id]) if @read.nil?
  end
  
  def is_leader?(group)
    group.group_leader_id==current_user.id
  end
end

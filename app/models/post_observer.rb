class PostObserver < ActiveRecord::Observer
  def after_create(post)
    if post.is_by_leader
      post.group.active_members.each do |mem|
        UserMailer.deliver_leader_update(mem.user,post) unless mem.user_id==post.user_id
      end
    elsif !post.is_group_log
      post.group.active_members.each do |mem|
        settings=mem.user.user_notification
        UserMailer.deliver_status_update(mem.user,post) if settings && settings.status_update && post.user_id!=mem.user_id
      end
    end
  end
end

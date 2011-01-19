class GroupUserObserver < ActiveRecord::Observer
  def after_create(group_user)
    group=group_user.group
    group.active_members.each do |grp_user|
      notification=grp_user.user.user_notification
      UserMailer.deliver_new_group_member(group_user.user,grp_user.user,group) if notification && notification.new_group_member && group_user.user_id!=grp_user.user_id
    end
  end
end

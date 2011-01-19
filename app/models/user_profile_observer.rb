class UserProfileObserver < ActiveRecord::Observer
  def after_save(user)
    member=user.user
    mail_items= member.find_mail_items
    if mail_items
      member.other_active_members.each do |u|
        UserMailer.deliver_contacts_changed(member,u,mail_items) if u.user_notification && u.user_notification.members_info_change
      end
    end
  end
end

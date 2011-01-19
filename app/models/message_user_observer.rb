class MessageUserObserver < ActiveRecord::Observer
  def after_create(message_user)
    no_mail=message_user.status=="draftmine" || message_user.status=="draft" || message_user.user_id==message_user.message.user_id
    message_notification=message_user.user.user_notification && message_user.user.user_notification.new_message
    message_thread_notification=message_user.user.user_notification && message_user.user.user_notification.new_activity_message_thread
    if (message_user.message.parent_id && message_thread_notification) || (message_user.message.parent_id.nil? && message_notification)
      UserMailer.deliver_message_notification(message_user) unless no_mail
    end
  end
end

class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(user)
     UserMailer.deliver_member_info(user)
  end

  def after_save(user)
  
    UserMailer.deliver_activation(user) if user.recently_activated?
   
  end
  
  def before_save(user)
    UserMailer.deliver_status_update(user,group,content)
  end
  
end

class AdminObserver < ActiveRecord::Observer
	
  def after_create(admin)
    AdminMailer.deliver_signup_notification(admin)
  end

  def after_save(admin)
  
    AdminMailer.deliver_activation(admin) if admin.recently_activated?
  
  end
end

class AdminMailer < ActionMailer::Base

  def signup_notification(admin)
    setup_email(admin)
    @subject    += 'Please activate your new account'
       @url  = "http://YOURSITE/activate/#{admin.activation_code}"
  end
  
  def activation(admin)
    setup_email(admin)
    @subject    += 'Your account has been activated!'
    @url  = "http://YOURSITE/"
  end
  
  protected

  def setup_email(admin)
    @recipients  = "#{admin.email}"
    @from        = "ADMINEMAIL"
    @subject     = "[YOURSITE] "
    @sent_on     = Time.now
    @admin = admin
  end

end

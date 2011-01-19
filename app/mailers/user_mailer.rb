class UserMailer < ActionMailer::Base

  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
       @url  = "http://localhot:3000/activate/#{user.activation_code}"
  end

 def close_code(user)
	setup_email(user)
	@user=user
    @subject    = 'You have requested to close your account'
	@url  = "http://localhot:3000/user_close_account_reason/#{user.close_code}" 
end

  def change_email_notification(user)
       #~ @recipients  = "#{user.primary_email}"
       #~ @from        = "ADMINEMAIL"
       #~ @sent_on     = Time.now
      @user = user
      @subject    += 'Request to change the email address'
      @url  = "http://localhost:3000/email_activate/#{user.primary_activiation_code}"
      mail(:from => "ADMINEMAIL", :to =>user.primary_email, :subject =>"hi")
    end

  def forgot_password(user)
    setup_email(user)
    @user=user
    @subject    += 'Your request to reset your GroupHopper password'
    @url  = "http://localhot:3000/user_reset_password/#{user.password_reset_code}"
  end

  def password_changed(user)
    setup_email(user)
    @subject +="Confirmation of password change"
  end


  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @url  = "http://localhost:3000/"
  end

  protected

  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "ADMINEMAIL"
    @subject     = "[Goalflo] "
    @sent_on     = Time.now
    @user = user
  end

end

class AdminMailer < ActionMailer::Base
  def new_csr(email,password,firstname)
    setup_email(email)
    @subject = "New CSR"
    @password=password
    @firstname=firstname
    @body[:url]="#{$SITE_URL}admin"
  end
	def change_leader(group,code)
    setup_email(group.leader_email_invite)
    @subject    =  "Invitation to join the group #{group.name} on GroupHopper"
    @body[:url]  = "#{$SITE_URL}invite_leader/#{code}"
    @message=""
    @message=group.message unless group.message.nil? || group.message.empty?
  end
  def change_password(admin)
		setup_email(admin.email)
		@subject ="Change Password"
		@password=admin.password
		@name="#{admin.firstname} #{admin.lastname}"
		@email=admin.email
    @body[:url]="#{$SITE_URL}"
	end
	def forgot_password(admin)
	  setup_email(admin.email)
		@admin=admin
    @subject= 'You have requested to change your password'
		@body[:url]  = "#{$SITE_URL}reset_password/#{admin.password_reset_code}" 
	end
	def signup_notification(admin)
    setup_email(admin)
    @subject    = 'Please activate your new account'
    @body[:url]  = "#{$SITE_URL}activate/#{admin.activation_code}"
  end
  def activation(admin)
    setup_email(admin)
    @subject    = 'Your account has been activated!'
    @body[:url]  = "#{$SITE_URL}"
  end
  protected
	def setup_email(admin)
		@recipients  = admin
    @from        = "GroupHopper <noreply@grouphopper.com>"
    @sent_on     = Time.now
    #@body[:admin] = admin
  end
end

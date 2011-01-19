require 'test_helper'
require 'admin_mailer'

class AdminMailerTest < ActionMailer::TestCase

  def setup
    @admin = admins(:quentin)
  end


  test "signup_notification" do
    # Send the email, then test that it got queued
    email = UserMailer.signup_notification(@admin).deliver
   assert !ActionMailer::Base.deliveries.empty?

   assert_equal [@admin.email], email.to
    assert_equal "[YOURSITE] Please activate your new account", email.subject
    assert_match /Your account has been created./, email.encoded
    assert_match /Visit this url to activate your account/, email.encoded
  end

  test "activation" do
    email = UserMailer.activation(@admin).deliver
   assert !ActionMailer::Base.deliveries.empty?

    assert_equal [@admin.email], email.to
    assert_equal "[YOURSITE] Your account has been activated!", email.subject
    assert_match /your account has been activated.  Welcome aboard!/, email.encoded
    assert_match /http\:\/\/YOURSITE\//, email.encoded
  end

end

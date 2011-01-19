require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "close_code" do
    mail = UserMailer.close_code
    assert_equal "Close code", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end

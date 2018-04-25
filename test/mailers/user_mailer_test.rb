require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:Kevin)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "账户验证", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded.gsub("=\n", "")
    assert_match CGI.escape(user.email), mail.body.encoded
  end

  test "password_reset" do
    user = users(:Kevin)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "密码重置", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
    assert_match user.name, mail.body.encoded
    assert_match user.reset_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

end

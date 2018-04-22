require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user: { name: "", email: "user@com.cn",
                                 password: "123",
                                 password_confirmation: "456"}}
    end
    assert_template "users/new"
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
  end

  test "valid signup information" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: "test_user", email: "test_user@email.com",
                                 password: "test_user",
                                 password_confirmation: "test_user"}}
    end
    assert_equal 1,ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    log_in_as(user)
    assert_not is_logged_in?
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    assert_redirected_to root_url
    get edit_account_activation_path(user.activation_token, email: "invalid")
    assert_not is_logged_in?
    assert_redirected_to root_url
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template "users/show"
    assert flash[:success]
    assert is_logged_in?
  end
end

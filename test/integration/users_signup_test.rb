require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

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
    follow_redirect!
    assert_template "users/show"
    assert flash[:success]
  end
end

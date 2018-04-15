require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name: "Example Name", email: "user@example.com",
                     password: "foobar123", password_confirmation: "foobar123")
  end

  test "user should be vaild" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "         "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "         "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email addresses should be valid" do
    valid_addresses = %w[user@example.com USER@foo.COM U_SE-R@foo.bar.org
      first.last@foo.ja user+wk@com.cn]
    valid_addresses.each { |valid_addr|
      @user.email = valid_addr
      assert @user.valid?, "#{valid_addr} should be valid"
    }

    invalid_addresses = %w[user@example U_SE-R.org
      first.last@foo.ja@com.cn user+wk@bar+com.cn]
    invalid_addresses.each { |invalid_addr|
      @user.email = invalid_addr
      assert_not @user.valid?, "#{invalid_addr} should be invalid"
    }
  end

  test "email addresses should be unique" do
    dup_user = @user.dup
    dup_user.email = @user.email.upcase
    @user.save
    assert_not dup_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    email_addr = "User@Example.com"
    @user.email = email_addr
    @user.save
    assert_equal email_addr.downcase, @user.reload.email
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 8
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
end

require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:Kevin)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select "div.pagination"
    assert_select "input[type=file]"
    assert_no_difference "Micropost.count" do
      post microposts_path, params: {micropost: {content: ""}}
    end
    assert_select "div#error_explanation"
    content = "test content"
    picture = fixture_file_upload("test/fixtures/rails.png", "image/png")
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: {micropost: {content: content, picture: picture}}
    end
    assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    assert_select "a", text: "删除"
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_micropost)
    end
    get user_path(users(:Mark))
    assert_select "a", text: "删除", count: 0
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    other_user = users(:user_0)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "test content")
    get root_path
    assert_match "1 micropost", response.body
  end
end

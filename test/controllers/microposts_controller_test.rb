require 'test_helper'

class MicrropostsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @micropost = microposts(:one)
    @user = users(:Kevin)
  end

  test "should redirect create when not logged in" do
    assert_no_difference "Micropost.count" do
      post microposts_path, params: {micropost: {content: "test content"}}
    end
    assert_redirected_to login_url
  end

  test "should redirect destory when not logged in" do
    assert_no_difference "Micropost.count" do
      delete micropost_path(@micropost)
    end
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(@user)
    micropost = microposts(:two)
    assert_no_difference "Micropost.count" do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end
end

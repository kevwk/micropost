require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "Micropost"
  end

  test "根路由" do
    get root_url
    assert_response :success
    assert_select "title", "主页 | #{@base_title}"
  end
  test "主页跳转" do
    get home_path
    assert_response :success
	  assert_select "title", "主页 | #{@base_title}"
  end

  test "帮助页面跳转" do
    get help_path
    assert_response :success
	  assert_select "title", "帮助 | #{@base_title}"
  end

  test "关于页面跳转" do
    get about_path
	  assert_response :success
	  assert_select "title", "关于 | #{@base_title}"
  end

  test "联系页面跳转" do
    get contact_path
    assert_response :success
    assert_select "title", "联系 | #{@base_title}"
  end
end

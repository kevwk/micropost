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
    get static_pages_home_url
    assert_response :success
	assert_select "title", "主页 | #{@base_title}"
  end

  test "帮助页面跳转" do
    get static_pages_help_url
    assert_response :success
	assert_select "title", "帮助 | #{@base_title}"
  end

  test "关于页面跳转" do
    get static_pages_about_url
	assert_response :success
	assert_select "title", "关于 | #{@base_title}"
  end
end

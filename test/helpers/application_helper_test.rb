require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full_title" do
    assert_equal full_title, "Micropost"
    assert_equal full_title("帮助"), "帮助 | Micropost"
  end
end

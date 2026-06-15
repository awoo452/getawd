require "test_helper"

class Home::IndexDataTest < ActiveSupport::TestCase
  test "returns without error" do
    assert_nothing_raised { Home::IndexData.call }
  end

  test "returns featured collections" do
    result = Home::IndexData.call
    assert_respond_to result, :featured_projects
    assert_respond_to result, :featured_blog_posts
    assert_respond_to result, :featured_videos
    assert_respond_to result, :featured_services
  end
end

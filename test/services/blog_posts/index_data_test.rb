require "test_helper"

class BlogPosts::IndexDataTest < ActiveSupport::TestCase
  PAGINATOR = ->(scope, per_page:) { [scope.to_a, 1, 1] }

  test "returns without error" do
    assert_nothing_raised { BlogPosts::IndexData.call(paginator: PAGINATOR) }
  end

  test "returns blog_posts with page metadata" do
    result = BlogPosts::IndexData.call(paginator: PAGINATOR)
    assert_respond_to result, :blog_posts
    assert_equal 1, result.blog_posts_page
    assert_equal 1, result.blog_posts_total_pages
  end

  test "blog_posts are ordered newest first" do
    result = BlogPosts::IndexData.call(paginator: PAGINATOR)
    dates = result.blog_posts.map(&:created_at)
    assert_equal dates.sort.reverse, dates
  end
end

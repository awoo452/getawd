require "test_helper"

class Videos::IndexDataTest < ActiveSupport::TestCase
  PAGINATOR = ->(scope, per_page:) { [scope.to_a, 1, 1] }

  test "returns without error" do
    assert_nothing_raised { Videos::IndexData.call(paginator: PAGINATOR) }
  end

  test "returns videos with page metadata" do
    result = Videos::IndexData.call(paginator: PAGINATOR)
    assert_respond_to result, :videos
    assert_equal 1, result.videos_page
    assert_equal 1, result.videos_total_pages
  end
end

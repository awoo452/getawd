require "test_helper"

class Documents::IndexDataTest < ActiveSupport::TestCase
  PAGINATOR = ->(scope, per_page:) { [scope.to_a, 1, 1] }

  test "returns without error" do
    assert_nothing_raised { Documents::IndexData.call(paginator: PAGINATOR) }
  end

  test "returns documents" do
    result = Documents::IndexData.call(paginator: PAGINATOR)
    assert_respond_to result, :documents
  end
end

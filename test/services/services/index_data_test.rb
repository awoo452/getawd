require "test_helper"

class Services::IndexDataTest < ActiveSupport::TestCase
  PAGINATOR = ->(scope, per_page:) { [scope.to_a, 1, 1] }

  test "returns without error" do
    assert_nothing_raised { Services::IndexData.call(paginator: PAGINATOR) }
  end

  test "returns services with page metadata" do
    result = Services::IndexData.call(paginator: PAGINATOR)
    assert_respond_to result, :services
    assert_equal 1, result.services_page
  end
end

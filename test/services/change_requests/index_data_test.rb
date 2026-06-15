require "test_helper"

class ChangeRequests::IndexDataTest < ActiveSupport::TestCase
  test "returns without error" do
    assert_nothing_raised { ChangeRequests::IndexData.call }
  end

  test "returns open and completed change requests" do
    result = ChangeRequests::IndexData.call
    assert_respond_to result, :open_change_requests
    assert_respond_to result, :completed_change_requests
  end

  test "open change requests excludes completed ones" do
    cr = change_requests(:one)
    cr.update!(status: "new")
    assert_includes ChangeRequests::IndexData.call.open_change_requests, cr
  end
end

require "test_helper"

class ChangeRequestTest < ActiveSupport::TestCase
  test "requires requester name, email, summary, and details" do
    request = ChangeRequest.new

    assert_not request.valid?
    assert_includes request.errors[:requester_name], "can't be blank"
    assert_includes request.errors[:requester_email], "can't be blank"
    assert_includes request.errors[:summary], "can't be blank"
    assert_includes request.errors[:details], "can't be blank"
  end
end

require "test_helper"

class Bugs::IndexDataTest < ActiveSupport::TestCase
  test "returns without error" do
    assert_nothing_raised { Bugs::IndexData.call }
  end

  test "returns open and completed bugs" do
    result = Bugs::IndexData.call
    assert_respond_to result, :open_bugs
    assert_respond_to result, :completed_bugs
  end
end

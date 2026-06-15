require "test_helper"

class Landscaping::IndexDataTest < ActiveSupport::TestCase
  test "returns without error" do
    assert_nothing_raised { Landscaping::IndexData.call }
  end

  test "returns jobs" do
    result = Landscaping::IndexData.call
    assert_respond_to result, :jobs
    assert_includes result.jobs, landscaping_jobs(:one)
  end
end

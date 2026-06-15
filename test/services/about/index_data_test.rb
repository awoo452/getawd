require "test_helper"

class About::IndexDataTest < ActiveSupport::TestCase
  test "returns without error" do
    assert_nothing_raised { About::IndexData.call }
  end

  test "returns about_sections" do
    result = About::IndexData.call
    assert_respond_to result, :about_sections
  end
end

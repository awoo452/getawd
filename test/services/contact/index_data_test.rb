require "test_helper"

class Contact::IndexDataTest < ActiveSupport::TestCase
  test "returns without error" do
    assert_nothing_raised { Contact::IndexData.call }
  end

  test "returns contact_info as a hash" do
    result = Contact::IndexData.call
    assert_kind_of Hash, result.contact_info
  end
end

require "test_helper"

class LandscapingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get landscaping_index_url
    assert_response :success
  end
end

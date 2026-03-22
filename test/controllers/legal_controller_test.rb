require "test_helper"

class LegalControllerTest < ActionDispatch::IntegrationTest
  test "renders terms" do
    get terms_url

    assert_response :success
    assert_match "Terms", response.body
  end

  test "renders privacy" do
    get privacy_url

    assert_response :success
    assert_match "Privacy", response.body
  end

  test "renders accessibility" do
    get accessibility_url

    assert_response :success
    assert_match "Accessibility", response.body
  end
end

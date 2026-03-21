require "application_system_test_case"

class DocumentsTest < ApplicationSystemTestCase
  setup do
    @document = documents(:one)
    @user = users(:one)
    sign_in @user
  end

  test "visiting the index" do
    visit documents_url
    assert_selector "h1", text: "Documents"
  end

  test "should show document" do
    visit document_url(@document)
    assert_selector "h1", text: @document.title
  end
end

require "application_system_test_case"

class GoalsTest < ApplicationSystemTestCase
  setup do
    @goal = goals(:one)
    @idea = ideas(:one)
    @user = users(:one)
    sign_in @user
  end

  test "visiting the index" do
    visit goals_url
    assert_selector "h1", text: "Goals"
  end

  test "should create goal" do
    visit dashboard_url
    click_on "New Goal"

    new_title = "New Goal Title"
    fill_in "Title", with: new_title
    select @idea.title, from: "Idea"
    click_on "Save Goal"

    assert_text new_title
  end

  test "should update Goal" do
    visit goal_url(@goal)
    click_on "Edit this Goal", match: :first

    updated_title = "Updated Goal Title"
    fill_in "Title", with: updated_title
    click_on "Save Goal"

    assert_text updated_title
  end

  test "should destroy Goal" do
    visit goal_url(@goal)
    click_on "Delete Goal", match: :first

    assert_current_path goals_path
  end
end

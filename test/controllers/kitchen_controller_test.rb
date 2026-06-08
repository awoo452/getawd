require "test_helper"

class KitchenControllerTest < ActionDispatch::IntegrationTest
  test "index is successful" do
    get kitchen_url
    assert_response :success
  end

  test "index renders meal planner grid with day headers" do
    get kitchen_url
    assert_response :success
    assert_select ".meal-planner-table"
    assert_select ".meal-planner-day-name"
  end

  test "week route is successful" do
    get kitchen_week_url("2026-06-08")
    assert_response :success
  end

  test "week route shows the sunday of the requested week" do
    get kitchen_week_url("2026-06-08")
    # 2026-06-08 (Mon) → week start is 2026-06-07 (Sun), shown as "Jun 7"
    assert_match "Jun 7", response.body
  end

  test "invalid week_start falls back gracefully" do
    get kitchen_week_url("not-a-date")
    assert_response :success
  end

  test "planned meal recipe name appears in the week view" do
    week_sunday = Date.new(2026, 6, 7)
    MealPlan.create!(
      planned_on: week_sunday,
      meal_slot:  :breakfast,
      recipe:     recipes(:breakfast_recipe)
    )
    get kitchen_week_url("2026-06-07")
    assert_match "Scrambled Eggs", response.body
  end
end

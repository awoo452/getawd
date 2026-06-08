require "test_helper"

class WorkoutsControllerTest < ActionDispatch::IntegrationTest
  test "index is successful" do
    get workouts_url
    assert_response :success
  end

  test "index renders the 7-day planner grid" do
    get workouts_url
    assert_select ".workout-planner-grid"
    assert_select ".workout-day-card", 7
  end

  test "week route is successful" do
    get workouts_week_url("2026-06-08")
    assert_response :success
  end

  test "week route shows the sunday of the requested week" do
    get workouts_week_url("2026-06-10")
    # 2026-06-10 (Wed) → week start is 2026-06-07 (Sun)
    assert_match "Jun 7", response.body
  end

  test "invalid week_start falls back gracefully" do
    get workouts_week_url("garbage")
    assert_response :success
  end

  test "planned workout appears in the week view" do
    date = Date.new(2026, 6, 7)
    WorkoutPlan.create!(planned_on: date, workout_type: :walk)
    get workouts_week_url("2026-06-07")
    assert_match "Dog Walk", response.body
  end

  test "week summary counts are shown" do
    get workouts_url
    assert_select ".week-summary-count"
  end
end

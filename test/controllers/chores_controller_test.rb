require "test_helper"

class ChoresControllerTest < ActionDispatch::IntegrationTest
  test "index is successful" do
    get chores_url
    assert_response :success
  end

  test "index renders 7 day cards" do
    get chores_url
    assert_select ".chore-day-card", 7
  end

  test "week route is successful" do
    get chores_week_url("2026-06-08")
    assert_response :success
  end

  test "week route shows the sunday of the requested week" do
    get chores_week_url("2026-06-10")
    assert_match "Jun 7", response.body
  end

  test "invalid week_start falls back gracefully" do
    get chores_week_url("garbage")
    assert_response :success
  end

  test "planned chore appears in the week view" do
    ChorePlan.create!(planned_on: Date.new(2026, 6, 7), chore_type: :laundry)
    get chores_week_url("2026-06-07")
    assert_match "Laundry", response.body
  end
end

require "test_helper"

class MealCellResponderTest < ActionDispatch::IntegrationTest
  def setup
    @mp = meal_plans(:one)
  end

  test "respond_with_cell replaces the correct turbo stream target" do
    patch toggle_cooked_meal_plan_url(@mp), as: :turbo_stream
    assert_match "meal_cell_#{@mp.planned_on.iso8601}_#{@mp.meal_slot}", response.body
  end

  test "respond_with_cell returns turbo stream on turbo request" do
    patch toggle_cooked_meal_plan_url(@mp), as: :turbo_stream
    assert_response :ok
    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
  end

  test "respond_with_cell redirects to kitchen on html request" do
    patch toggle_cooked_meal_plan_url(@mp)
    assert_redirected_to kitchen_url
  end

  test "respond_with_empty_cell replaces the correct turbo stream target" do
    date = @mp.planned_on
    slot = @mp.meal_slot
    delete meal_plan_url(@mp), as: :turbo_stream
    assert_match "meal_cell_#{date.iso8601}_#{slot}", response.body
  end

  test "respond_with_empty_cell returns turbo stream on turbo request" do
    delete meal_plan_url(@mp), as: :turbo_stream
    assert_response :ok
  end

  test "respond_with_empty_cell redirects to kitchen on html request" do
    delete meal_plan_url(@mp)
    assert_redirected_to kitchen_url
  end
end

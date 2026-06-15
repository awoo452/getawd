require "test_helper"

class Kitchen::IndexDataTest < ActiveSupport::TestCase
  def call(params = {})
    Kitchen::IndexData.call(params: ActionController::Parameters.new(params))
  end

  # ── date parsing ─────────────────────────────────────────
  test "defaults selected_date to today when param is absent" do
    assert_equal Date.current, call.selected_date
  end

  test "parses selected_date from param" do
    result = call(selected_date: "2026-07-04")
    assert_equal Date.new(2026, 7, 4), result.selected_date
  end

  test "falls back to today when selected_date is invalid" do
    assert_equal Date.current, call(selected_date: "not-a-date").selected_date
  end

  test "selected_col is the weekday integer of selected_date" do
    result = call(selected_date: "2026-07-05")  # Sunday = 0
    assert_equal Date.new(2026, 7, 5).wday, result.selected_col
  end

  # ── week_start ───────────────────────────────────────────
  test "week_start is the sunday of the selected_date's week when selected_date is present" do
    result = call(selected_date: "2026-07-08")  # Wednesday
    assert_equal Date.new(2026, 7, 5), result.week_start  # prior Sunday
  end

  test "week_start falls back to current week sunday when week_start param is invalid" do
    result = call(week_start: "garbage")
    assert_equal Date.current.beginning_of_week(:sunday), result.week_start
  end

  test "week_dates contains 7 days starting from week_start" do
    result = call(selected_date: "2026-07-05")
    assert_equal 7, result.week_dates.size
    assert_equal Date.new(2026, 7, 5), result.week_dates.first
    assert_equal Date.new(2026, 7, 11), result.week_dates.last
  end

  # ── pantry counts ────────────────────────────────────────
  test "returns out_of_stock_count" do
    pantry_items(:bread_pantry).update!(servings_on_hand: 0)
    assert_equal 1, call.out_of_stock_count
  end

  test "returns low_stock_count" do
    pantry_items(:eggs_pantry).update!(servings_on_hand: 1.0)
    assert call.low_stock_count >= 1
  end

  # ── recipes_for_slot ─────────────────────────────────────
  test "recipes_for_slot has a key for every MealPlan slot" do
    result = call
    MealPlan::SLOTS.each { |slot| assert_includes result.recipes_for_slot.keys, slot }
  end

  test "recipes_for_slot returns matching recipes for a slot" do
    result = call
    assert_includes result.recipes_for_slot["breakfast"], recipes(:breakfast_recipe)
  end

  test "recipes_for_slot returns empty array for slots with no recipes" do
    result = call
    assert_equal [], result.recipes_for_slot.fetch("bedtime_snack", [])
  end

  # ── food_items_grouped ───────────────────────────────────
  test "food_items_grouped is a hash of humanized type to name/id pairs" do
    result = call
    assert_kind_of Hash, result.food_items_grouped
    result.food_items_grouped.each do |type, items|
      assert_kind_of String, type
      items.each { |pair| assert_equal 2, pair.size }
    end
  end

  # ── meal_plans_by_date_slot ──────────────────────────────
  test "meal_plans_by_date_slot indexes meal plans by date and slot" do
    mp = meal_plans(:one)
    result = call(selected_date: mp.planned_on.to_s)
    assert_equal mp, result.meal_plans_by_date_slot[[mp.planned_on, mp.meal_slot]]
  end
end

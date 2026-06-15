require "test_helper"

class MealPlanItemTest < ActiveSupport::TestCase
  test "valid with meal_plan, food_item, and positive quantity" do
    item = MealPlanItem.new(
      meal_plan: meal_plans(:two),
      food_item: food_items(:eggs),
      quantity: 2
    )
    assert item.valid?
  end

  test "invalid when quantity is zero" do
    item = meal_plan_items(:one)
    item.quantity = 0
    assert item.invalid?
  end

  test "invalid when quantity is negative" do
    item = meal_plan_items(:one)
    item.quantity = -1
    assert item.invalid?
  end
end

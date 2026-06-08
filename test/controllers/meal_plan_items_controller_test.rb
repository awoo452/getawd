require "test_helper"

class MealPlanItemsControllerTest < ActionDispatch::IntegrationTest
  # ── create ───────────────────────────────────────────────

  test "create adds item to existing meal plan" do
    mp = meal_plans(:one)
    assert_difference "MealPlanItem.count", 1 do
      post meal_plan_items_url, params: {
        planned_on:   mp.planned_on,
        meal_slot:    mp.meal_slot,
        food_item_id: food_items(:eggs).id,
        quantity:     2
      }
    end
    assert_equal 2, MealPlanItem.order(:created_at).last.quantity
  end

  test "create enforces minimum quantity of 1" do
    mp = meal_plans(:one)
    post meal_plan_items_url, params: {
      planned_on:   mp.planned_on,
      meal_slot:    mp.meal_slot,
      food_item_id: food_items(:eggs).id,
      quantity:     0
    }
    assert_equal 1, MealPlanItem.order(:created_at).last.quantity
  end

  test "create returns 422 when food_item_id is blank" do
    assert_no_difference "MealPlanItem.count" do
      post meal_plan_items_url, params: {
        planned_on:   "2026-09-01",
        meal_slot:    "breakfast",
        food_item_id: ""
      }
    end
    assert_response :unprocessable_entity
  end

  test "create creates a new meal plan when slot is empty" do
    assert_difference "MealPlan.count", 1 do
      post meal_plan_items_url, params: {
        planned_on:   "2026-09-15",
        meal_slot:    "lunch",
        food_item_id: food_items(:eggs).id,
        quantity:     1
      }
    end
  end

  # ── destroy ──────────────────────────────────────────────

  test "destroy removes the item" do
    assert_difference "MealPlanItem.count", -1 do
      delete meal_plan_item_url(meal_plan_items(:one))
    end
  end

  test "destroy keeps the meal plan when it still has a recipe" do
    item = meal_plan_items(:one)
    assert item.meal_plan.recipe.present?
    assert_no_difference "MealPlan.count" do
      delete meal_plan_item_url(item)
    end
  end

  test "destroy removes meal plan when it has no recipe and no remaining items" do
    mp = MealPlan.create!(planned_on: Date.new(2026, 9, 20), meal_slot: :dinner)
    item = mp.meal_plan_items.create!(food_item: food_items(:eggs), quantity: 1)
    assert_difference "MealPlan.count", -1 do
      delete meal_plan_item_url(item)
    end
  end
end

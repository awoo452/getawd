require "test_helper"

class MealPlansControllerTest < ActionDispatch::IntegrationTest
  def setup
    @recipe = recipes(:breakfast_recipe)
    @meal_plan = meal_plans(:one)
  end

  # ── create ───────────────────────────────────────────────

  test "create makes a meal plan and redirects to kitchen" do
    assert_difference "MealPlan.count", 1 do
      post meal_plans_url, params: {
        meal_plan: { planned_on: "2026-07-10", meal_slot: "breakfast", recipe_id: @recipe.id }
      }
    end
    assert_redirected_to kitchen_url
  end

  test "create also generates a task" do
    assert_difference "Task.count", 1 do
      post meal_plans_url, params: {
        meal_plan: { planned_on: "2026-07-10", meal_slot: "breakfast", recipe_id: @recipe.id }
      }
    end
  end

  test "create with recipe_id also creates a meal_plan_recipe" do
    assert_difference "MealPlanRecipe.count", 1 do
      post meal_plans_url, params: {
        meal_plan: { planned_on: "2026-07-11", meal_slot: "breakfast", recipe_id: @recipe.id }
      }
    end
  end

  test "create with duplicate slot redirects with alert" do
    existing = meal_plans(:one)
    assert_no_difference "MealPlan.count" do
      post meal_plans_url, params: {
        meal_plan: { planned_on: existing.planned_on, meal_slot: existing.meal_slot, recipe_id: @recipe.id }
      }
    end
    assert_redirected_to kitchen_url
    assert flash[:alert].present?
  end

  # ── destroy ──────────────────────────────────────────────

  test "destroy removes the meal plan and redirects to kitchen" do
    mp = MealPlan.create!(planned_on: Date.new(2026, 8, 1), meal_slot: :dinner)
    mp.meal_plan_recipes.create!(recipe: recipes(:dinner_recipe))
    assert_difference "MealPlan.count", -1 do
      delete meal_plan_url(mp)
    end
    assert_redirected_to kitchen_url
  end

  test "destroy also removes the generated task" do
    mp = MealPlan.create!(planned_on: Date.new(2026, 8, 2), meal_slot: :lunch)
    mp.meal_plan_recipes.create!(recipe: recipes(:lunch_recipe))
    assert_difference "Task.count", -1 do
      delete meal_plan_url(mp)
    end
  end

  # ── toggle_cooked ────────────────────────────────────────

  test "toggle_cooked marks meal plan as cooked and deducts inventory" do
    mp = meal_plans(:one)
    patch toggle_cooked_meal_plan_url(mp)
    assert mp.reload.cooked?
    assert_equal 3.0,  food_items(:eggs).pantry_item.reload.servings_on_hand   # 6 - 3
    assert_equal 8.0,  food_items(:bacon).pantry_item.reload.servings_on_hand  # 11 - 2 recipe - 1 item
  end

  test "toggle_cooked unmarks cooked and restores inventory" do
    mp = meal_plans(:one)
    patch toggle_cooked_meal_plan_url(mp)  # cook
    patch toggle_cooked_meal_plan_url(mp)  # uncook
    assert_not mp.reload.cooked?
    assert_equal 6.0,  food_items(:eggs).pantry_item.reload.servings_on_hand
    assert_equal 11.0, food_items(:bacon).pantry_item.reload.servings_on_hand
  end
end

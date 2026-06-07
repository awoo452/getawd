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
    mp = MealPlan.create!(
      planned_on: Date.new(2026, 8, 1),
      meal_slot: :dinner,
      recipe: recipes(:dinner_recipe)
    )
    assert_difference "MealPlan.count", -1 do
      delete meal_plan_url(mp)
    end
    assert_redirected_to kitchen_url
  end

  test "destroy also removes the generated task" do
    mp = MealPlan.create!(
      planned_on: Date.new(2026, 8, 2),
      meal_slot: :lunch,
      recipe: recipes(:lunch_recipe)
    )
    assert_difference "Task.count", -1 do
      delete meal_plan_url(mp)
    end
  end

  # ── update ───────────────────────────────────────────────

  test "update changes the recipe and redirects to kitchen" do
    mp = MealPlan.create!(
      planned_on: Date.new(2026, 8, 3),
      meal_slot: :breakfast,
      recipe: @recipe
    )
    patch meal_plan_url(mp), params: {
      meal_plan: { recipe_id: recipes(:lunch_recipe).id }
    }
    assert_redirected_to kitchen_url
    assert_equal "Breakfast — Turkey Sandwich", mp.task.reload.task_name
  end
end

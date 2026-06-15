require "test_helper"

class MealPlanRecipeTest < ActiveSupport::TestCase
  # ── validations ──────────────────────────────────────────
  test "valid with quantity above zero" do
    assert meal_plan_recipes(:one).valid?
  end

  test "invalid when quantity is zero" do
    mpr = meal_plan_recipes(:one)
    mpr.quantity = 0
    assert mpr.invalid?
  end

  test "invalid when quantity is negative" do
    mpr = meal_plan_recipes(:one)
    mpr.quantity = -1
    assert mpr.invalid?
  end

  test "invalid when quantity is not an integer" do
    mpr = meal_plan_recipes(:one)
    mpr.quantity = 1.5
    assert mpr.invalid?
  end

  # ── uniqueness ───────────────────────────────────────────
  test "invalid when recipe is already on the same meal plan" do
    dupe = MealPlanRecipe.new(
      meal_plan: meal_plans(:one),
      recipe:    recipes(:breakfast_recipe),
      quantity:  1
    )
    assert dupe.invalid?
    assert_includes dupe.errors[:recipe_id], "has already been taken"
  end

  test "valid when same recipe is on a different meal plan" do
    mpr = MealPlanRecipe.new(
      meal_plan: meal_plans(:two),
      recipe:    recipes(:breakfast_recipe),
      quantity:  1
    )
    assert mpr.valid?
  end
end

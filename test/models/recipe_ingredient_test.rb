require "test_helper"

class RecipeIngredientTest < ActiveSupport::TestCase
  # ── Validations ─────────────────────────────────────────────
  test "invalid when quantity is zero" do
    ri = recipe_ingredients(:eggs_in_breakfast)
    ri.quantity = 0
    assert ri.invalid?
  end

  test "invalid when quantity is negative" do
    ri = recipe_ingredients(:eggs_in_breakfast)
    ri.quantity = -1
    assert ri.invalid?
  end

  test "duplicate food_item on the same recipe is invalid" do
    ri = RecipeIngredient.new(
      recipe: recipes(:breakfast_recipe),
      food_item: food_items(:eggs),
      quantity: 1
    )
    assert ri.invalid?
    assert ri.errors[:food_item_id].present?
  end

  test "same food_item on a different recipe is valid" do
    ri = RecipeIngredient.new(
      recipe: recipes(:dinner_recipe),
      food_item: food_items(:eggs),
      quantity: 1
    )
    assert ri.valid?
  end

  # ── set_slot_type ────────────────────────────────────────────
  test "set_slot_type is populated from food_item food_type when blank" do
    ri = RecipeIngredient.new(
      recipe: recipes(:dinner_recipe),
      food_item: food_items(:eggs),
      quantity: 1
    )
    ri.valid?
    assert_equal "protein", ri.slot_type
  end

  test "set_slot_type does not overwrite an existing slot_type" do
    ri = RecipeIngredient.new(
      recipe: recipes(:dinner_recipe),
      food_item: food_items(:eggs),
      quantity: 1,
      slot_type: "side"
    )
    ri.valid?
    assert_equal "side", ri.slot_type
  end
end

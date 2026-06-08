require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  # ── can_cook? ────────────────────────────────────────────

  test "can_cook? returns true when all ingredients are sufficiently stocked" do
    # eggs: 6 on hand, need 3 → ok; bacon: 11 on hand, need 2 → ok
    assert recipes(:breakfast_recipe).can_cook?
  end

  test "can_cook? returns false when an ingredient is short" do
    food_items(:eggs).pantry_item.update!(servings_on_hand: 2)
    assert_not recipes(:breakfast_recipe).can_cook?
  end

  test "can_cook? returns false when pantry item is missing" do
    food_items(:eggs).pantry_item.destroy
    assert_not recipes(:breakfast_recipe).can_cook?
  end

  # ── missing_ingredients ──────────────────────────────────

  test "missing_ingredients returns empty when fully stocked" do
    assert_empty recipes(:breakfast_recipe).missing_ingredients
  end

  test "missing_ingredients returns the short ingredient" do
    food_items(:eggs).pantry_item.update!(servings_on_hand: 0)
    missing = recipes(:breakfast_recipe).missing_ingredients
    assert_equal 1, missing.size
    assert_equal food_items(:eggs), missing.first.food_item
  end

  test "missing_ingredients returns all short ingredients" do
    food_items(:eggs).pantry_item.update!(servings_on_hand: 0)
    food_items(:bacon).pantry_item.update!(servings_on_hand: 0)
    assert_equal 2, recipes(:breakfast_recipe).missing_ingredients.size
  end
end

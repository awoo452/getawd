require "test_helper"

class FoodItemTest < ActiveSupport::TestCase
  def valid_attrs
    { name: "Oats", food_type: "side", location: "pantry", unit: "bag",
      position: 0, servings_per_unit: 1.0, active: true }
  end

  # ── Validations ─────────────────────────────────────────────
  test "valid with all required attributes" do
    assert FoodItem.new(valid_attrs).valid?
  end

  test "invalid without name" do
    fi = FoodItem.new(valid_attrs.merge(name: ""))
    assert fi.invalid?
    assert_includes fi.errors[:name], "can't be blank"
  end

  test "invalid with unrecognized food_type" do
    fi = FoodItem.new(valid_attrs.merge(food_type: "grain"))
    assert fi.invalid?
  end

  test "invalid with unrecognized location" do
    fi = FoodItem.new(valid_attrs.merge(location: "pantry"))
    assert fi.invalid?
  end

  test "invalid with unrecognized unit" do
    fi = FoodItem.new(valid_attrs.merge(unit: "pound"))
    assert fi.invalid?
  end

  test "invalid when servings_per_unit is zero" do
    fi = FoodItem.new(valid_attrs.merge(servings_per_unit: 0))
    assert fi.invalid?
  end

  test "invalid when unit_servings is zero" do
    fi = FoodItem.new(valid_attrs.merge(unit_servings: 0))
    assert fi.invalid?
  end

  test "unit_servings may be nil" do
    fi = FoodItem.new(valid_attrs.merge(unit_servings: nil))
    assert fi.valid?
  end

  # ── Labels / emoji ──────────────────────────────────────────
  test "type_label returns the human-readable label" do
    assert_equal "Protein", food_items(:eggs).type_label
  end

  test "type_emoji returns the correct emoji" do
    assert_equal "🍗", food_items(:eggs).type_emoji
  end

  test "location_label returns the human-readable label" do
    assert_equal "Fridge", food_items(:eggs).location_label
  end

  # ── Pantry auto-create ───────────────────────────────────────
  test "creating a food item automatically creates a pantry_item" do
    fi = nil
    assert_difference "PantryItem.count", 1 do
      fi = FoodItem.create!(valid_attrs)
    end
    assert_not_nil fi.pantry_item
    assert_equal 0, fi.pantry_item.servings_on_hand
  end

  # ── Scopes ──────────────────────────────────────────────────
  test "active scope excludes inactive items" do
    fi = FoodItem.create!(valid_attrs.merge(active: false))
    assert_not_includes FoodItem.active, fi
  end

  test "active scope includes active items" do
    assert_includes FoodItem.active, food_items(:eggs)
  end

  # ── Destroy restriction ──────────────────────────────────────
  test "destroy is blocked when meal_plan_items reference the food_item" do
    assert_not food_items(:bacon).destroy
    assert food_items(:bacon).errors[:base].present?
  end

  test "destroy succeeds when no meal_plan_items reference the food_item" do
    assert_difference "FoodItem.count", -1 do
      food_items(:bread).destroy
    end
  end
end

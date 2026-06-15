require "test_helper"

class FoodItemsControllerTest < ActionDispatch::IntegrationTest
  def valid_params(name: "Oats")
    { food_item: { name: name, food_type: "side", location: "cupboard",
                   unit: "bag", position: 0, servings_per_unit: 1.0, active: true } }
  end

  # ── index ────────────────────────────────────────────────────
  test "index is successful" do
    get food_items_path
    assert_response :success
  end

  # ── new ──────────────────────────────────────────────────────
  test "new is successful" do
    get new_food_item_path
    assert_response :success
  end

  # ── create ───────────────────────────────────────────────────
  test "create saves a food item and redirects" do
    assert_difference "FoodItem.count", 1 do
      post food_items_path, params: valid_params
    end
    assert_redirected_to food_items_path
    assert_match /added/, flash[:notice]
  end

  test "create also auto-creates a pantry_item" do
    assert_difference "PantryItem.count", 1 do
      post food_items_path, params: valid_params(name: "Quinoa")
    end
  end

  test "create with invalid params renders new with 422" do
    post food_items_path, params: { food_item: { name: "" } }
    assert_response :unprocessable_entity
  end

  # ── edit ─────────────────────────────────────────────────────
  test "edit is successful" do
    get edit_food_item_path(food_items(:eggs))
    assert_response :success
  end

  # ── update ───────────────────────────────────────────────────
  test "update with valid params redirects to food_items_path" do
    patch food_item_path(food_items(:eggs)),
          params: { food_item: { name: "Free-Range Eggs" } }
    assert_redirected_to food_items_path
    assert_equal "Free-Range Eggs", food_items(:eggs).reload.name
  end

  test "update with invalid params renders edit with 422" do
    patch food_item_path(food_items(:eggs)),
          params: { food_item: { name: "", food_type: "protein", location: "fridge",
                                 unit: "each", position: 0, servings_per_unit: 1.0 } }
    assert_response :unprocessable_entity
  end

  # ── destroy ──────────────────────────────────────────────────
  test "destroy removes the food item and redirects" do
    assert_difference "FoodItem.count", -1 do
      delete food_item_path(food_items(:bread))
    end
    assert_redirected_to food_items_path
    assert_match /removed/, flash[:notice]
  end

  test "destroy fails and shows alert when meal_plan_items reference the food_item" do
    assert_no_difference "FoodItem.count" do
      delete food_item_path(food_items(:bacon))
    end
    assert_redirected_to food_items_path
    assert_match /can't be deleted/, flash[:alert]
  end
end

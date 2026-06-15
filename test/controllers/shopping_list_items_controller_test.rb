require "test_helper"

class ShoppingListItemsControllerTest < ActionDispatch::IntegrationTest
  test "toggle check marks item checked and increments pantry" do
    item   = shopping_list_items(:unchecked_item)
    pantry = pantry_items(:eggs_pantry)
    before = pantry.servings_on_hand

    patch shopping_list_item_path(item), as: :turbo_stream
    assert_response :ok
    assert item.reload.checked_off
    # qty 2, unit_servings nil → 1.0, servings_per_unit 1.0 → +2.0
    assert_equal before + 2.0, pantry.reload.servings_on_hand
  end

  test "toggle uncheck marks item unchecked and decrements pantry" do
    item   = shopping_list_items(:checked_item)
    pantry = pantry_items(:bacon_pantry)
    before = pantry.servings_on_hand

    patch shopping_list_item_path(item), as: :turbo_stream
    assert_response :ok
    assert_not item.reload.checked_off
    # qty 1, unit_servings nil → 1.0, servings_per_unit 1.0 → -1.0
    assert_equal before - 1.0, pantry.reload.servings_on_hand
  end

  test "toggle does not go below zero servings on decrement" do
    item   = shopping_list_items(:checked_item)
    pantry_items(:bacon_pantry).update!(servings_on_hand: 0)

    patch shopping_list_item_path(item), as: :turbo_stream
    assert_response :ok
    assert_equal 0, pantry_items(:bacon_pantry).reload.servings_on_hand
  end

  test "replace swaps food item and resets to unchecked" do
    item     = shopping_list_items(:unchecked_item)
    new_food = food_items(:bread)

    patch replace_shopping_list_item_path(item),
          params: { food_item_id: new_food.id, quantity_needed: 3 },
          as: :turbo_stream
    assert_response :ok
    item.reload
    assert_equal new_food.id, item.food_item_id
    assert_equal 3, item.quantity_needed
    assert_not item.checked_off
  end

  test "replace decrements old pantry when item was checked" do
    item   = shopping_list_items(:checked_item)
    pantry = pantry_items(:bacon_pantry)
    before = pantry.servings_on_hand

    patch replace_shopping_list_item_path(item),
          params: { food_item_id: food_items(:bread).id, quantity_needed: 1 },
          as: :turbo_stream
    assert_response :ok
    # bacon qty 1, unit_servings nil → 1.0, servings_per_unit 1.0 → -1.0
    assert_equal before - 1.0, pantry.reload.servings_on_hand
    assert_not item.reload.checked_off
  end

  test "replace enforces minimum quantity of 1" do
    item = shopping_list_items(:unchecked_item)

    patch replace_shopping_list_item_path(item),
          params: { food_item_id: food_items(:bread).id, quantity_needed: 0 },
          as: :turbo_stream
    assert_response :ok
    assert_equal 1, item.reload.quantity_needed
  end
end

require "test_helper"

class ShoppingListsControllerTest < ActionDispatch::IntegrationTest
  test "index is successful" do
    get shopping_lists_path
    assert_response :success
  end

  test "show renders the list with items" do
    get shopping_list_path(shopping_lists(:active_list))
    assert_response :success
    assert_select "li#shopping_list_item_#{shopping_list_items(:unchecked_item).id}"
    assert_select "li#shopping_list_item_#{shopping_list_items(:checked_item).id}"
  end

  # ── Create ────────────────────────────────────────────────

  test "create generates a new list even when an active list already exists" do
    plan = MealPlan.create!(planned_on: Date.current, meal_slot: 0, cooked: false)
    plan.meal_plan_items.create!(food_item: food_items(:bread), quantity: 1, position: 1)

    assert_difference "ShoppingList.count", 1 do
      post shopping_lists_path
    end
  end

  test "create labels new list as From Meal Plans" do
    plan = MealPlan.create!(planned_on: Date.current, meal_slot: 0, cooked: false)
    plan.meal_plan_items.create!(food_item: food_items(:bread), quantity: 1, position: 1)

    post shopping_lists_path
    assert_equal "From Meal Plans", ShoppingList.order(:id).last.label
  end

  test "create generates list from planned meals with shortfalls" do
    plan = MealPlan.create!(planned_on: Date.current, meal_slot: 0, cooked: false)
    plan.meal_plan_items.create!(food_item: food_items(:bread), quantity: 1, position: 1)

    assert_difference "ShoppingList.count", 1 do
      post shopping_lists_path
    end
    assert_redirected_to ShoppingList.last
    assert_match /Shopping list generated/, flash[:notice]
    assert ShoppingList.last.shopping_list_items.any?
  end

  test "create does not add items that are already sufficiently stocked" do
    plan = MealPlan.create!(planned_on: Date.current, meal_slot: 0, cooked: false)
    # eggs has 6.0 on hand; breakfast recipe only needs 3 — no shortfall
    plan.meal_plan_recipes.create!(recipe: recipes(:breakfast_recipe), quantity: 1)

    assert_no_difference "ShoppingList.count" do
      post shopping_lists_path
    end
    assert_match /Nothing needed/, flash[:alert]
  end

  test "create alerts when no meals are planned" do
    assert_no_difference "ShoppingList.count" do
      post shopping_lists_path
    end
    assert_redirected_to shopping_lists_path
    assert_match /Nothing needed/, flash[:alert]
  end

  test "create skips cooked meal plans" do
    plan = MealPlan.create!(planned_on: Date.current, meal_slot: 0, cooked: true)
    plan.meal_plan_items.create!(food_item: food_items(:bread), quantity: 1, position: 1)

    assert_no_difference "ShoppingList.count" do
      post shopping_lists_path
    end
  end

  # ── Destroy / Archive ─────────────────────────────────────

  test "destroy deletes the list" do
    assert_difference "ShoppingList.count", -1 do
      delete shopping_list_path(shopping_lists(:archived_list))
    end
    assert_redirected_to shopping_lists_path
  end

  test "archive marks list as archived" do
    list = shopping_lists(:active_list)
    patch archive_shopping_list_path(list)
    assert_redirected_to shopping_lists_path
    assert_equal "archived", list.reload.status
  end
end

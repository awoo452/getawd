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

  def plan_with_bread
    plan = MealPlan.create!(planned_on: Date.current, meal_slot: 0, cooked: false)
    plan.meal_plan_items.create!(food_item: food_items(:bread), quantity: 1, position: 1)
    plan
  end

  test "create generates a From Meal Plans list on first run" do
    plan_with_bread
    assert_difference "ShoppingList.count", 1 do
      post shopping_lists_path
    end
    assert_equal "From Meal Plans", ShoppingList.order(:id).last.label
  end

  test "create reuses existing From Meal Plans list instead of creating a duplicate" do
    plan_with_bread
    post shopping_lists_path
    assert_no_difference "ShoppingList.count" do
      post shopping_lists_path
    end
  end

  test "regenerating replaces items on the existing From Meal Plans list" do
    plan_with_bread
    post shopping_lists_path
    list = ShoppingList.find_by!(label: "From Meal Plans")
    original_id = list.id

    post shopping_lists_path
    assert_equal original_id, ShoppingList.find_by!(label: "From Meal Plans").id
  end

  test "create generates list from planned meals with shortfalls" do
    plan_with_bread
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

  # ── Merge ─────────────────────────────────────────────────

  test "merge creates a new combined list" do
    assert_difference "ShoppingList.count", 1 do
      post merge_shopping_lists_path
    end
    assert_redirected_to ShoppingList.order(:id).last
  end

  test "merge takes MAX quantity for overlapping items" do
    post merge_shopping_lists_path
    merged = ShoppingList.order(:id).last
    eggs_item = merged.shopping_list_items.find_by!(food_item: food_items(:eggs))
    assert_equal 5, eggs_item.quantity_needed
  end

  test "merge includes non-overlapping items from both lists" do
    post merge_shopping_lists_path
    merged = ShoppingList.order(:id).last
    assert_equal 3, merged.shopping_list_items.count
    food_ids = merged.shopping_list_items.pluck(:food_item_id).to_set
    assert food_ids.include?(food_items(:eggs).id)
    assert food_ids.include?(food_items(:bacon).id)
    assert food_ids.include?(food_items(:bread).id)
  end

  test "merge archives all source lists" do
    post merge_shopping_lists_path
    assert_equal "archived", shopping_lists(:active_list).reload.status
    assert_equal "archived", shopping_lists(:active_list_two).reload.status
  end

  test "merge labels the new list with both source list names" do
    shopping_lists(:active_list).update!(label: "Ryder's Picks")
    shopping_lists(:active_list_two).update!(label: "From Meal Plans")
    post merge_shopping_lists_path
    merged = ShoppingList.order(:id).last
    assert_includes merged.label, "Ryder's Picks"
    assert_includes merged.label, "From Meal Plans"
  end

  test "merge redirects with alert when fewer than 2 active lists" do
    shopping_lists(:active_list_two).update!(status: "archived")
    assert_no_difference "ShoppingList.count" do
      post merge_shopping_lists_path
    end
    assert_redirected_to shopping_lists_path
    assert_match /at least 2/, flash[:alert]
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

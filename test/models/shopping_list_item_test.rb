require "test_helper"

class ShoppingListItemTest < ActiveSupport::TestCase
  # ── Validations ─────────────────────────────────────────────
  test "invalid when quantity_needed is zero" do
    item = shopping_list_items(:unchecked_item)
    item.quantity_needed = 0
    assert item.invalid?
  end

  test "invalid when quantity_needed is negative" do
    item = shopping_list_items(:unchecked_item)
    item.quantity_needed = -1
    assert item.invalid?
  end

  test "duplicate food_item on the same list is invalid" do
    item = ShoppingListItem.new(
      shopping_list: shopping_lists(:active_list),
      food_item: food_items(:eggs),
      quantity_needed: 1
    )
    assert item.invalid?
    assert item.errors[:food_item_id].present?
  end

  test "same food_item on a different list is valid" do
    item = ShoppingListItem.new(
      shopping_list: shopping_lists(:archived_list),
      food_item: food_items(:eggs),
      quantity_needed: 1
    )
    assert item.valid?
  end

  # ── toggle! ─────────────────────────────────────────────────
  test "toggle! flips unchecked to checked" do
    item = shopping_list_items(:unchecked_item)
    item.toggle!
    assert item.reload.checked_off
  end

  test "toggle! flips checked to unchecked" do
    item = shopping_list_items(:checked_item)
    item.toggle!
    assert_not item.reload.checked_off
  end

  # ── Scopes ──────────────────────────────────────────────────
  test "unchecked scope excludes checked items" do
    list = shopping_lists(:active_list)
    assert_not_includes list.shopping_list_items.unchecked, shopping_list_items(:checked_item)
  end

  test "unchecked scope includes unchecked items" do
    list = shopping_lists(:active_list)
    assert_includes list.shopping_list_items.unchecked, shopping_list_items(:unchecked_item)
  end

  test "checked scope includes checked items" do
    list = shopping_lists(:active_list)
    assert_includes list.shopping_list_items.checked, shopping_list_items(:checked_item)
  end

  test "checked scope excludes unchecked items" do
    list = shopping_lists(:active_list)
    assert_not_includes list.shopping_list_items.checked, shopping_list_items(:unchecked_item)
  end
end

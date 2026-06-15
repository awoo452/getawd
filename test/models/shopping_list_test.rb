require "test_helper"

class ShoppingListTest < ActiveSupport::TestCase
  # ── Validations ─────────────────────────────────────────────
  test "valid with status and generated_on" do
    list = ShoppingList.new(status: "active", generated_on: Date.current)
    assert list.valid?
  end

  test "invalid without generated_on" do
    list = ShoppingList.new(status: "active")
    assert list.invalid?
    assert_includes list.errors[:generated_on], "can't be blank"
  end

  test "invalid with unknown status" do
    list = ShoppingList.new(status: "pending", generated_on: Date.current)
    assert list.invalid?
  end

  # ── active? / archive! ──────────────────────────────────────
  test "active? is true for active list" do
    assert shopping_lists(:active_list).active?
  end

  test "active? is false for archived list" do
    assert_not shopping_lists(:archived_list).active?
  end

  test "archive! changes status to archived" do
    list = shopping_lists(:active_list)
    list.archive!
    assert_equal "archived", list.reload.status
  end

  # ── Scopes ──────────────────────────────────────────────────
  test "active scope includes active lists" do
    assert_includes ShoppingList.active, shopping_lists(:active_list)
  end

  test "active scope excludes archived lists" do
    assert_not_includes ShoppingList.active, shopping_lists(:archived_list)
  end

  test "archived scope includes archived lists" do
    assert_includes ShoppingList.archived, shopping_lists(:archived_list)
  end

  test "archived scope excludes active lists" do
    assert_not_includes ShoppingList.archived, shopping_lists(:active_list)
  end

  test "recent scope orders by generated_on descending" do
    dates = ShoppingList.recent.pluck(:generated_on)
    assert_equal dates.sort.reverse, dates
  end

  # ── checked_count / total_count / complete? ─────────────────
  test "total_count returns the number of items" do
    assert_equal 2, shopping_lists(:active_list).total_count
  end

  test "checked_count returns the number of checked items" do
    assert_equal 1, shopping_lists(:active_list).checked_count
  end

  test "complete? is false when not all items are checked" do
    assert_not shopping_lists(:active_list).complete?
  end

  test "complete? is true when all items are checked" do
    list = shopping_lists(:active_list)
    list.shopping_list_items.update_all(checked_off: true)
    assert list.complete?
  end

  test "complete? is false when list has no items" do
    assert_not shopping_lists(:archived_list).complete?
  end
end

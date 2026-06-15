require "test_helper"

class PantryItemTest < ActiveSupport::TestCase
  # ── out? ────────────────────────────────────────────────────
  test "out? is true when servings_on_hand is zero" do
    pi = pantry_items(:eggs_pantry)
    pi.update!(servings_on_hand: 0)
    assert pi.out?
  end

  test "out? is false when servings_on_hand is positive" do
    assert_not pantry_items(:eggs_pantry).out?
  end

  # ── low? ────────────────────────────────────────────────────
  test "low? is true when derived_servings is at min_servings" do
    pi = pantry_items(:eggs_pantry)
    pi.update!(servings_on_hand: 2.0)  # 2 / 1.0 = 2 == min_servings
    assert pi.low?
  end

  test "low? is true when derived_servings is below min_servings" do
    pi = pantry_items(:eggs_pantry)
    pi.update!(servings_on_hand: 1.0)
    assert pi.low?
  end

  test "low? is false when derived_servings is above min_servings" do
    assert_not pantry_items(:eggs_pantry).low?  # 6 > 2
  end

  test "low? is false when out of stock" do
    pi = pantry_items(:eggs_pantry)
    pi.update!(servings_on_hand: 0)
    assert_not pi.low?
  end

  # ── stock_status ─────────────────────────────────────────────
  test "stock_status is out when servings_on_hand is zero" do
    pi = pantry_items(:eggs_pantry)
    pi.update!(servings_on_hand: 0)
    assert_equal "out", pi.stock_status
  end

  test "stock_status is low when at minimum" do
    pi = pantry_items(:eggs_pantry)
    pi.update!(servings_on_hand: 2.0)
    assert_equal "low", pi.stock_status
  end

  test "stock_status is ok when above minimum" do
    assert_equal "ok", pantry_items(:eggs_pantry).stock_status
  end

  # ── derived_servings ─────────────────────────────────────────
  test "derived_servings returns an integer when result is whole" do
    assert_equal 6, pantry_items(:eggs_pantry).derived_servings
  end

  test "derived_servings returns a rounded decimal when fractional" do
    pi = pantry_items(:eggs_pantry)
    pi.update_column(:servings_on_hand, 6.55)
    assert_equal 6.6, pi.derived_servings
  end

  # ── validations ──────────────────────────────────────────────
  test "invalid when servings_on_hand is negative" do
    pi = pantry_items(:eggs_pantry)
    pi.servings_on_hand = -1
    assert pi.invalid?
  end

  test "invalid when min_servings is negative" do
    pi = pantry_items(:eggs_pantry)
    pi.min_servings = -1
    assert pi.invalid?
  end

  # ── increment! ───────────────────────────────────────────────
  test "increment! with no args adds servings_per_unit" do
    pi = pantry_items(:eggs_pantry)
    before = pi.servings_on_hand
    pi.increment!
    assert_equal before + 1.0, pi.reload.servings_on_hand  # servings_per_unit = 1.0
  end

  test "increment! with amount adds that amount" do
    pi = pantry_items(:eggs_pantry)
    before = pi.servings_on_hand
    pi.increment!(4.0)
    assert_equal before + 4.0, pi.reload.servings_on_hand
  end

  test "increment! sets last_restocked_at to today" do
    pi = pantry_items(:eggs_pantry)
    pi.increment!
    assert_equal Date.current, pi.reload.last_restocked_at
  end

  # ── decrement! ───────────────────────────────────────────────
  test "decrement! with no args removes 1 serving" do
    pi = pantry_items(:eggs_pantry)
    before = pi.servings_on_hand
    pi.decrement!
    assert_equal before - 1.0, pi.reload.servings_on_hand
  end

  test "decrement! with amount removes that amount" do
    pi = pantry_items(:eggs_pantry)
    before = pi.servings_on_hand
    pi.decrement!(3.0)
    assert_equal before - 3.0, pi.reload.servings_on_hand
  end

  test "decrement! does not go below zero" do
    pi = pantry_items(:eggs_pantry)
    pi.decrement!(999)
    assert_equal 0, pi.reload.servings_on_hand
  end

  # ── add_unit! ────────────────────────────────────────────────
  test "add_unit! adds unit_servings times servings_per_unit" do
    pi = pantry_items(:bread_pantry)  # unit_servings: 20.0, servings_per_unit: 1.0
    pi.add_unit!
    assert_equal 20.0, pi.reload.servings_on_hand
  end

  test "add_unit! sets last_restocked_at to today" do
    pi = pantry_items(:bread_pantry)
    pi.add_unit!
    assert_equal Date.current, pi.reload.last_restocked_at
  end

  # ── needs_restock scope ──────────────────────────────────
  test "needs_restock includes out of stock items" do
    pantry_items(:bread_pantry).update!(servings_on_hand: 0)
    assert_includes PantryItem.needs_restock, pantry_items(:bread_pantry)
  end

  test "needs_restock includes low stock items" do
    pantry_items(:eggs_pantry).update!(servings_on_hand: 1.0)  # below min_servings of 2
    assert_includes PantryItem.needs_restock, pantry_items(:eggs_pantry)
  end

  test "needs_restock excludes in stock items" do
    assert_not_includes PantryItem.needs_restock, pantry_items(:eggs_pantry)  # 6 > min 2
  end

  # ── set_servings! ────────────────────────────────────────────
  test "set_servings! sets servings_on_hand to given amount" do
    pi = pantry_items(:eggs_pantry)
    pi.set_servings!(10)
    assert_equal 10.0, pi.reload.servings_on_hand
  end

  test "set_servings! does not go below zero" do
    pi = pantry_items(:eggs_pantry)
    pi.set_servings!(-5)
    assert_equal 0, pi.reload.servings_on_hand
  end

  test "set_servings! sets last_restocked_at to today" do
    pi = pantry_items(:eggs_pantry)
    pi.set_servings!(3)
    assert_equal Date.current, pi.reload.last_restocked_at
  end
end

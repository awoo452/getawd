require "test_helper"

class PreparedDishTest < ActiveSupport::TestCase
  test "valid with required fields" do
    dish = PreparedDish.new(name: "Eggs", servings_remaining: 2, cooked_on: Date.today)
    assert dish.valid?
  end

  test "invalid without name" do
    dish = PreparedDish.new(servings_remaining: 1, cooked_on: Date.today)
    assert_not dish.valid?
  end

  test "invalid without cooked_on" do
    dish = PreparedDish.new(name: "Eggs", servings_remaining: 1)
    assert_not dish.valid?
  end

  test "invalid with negative servings" do
    dish = PreparedDish.new(name: "Eggs", servings_remaining: -1, cooked_on: Date.today)
    assert_not dish.valid?
  end

  test "active scope excludes zero-serving dishes" do
    assert_includes PreparedDish.active, prepared_dishes(:scrambled_eggs_batch)
    assert_not_includes PreparedDish.active, prepared_dishes(:empty_dish)
  end

  test "consume_one! decrements servings_remaining" do
    dish = prepared_dishes(:scrambled_eggs_batch)
    before = dish.servings_remaining
    dish.consume_one!
    assert_equal before - 1, dish.reload.servings_remaining
  end

  test "consume_one! does not go below zero" do
    dish = prepared_dishes(:empty_dish)
    dish.consume_one!
    assert_equal 0, dish.reload.servings_remaining
  end
end

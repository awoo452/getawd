require "test_helper"

class EatLogTest < ActiveSupport::TestCase
  test "valid with prepared_dish" do
    log = EatLog.new(date: Date.today, meal_slot: "breakfast", prepared_dish: prepared_dishes(:scrambled_eggs_batch))
    assert log.valid?
  end

  test "valid with description only" do
    log = EatLog.new(date: Date.today, meal_slot: "lunch", description: "Sandwich")
    assert log.valid?
  end

  test "invalid without date" do
    log = EatLog.new(meal_slot: "breakfast", description: "Eggs")
    assert_not log.valid?
  end

  test "invalid with bad meal_slot" do
    log = EatLog.new(date: Date.today, meal_slot: "brunch", description: "Eggs")
    assert_not log.valid?
  end

  test "invalid without dish or description" do
    log = EatLog.new(date: Date.today, meal_slot: "dinner")
    assert_not log.valid?
    assert_includes log.errors[:base], "must have a dish or description"
  end

  test "display_name returns dish name when linked" do
    log = eat_logs(:linked)
    assert_equal log.prepared_dish.name, log.display_name
  end

  test "display_name returns description when no dish" do
    log = eat_logs(:free_text)
    assert_equal "Leftover pasta", log.display_name
  end

  test "for_week scope returns logs in range" do
    week = Date.new(2026, 6, 7).beginning_of_week(:sunday)
    results = EatLog.for_week(week)
    assert results.any?
    results.each { |l| assert l.date >= week && l.date <= week + 6.days }
  end
end

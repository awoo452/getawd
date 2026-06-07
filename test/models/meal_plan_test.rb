require "test_helper"

class MealPlanTest < ActiveSupport::TestCase
  def setup
    @recipe    = recipes(:breakfast_recipe)
    @alt       = recipes(:lunch_recipe)
    @breakfast = goals(:breakfast_goal)
  end

  # ── Validations ─────────────────────────────────────────

  test "valid with recipe, date, and slot" do
    mp = MealPlan.new(planned_on: Date.new(2026, 7, 1), meal_slot: :breakfast, recipe: @recipe)
    assert mp.valid?
  end

  test "invalid without planned_on" do
    mp = MealPlan.new(meal_slot: :breakfast, recipe: @recipe)
    assert mp.invalid?
    assert_includes mp.errors[:planned_on], "can't be blank"
  end

  test "invalid without meal_slot" do
    mp = MealPlan.new(planned_on: Date.new(2026, 7, 1), recipe: @recipe)
    assert mp.invalid?
  end

  test "duplicate date and slot is invalid" do
    MealPlan.create!(planned_on: Date.new(2026, 7, 1), meal_slot: :breakfast, recipe: @recipe)
    dup = MealPlan.new(planned_on: Date.new(2026, 7, 1), meal_slot: :breakfast, recipe: @recipe)
    assert dup.invalid?
    assert_includes dup.errors[:planned_on], "has already been taken"
  end

  test "same date different slot is valid" do
    MealPlan.create!(planned_on: Date.new(2026, 7, 1), meal_slot: :breakfast, recipe: @recipe)
    mp = MealPlan.new(planned_on: Date.new(2026, 7, 1), meal_slot: :lunch, recipe: @alt)
    assert mp.valid?
  end

  # ── Task generation on create ────────────────────────────

  test "creates a task on save" do
    assert_difference "Task.count", 1 do
      MealPlan.create!(planned_on: Date.new(2026, 7, 2), meal_slot: :breakfast, recipe: @recipe)
    end
  end

  test "generated task has correct name" do
    mp = MealPlan.create!(planned_on: Date.new(2026, 7, 2), meal_slot: :breakfast, recipe: @recipe)
    assert_equal "Breakfast — Scrambled Eggs", mp.task.task_name
  end

  test "generated task has correct due_date" do
    date = Date.new(2026, 7, 2)
    mp   = MealPlan.create!(planned_on: date, meal_slot: :dinner, recipe: recipes(:dinner_recipe))
    assert_equal date, mp.task.due_date
  end

  test "generated task links to matching goal" do
    mp = MealPlan.create!(planned_on: Date.new(2026, 7, 2), meal_slot: :breakfast, recipe: @recipe)
    assert_equal @breakfast, mp.task.goal
  end

  test "generated task is not_started" do
    mp = MealPlan.create!(planned_on: Date.new(2026, 7, 2), meal_slot: :lunch, recipe: @alt)
    assert mp.task.not_started?
  end

  # ── Task sync on recipe change ───────────────────────────

  test "updating recipe syncs task name" do
    mp = MealPlan.create!(planned_on: Date.new(2026, 7, 3), meal_slot: :breakfast, recipe: @recipe)
    mp.update!(recipe: @alt)
    assert_equal "Breakfast — Turkey Sandwich", mp.task.reload.task_name
  end

  test "updating date does not duplicate tasks" do
    mp = MealPlan.create!(planned_on: Date.new(2026, 7, 3), meal_slot: :breakfast, recipe: @recipe)
    assert_no_difference "Task.count" do
      mp.update!(recipe: @recipe)
    end
  end

  # ── Task removal on destroy ──────────────────────────────

  test "destroying meal plan destroys its task" do
    mp = MealPlan.create!(planned_on: Date.new(2026, 7, 4), meal_slot: :dinner, recipe: recipes(:dinner_recipe))
    task_id = mp.task_id
    assert_difference "Task.count", -1 do
      mp.destroy
    end
    assert_nil Task.find_by(id: task_id)
  end

  test "destroying meal plan with no task is safe" do
    mp = meal_plans(:one)
    assert_nil mp.task_id
    assert_nothing_raised { mp.destroy }
  end
end

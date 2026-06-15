require "test_helper"

class MealPlanTest < ActiveSupport::TestCase
  def setup
    @recipe    = recipes(:breakfast_recipe)
    @alt       = recipes(:lunch_recipe)
    @breakfast = goals(:breakfast_goal)
  end

  def create_mp(date:, slot:, recipe: nil)
    mp = MealPlan.create!(planned_on: date, meal_slot: slot)
    mp.meal_plan_recipes.create!(recipe: recipe) if recipe
    mp.reload
  end

  # ── Validations ─────────────────────────────────────────

  test "valid with date and slot" do
    mp = MealPlan.new(planned_on: Date.new(2026, 7, 1), meal_slot: :breakfast)
    assert mp.valid?
  end

  test "invalid without planned_on" do
    mp = MealPlan.new(meal_slot: :breakfast)
    assert mp.invalid?
    assert_includes mp.errors[:planned_on], "can't be blank"
  end

  test "invalid without meal_slot" do
    mp = MealPlan.new(planned_on: Date.new(2026, 7, 1))
    assert mp.invalid?
  end

  test "duplicate date and slot is invalid" do
    create_mp(date: Date.new(2026, 7, 1), slot: :breakfast, recipe: @recipe)
    dup = MealPlan.new(planned_on: Date.new(2026, 7, 1), meal_slot: :breakfast)
    assert dup.invalid?
    assert_includes dup.errors[:planned_on], "has already been taken"
  end

  test "same date different slot is valid" do
    create_mp(date: Date.new(2026, 7, 1), slot: :breakfast, recipe: @recipe)
    mp = MealPlan.new(planned_on: Date.new(2026, 7, 1), meal_slot: :lunch)
    assert mp.valid?
  end

  # ── Task generation on create ────────────────────────────

  test "creates a task on save" do
    assert_difference "Task.count", 1 do
      MealPlan.create!(planned_on: Date.new(2026, 7, 2), meal_slot: :breakfast)
    end
  end

  test "generated task has correct name after adding recipe" do
    mp = create_mp(date: Date.new(2026, 7, 2), slot: :breakfast, recipe: @recipe)
    assert_equal "Breakfast — Scrambled Eggs", mp.task.reload.task_name
  end

  test "generated task has correct due_date" do
    date = Date.new(2026, 7, 2)
    mp   = create_mp(date: date, slot: :dinner, recipe: recipes(:dinner_recipe))
    assert_equal date, mp.task.due_date
  end

  test "generated task links to matching goal" do
    mp = create_mp(date: Date.new(2026, 7, 2), slot: :breakfast, recipe: @recipe)
    assert_equal @breakfast, mp.task.goal
  end

  test "generated task is not_started" do
    mp = create_mp(date: Date.new(2026, 7, 2), slot: :lunch, recipe: @alt)
    assert mp.task.not_started?
  end

  # ── Task sync on recipe change ───────────────────────────

  test "swapping recipe syncs task name" do
    mp = create_mp(date: Date.new(2026, 7, 3), slot: :breakfast, recipe: @recipe)
    mp.meal_plan_recipes.destroy_all
    mp.meal_plan_recipes.create!(recipe: @alt)
    assert_equal "Breakfast — Turkey Sandwich", mp.task.reload.task_name
  end

  test "adding a recipe does not duplicate tasks" do
    mp = MealPlan.create!(planned_on: Date.new(2026, 7, 3), meal_slot: :breakfast)
    assert_no_difference "Task.count" do
      mp.meal_plan_recipes.create!(recipe: @recipe)
    end
  end

  # ── Inventory deduction / restoration ───────────────────

  test "deduct_inventory! reduces servings_on_hand for recipe ingredients and items" do
    mp = meal_plans(:one)
    mp.deduct_inventory!
    assert_equal 3.0, food_items(:eggs).pantry_item.reload.servings_on_hand  # 6 - 3 (recipe)
    assert_equal 8.0, food_items(:bacon).pantry_item.reload.servings_on_hand # 11 - 2 (recipe) - 1 (item)
  end

  test "restore_inventory! adds back servings_on_hand" do
    mp = meal_plans(:one)
    mp.deduct_inventory!
    mp.restore_inventory!
    assert_equal 6.0,  food_items(:eggs).pantry_item.reload.servings_on_hand
    assert_equal 11.0, food_items(:bacon).pantry_item.reload.servings_on_hand
  end

  test "deduct_inventory! with no recipe only deducts items" do
    mp = meal_plans(:one)
    mp.meal_plan_recipes.destroy_all
    mp.deduct_inventory!
    assert_equal 6.0,  food_items(:eggs).pantry_item.reload.servings_on_hand  # untouched
    assert_equal 10.0, food_items(:bacon).pantry_item.reload.servings_on_hand # 11 - 1 (item only)
  end

  # ── Cooked → task completion sync ───────────────────────

  test "marking cooked completes the associated task" do
    mp = create_mp(date: Date.new(2026, 8, 1), slot: :dinner, recipe: recipes(:dinner_recipe))
    mp.update!(cooked: true)
    assert_equal "completed", mp.task.reload.status
    assert_equal mp.planned_on, mp.task.reload.completion_date
  end

  test "marking uncooked reverts task to not_started" do
    mp = create_mp(date: Date.new(2026, 8, 2), slot: :lunch, recipe: recipes(:lunch_recipe))
    mp.update!(cooked: true)
    mp.update!(cooked: false)
    assert_equal "not_started", mp.task.reload.status
    assert_nil mp.task.reload.completion_date
  end

  test "cooked sync does nothing when meal plan has no task" do
    mp = meal_plans(:one)
    assert_nil mp.task_id
    assert_nothing_raised { mp.update!(cooked: true) }
  end

  # ── Snack / dessert slot behavior ───────────────────────────

  test "morning_snack slot does not generate a task" do
    assert_no_difference "Task.count" do
      MealPlan.create!(planned_on: Date.new(2026, 7, 5), meal_slot: :morning_snack)
    end
  end

  test "afternoon_snack slot does not generate a task" do
    assert_no_difference "Task.count" do
      MealPlan.create!(planned_on: Date.new(2026, 7, 5), meal_slot: :afternoon_snack)
    end
  end

  test "bedtime_snack slot does not generate a task" do
    assert_no_difference "Task.count" do
      MealPlan.create!(planned_on: Date.new(2026, 7, 5), meal_slot: :bedtime_snack)
    end
  end

  test "dessert slot does not generate a task" do
    assert_no_difference "Task.count" do
      MealPlan.create!(planned_on: Date.new(2026, 7, 5), meal_slot: :dessert)
    end
  end

  test "SLOT_LABELS covers every slot in SLOTS" do
    MealPlan::SLOTS.each do |slot|
      assert MealPlan::SLOT_LABELS.key?(slot), "SLOT_LABELS missing '#{slot}'"
    end
  end

  test "cooked snack slot with custom items uses SLOT_LABELS in prepared dish name" do
    mp = MealPlan.create!(planned_on: Date.new(2026, 7, 5), meal_slot: :morning_snack)
    mp.meal_plan_items.create!(food_item: food_items(:eggs), quantity: 1)
    mp.update!(cooked: true)
    dish = PreparedDish.find_by(meal_plan_id: mp.id)
    assert_equal "Morning Snack — Custom Items", dish.name
  end

  # ── Task removal on destroy ──────────────────────────────

  test "destroying meal plan destroys its task" do
    mp = create_mp(date: Date.new(2026, 7, 4), slot: :dinner, recipe: recipes(:dinner_recipe))
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

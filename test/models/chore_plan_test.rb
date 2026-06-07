require "test_helper"

class ChorePlanTest < ActiveSupport::TestCase
  # ── Validations ─────────────────────────────────────────

  test "valid with date and chore type" do
    cp = ChorePlan.new(planned_on: Date.new(2026, 7, 1), chore_type: :sweep_mop)
    assert cp.valid?
  end

  test "invalid without planned_on" do
    cp = ChorePlan.new(chore_type: :sweep_mop)
    assert cp.invalid?
  end

  test "same chore type on same day is invalid" do
    ChorePlan.create!(planned_on: Date.new(2026, 7, 1), chore_type: :sweep_mop)
    dup = ChorePlan.new(planned_on: Date.new(2026, 7, 1), chore_type: :sweep_mop)
    assert dup.invalid?
  end

  test "different chore types on same day are valid" do
    ChorePlan.create!(planned_on: Date.new(2026, 7, 1), chore_type: :sweep_mop)
    cp = ChorePlan.new(planned_on: Date.new(2026, 7, 1), chore_type: :laundry)
    assert cp.valid?
  end

  # ── Task generation ──────────────────────────────────────

  test "creates a task on save" do
    assert_difference "Task.count", 1 do
      ChorePlan.create!(planned_on: Date.new(2026, 7, 2), chore_type: :bathroom)
    end
  end

  test "generated task has correct name" do
    cp = ChorePlan.create!(planned_on: Date.new(2026, 7, 2), chore_type: :sweep_mop)
    assert_equal "Chores — Sweep & Mop", cp.task.task_name
  end

  test "generated task has correct due_date" do
    date = Date.new(2026, 7, 3)
    cp   = ChorePlan.create!(planned_on: date, chore_type: :vacuum)
    assert_equal date, cp.task.due_date
  end

  test "generated task links to chores goal" do
    cp = ChorePlan.create!(planned_on: Date.new(2026, 7, 4), chore_type: :laundry)
    assert_equal goals(:chores_goal), cp.task.goal
  end

  # ── Task removal on destroy ──────────────────────────────

  test "destroying chore plan destroys its task" do
    cp = ChorePlan.create!(planned_on: Date.new(2026, 7, 5), chore_type: :rooms)
    assert_difference "Task.count", -1 do
      cp.destroy
    end
  end

  test "destroying fixture chore plan with no task is safe" do
    cp = chore_plans(:one)
    assert_nil cp.task_id
    assert_nothing_raised { cp.destroy }
  end

  # ── Helper methods ───────────────────────────────────────

  test "label returns display name" do
    cp = ChorePlan.new(chore_type: :sweep_mop)
    assert_equal "Sweep & Mop", cp.label
  end

  test "emoji returns correct emoji" do
    cp = ChorePlan.new(chore_type: :laundry)
    assert_equal "👕", cp.emoji
  end
end

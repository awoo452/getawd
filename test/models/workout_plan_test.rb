require "test_helper"

class WorkoutPlanTest < ActiveSupport::TestCase
  # ── Validations ─────────────────────────────────────────

  test "valid with date and workout type" do
    wp = WorkoutPlan.new(planned_on: Date.new(2026, 7, 1), workout_type: :walk)
    assert wp.valid?
  end

  test "invalid without planned_on" do
    wp = WorkoutPlan.new(workout_type: :walk)
    assert wp.invalid?
  end

  test "invalid without workout_type" do
    wp = WorkoutPlan.new(planned_on: Date.new(2026, 7, 1))
    assert wp.invalid?
  end

  test "duplicate date is invalid" do
    WorkoutPlan.create!(planned_on: Date.new(2026, 7, 1), workout_type: :walk)
    dup = WorkoutPlan.new(planned_on: Date.new(2026, 7, 1), workout_type: :rest)
    assert dup.invalid?
    assert_includes dup.errors[:planned_on], "has already been taken"
  end

  # ── Task generation on create ────────────────────────────

  test "creates a task on save" do
    assert_difference "Task.count", 1 do
      WorkoutPlan.create!(planned_on: Date.new(2026, 7, 2), workout_type: :walk)
    end
  end

  test "walk generates correct task name" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 7, 2), workout_type: :walk)
    assert_equal "Cardio — Dog Walk", wp.task.task_name
  end

  test "vr generates correct task name" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 7, 3), workout_type: :vr)
    assert_equal "Cardio — VR Workout", wp.task.task_name
  end

  test "board_push generates correct task name" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 7, 4), workout_type: :board_push)
    assert_equal "Strength — Chest & Triceps", wp.task.task_name
  end

  test "board_pull generates correct task name" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 7, 5), workout_type: :board_pull)
    assert_equal "Strength — Shoulders & Back", wp.task.task_name
  end

  test "rest generates correct task name" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 7, 6), workout_type: :rest)
    assert_equal "Rest Day", wp.task.task_name
  end

  test "generated task has correct due_date" do
    date = Date.new(2026, 7, 7)
    wp   = WorkoutPlan.create!(planned_on: date, workout_type: :vr)
    assert_equal date, wp.task.due_date
  end

  test "walk and vr link to cardio fitness goal" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 7, 8), workout_type: :walk)
    assert_equal goals(:cardio_goal), wp.task.goal
  end

  test "board workouts link to strength training goal" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 7, 9), workout_type: :board_push)
    assert_equal goals(:strength_goal), wp.task.goal
  end

  test "rest has no goal" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 7, 10), workout_type: :rest)
    assert_nil wp.task.goal
  end

  # ── Task sync on type change ─────────────────────────────

  test "updating workout type syncs task name" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 7, 11), workout_type: :walk)
    wp.update!(workout_type: :board_push)
    assert_equal "Strength — Chest & Triceps", wp.task.reload.task_name
  end

  # ── Task removal on destroy ──────────────────────────────

  test "destroying workout plan destroys its task" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 7, 12), workout_type: :vr)
    assert_difference "Task.count", -1 do
      wp.destroy
    end
  end

  test "destroying fixture workout plan with no task is safe" do
    wp = workout_plans(:one)
    assert_nil wp.task_id
    assert_nothing_raised { wp.destroy }
  end

  # ── Helper methods ───────────────────────────────────────

  test "label returns display name" do
    wp = WorkoutPlan.new(workout_type: :vr)
    assert_equal "VR Workout", wp.label
  end

  test "emoji returns correct emoji" do
    wp = WorkoutPlan.new(workout_type: :board_push)
    assert_equal "💪", wp.emoji
  end
end

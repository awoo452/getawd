require "test_helper"

class WorkoutPlansControllerTest < ActionDispatch::IntegrationTest
  # ── create ───────────────────────────────────────────────

  test "create makes a workout plan and redirects to workouts" do
    assert_difference "WorkoutPlan.count", 1 do
      post workout_plans_url, params: {
        workout_plan: { planned_on: "2026-07-20", workout_type: "walk" }
      }
    end
    assert_redirected_to workouts_url
  end

  test "create generates a calendar task" do
    assert_difference "Task.count", 1 do
      post workout_plans_url, params: {
        workout_plan: { planned_on: Time.zone.today.to_s, workout_type: "vr" }
      }
    end
  end

  test "create with duplicate date redirects with alert" do
    WorkoutPlan.create!(planned_on: Date.new(2026, 7, 21), workout_type: :walk)
    assert_no_difference "WorkoutPlan.count" do
      post workout_plans_url, params: {
        workout_plan: { planned_on: "2026-07-21", workout_type: "rest" }
      }
    end
    assert_redirected_to workouts_url
    assert flash[:alert].present?
  end

  # ── destroy ──────────────────────────────────────────────

  test "destroy removes the workout plan and redirects to workouts" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 8, 1), workout_type: :walk)
    assert_difference "WorkoutPlan.count", -1 do
      delete workout_plan_url(wp)
    end
    assert_redirected_to workouts_url
  end

  test "destroy removes the generated task" do
    wp = WorkoutPlan.create!(planned_on: Time.zone.today, workout_type: :board_push)
    assert_difference "Task.count", -1 do
      delete workout_plan_url(wp)
    end
  end

  # ── update ───────────────────────────────────────────────

  test "update changes the workout type and syncs task name" do
    wp = WorkoutPlan.create!(planned_on: Time.zone.today, workout_type: :walk)
    patch workout_plan_url(wp), params: {
      workout_plan: { workout_type: "vr" }
    }
    assert_equal "Cardio — VR Workout", wp.task.reload.task_name
  end

  test "update saves notes" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 8, 4), workout_type: :board_push)
    patch workout_plan_url(wp), params: {
      workout_plan: { notes: "3x10 push-ups, 2x12 tricep dips" }
    }
    assert_equal "3x10 push-ups, 2x12 tricep dips", wp.reload.notes
  end

  # ── toggle_complete ──────────────────────────────────────

  test "toggle_complete marks workout as completed" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 8, 5), workout_type: :walk)
    patch toggle_complete_workout_plan_url(wp)
    assert wp.reload.completed?
  end

  test "toggle_complete unmarks a completed workout" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 8, 6), workout_type: :vr)
    wp.update_column(:completed, true)
    patch toggle_complete_workout_plan_url(wp)
    assert_not wp.reload.completed?
  end
end

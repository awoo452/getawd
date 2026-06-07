require "test_helper"

class WorkoutPlansControllerTest < ActionDispatch::IntegrationTest
  # ── create ───────────────────────────────────────────────

  test "create makes a workout plan and redirects to workouts" do
    assert_difference "WorkoutPlan.count", 1 do
      post workout_plans_url, params: {
        workout_plan: { planned_on: "2026-07-20", workout_type: "run" }
      }
    end
    assert_redirected_to workouts_url
  end

  test "create generates a calendar task" do
    assert_difference "Task.count", 1 do
      post workout_plans_url, params: {
        workout_plan: { planned_on: "2026-07-20", workout_type: "body_combat" }
      }
    end
  end

  test "create with duplicate date redirects with alert" do
    WorkoutPlan.create!(planned_on: Date.new(2026, 7, 21), workout_type: :run)
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
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 8, 1), workout_type: :run)
    assert_difference "WorkoutPlan.count", -1 do
      delete workout_plan_url(wp)
    end
    assert_redirected_to workouts_url
  end

  test "destroy removes the generated task" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 8, 2), workout_type: :pushups)
    assert_difference "Task.count", -1 do
      delete workout_plan_url(wp)
    end
  end

  # ── update ───────────────────────────────────────────────

  test "update changes the workout type and syncs task name" do
    wp = WorkoutPlan.create!(planned_on: Date.new(2026, 8, 3), workout_type: :run)
    patch workout_plan_url(wp), params: {
      workout_plan: { workout_type: "body_combat" }
    }
    assert_redirected_to workouts_url
    assert_equal "Cardio — Body Combat", wp.task.reload.task_name
  end
end

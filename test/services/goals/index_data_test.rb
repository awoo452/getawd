require "test_helper"

class Goals::IndexDataTest < ActiveSupport::TestCase
  def call(params = {})
    Goals::IndexData.call(params: ActionController::Parameters.new(params))
  end

  test "returns goals grouped by status" do
    result = call
    assert_includes result.goals_by_status.keys, :in_progress
    assert_includes result.goals_by_status.keys, :not_started
    assert_includes result.goals_by_status.keys, :on_hold
    assert_includes result.goals_by_status.keys, :completed
  end

  test "returns no errors with no params" do
    assert_empty call.errors
  end

  # ── status filter ────────────────────────────────────────
  test "filters by valid status" do
    goal = Goal.create!(title: "In progress goal", status: :in_progress, priority: 1,
                        due_date: Date.current, idea: ideas(:one))
    result = call(status: "in_progress")
    assert_includes result.goals_by_status[:in_progress], goal
    assert_not_includes result.goals_by_status[:not_started], goal
  end

  test "records error on invalid status" do
    result = call(status: "bogus")
    assert_includes result.errors, "status is invalid (bogus)"
  end

  # ── due filter ───────────────────────────────────────────
  test "filters by due date" do
    target = Date.new(2026, 3, 1)
    goal = Goal.create!(title: "Due goal", status: :not_started, priority: 1,
                        due_date: target, idea: ideas(:one))
    result = call(due: "2026-03-01")
    all_goals = result.goals_by_status.values.flatten
    assert_includes all_goals, goal
  end

  test "records error on invalid due date" do
    result = call(due: "not-a-date")
    assert_includes result.errors, "due is invalid (not-a-date)"
  end

  # ── search filter ────────────────────────────────────────
  test "filters by search term" do
    goal = Goal.create!(title: "GoalUniqueSearch", status: :not_started, priority: 1,
                        due_date: Date.current, idea: ideas(:one))
    result = call(search: "GoalUniqueSearch")
    all_goals = result.goals_by_status.values.flatten
    assert_includes all_goals, goal
  end

  test "search is case insensitive" do
    goal = Goal.create!(title: "GoalCaseTest", status: :not_started, priority: 1,
                        due_date: Date.current, idea: ideas(:one))
    result = call(search: "goalcasetest")
    all_goals = result.goals_by_status.values.flatten
    assert_includes all_goals, goal
  end
end

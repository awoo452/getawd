require "test_helper"

class Tasks::IndexDataTest < ActiveSupport::TestCase
  def call(params = {})
    Tasks::IndexData.call(params: ActionController::Parameters.new(params))
  end

  test "returns tasks grouped by status" do
    result = call
    assert_respond_to result, :tasks_by_status
    assert_includes result.tasks_by_status.keys, :in_progress
    assert_includes result.tasks_by_status.keys, :not_started
    assert_includes result.tasks_by_status.keys, :on_hold
    assert_includes result.tasks_by_status.keys, :completed
  end

  test "returns no errors with no params" do
    assert_empty call.errors
  end

  # ── status filter ────────────────────────────────────────
  test "filters by valid status" do
    task = Task.create!(task_name: "Filter me", status: :in_progress, priority: 1,
                        due_date: Date.current, start_date: Date.current,
                        estimated_time: 5, actual_time: 0)
    result = call(status: "in_progress")
    assert_includes result.tasks_by_status[:in_progress], task
    assert_not_includes result.tasks_by_status[:not_started], task
  end

  test "records error and returns all tasks on invalid status" do
    result = call(status: "bogus")
    assert_includes result.errors, "status is invalid (bogus)"
  end

  # ── due filter ───────────────────────────────────────────
  test "filters by due date" do
    target_date = Date.new(2026, 1, 15)
    task = Task.create!(task_name: "Due task", status: :not_started, priority: 1,
                        due_date: target_date, start_date: target_date,
                        estimated_time: 5, actual_time: 0)
    result = call(due: "2026-01-15")
    all_tasks = result.tasks_by_status.values.flatten
    assert_includes all_tasks, task
  end

  test "records error on invalid due date" do
    result = call(due: "not-a-date")
    assert_includes result.errors, "due is invalid (not-a-date)"
  end

  # ── goal filter ──────────────────────────────────────────
  test "filters by goal_id" do
    goal = goals(:one)
    task = Task.create!(task_name: "Goal task", status: :not_started, priority: 1,
                        goal: goal, due_date: Date.current, start_date: Date.current,
                        estimated_time: 5, actual_time: 0)
    result = call(goal_id: goal.id.to_s)
    all_tasks = result.tasks_by_status.values.flatten
    assert_includes all_tasks, task
  end

  test "records error on invalid goal_id" do
    result = call(goal_id: "abc")
    assert_includes result.errors, "goal_id is invalid (abc)"
  end

  # ── search filter ────────────────────────────────────────
  test "filters by search term" do
    task = Task.create!(task_name: "UniqueSearchTerm", status: :not_started, priority: 1,
                        due_date: Date.current, start_date: Date.current,
                        estimated_time: 5, actual_time: 0)
    result = call(search: "UniqueSearchTerm")
    all_tasks = result.tasks_by_status.values.flatten
    assert_includes all_tasks, task
  end

  test "search is case insensitive" do
    task = Task.create!(task_name: "CaseSensTest", status: :not_started, priority: 1,
                        due_date: Date.current, start_date: Date.current,
                        estimated_time: 5, actual_time: 0)
    result = call(search: "casesenstest")
    all_tasks = result.tasks_by_status.values.flatten
    assert_includes all_tasks, task
  end

  # ── sort filter ──────────────────────────────────────────
  test "accepts valid sort column" do
    result = call(sort: "due_date")
    assert_empty result.errors
  end

  test "records error on invalid sort column" do
    result = call(sort: "DROP TABLE tasks")
    assert_includes result.errors, "sort is invalid (DROP TABLE tasks)"
  end
end

require "test_helper"

class Dashboard::IndexDataTest < ActiveSupport::TestCase
  PAGINATOR = ->(scope, per_page:) { [scope.to_a, 1, 1] }

  def call
    Dashboard::IndexData.call(paginator: PAGINATOR)
  end

  def make_task(goal:, status: :not_started, completion_date: nil, due_date: Date.current)
    Task.create!(
      task_name:       "Test task",
      status:          status,
      priority:        1,
      due_date:        due_date,
      start_date:      due_date,
      estimated_time:  10,
      actual_time:     0,
      goal:            goal,
      completion_date: completion_date
    )
  end

  # ── smoke ─────────────────────────────────────────────────
  test "returns without error" do
    assert_nothing_raised { call }
  end

  test "goal_counts and task_counts have all four status keys" do
    result = call
    %i[not_started in_progress on_hold completed].each do |status|
      assert_includes result.goal_counts.keys, status
      assert_includes result.task_counts.keys, status
    end
  end

  test "time_remaining is estimated minus actual" do
    result = call
    assert_equal result.total_estimated_minutes_today - result.total_actual_minutes_today,
                 result.time_remaining_minutes_today
  end

  # ── idea color coding ────────────────────────────────────
  test "idea color is gray when it has no completed tasks" do
    idea = ideas(:one)
    goal = idea.goals.create!(title: "No tasks goal", priority: 1,
                               due_date: Date.current, status: :not_started)
    make_task(goal: goal)
    result = call
    entry = result.ideas.find { |i| i[:id] == idea.id }
    assert_equal "gray", entry[:color]
  end

  test "idea color is green when most recent completion was today" do
    idea = ideas(:one)
    goal = idea.goals.create!(title: "Fresh goal", priority: 1,
                               due_date: Date.current, status: :not_started)
    make_task(goal: goal, status: :completed, completion_date: Date.current)
    result = call
    entry = result.ideas.find { |i| i[:id] == idea.id }
    assert_equal "green", entry[:color]
  end

  test "idea color is yellow when most recent completion was 1 day ago" do
    idea = ideas(:one)
    goal = idea.goals.create!(title: "Recent goal", priority: 1,
                               due_date: Date.current, status: :not_started)
    make_task(goal: goal, status: :completed, completion_date: 1.day.ago.to_date)
    result = call
    entry = result.ideas.find { |i| i[:id] == idea.id }
    assert_equal "yellow", entry[:color]
  end

  test "idea color is red when most recent completion was 4 days ago" do
    idea = ideas(:one)
    goal = idea.goals.create!(title: "Stale goal", priority: 1,
                               due_date: Date.current, status: :not_started)
    make_task(goal: goal, status: :completed, completion_date: 4.days.ago.to_date)
    result = call
    entry = result.ideas.find { |i| i[:id] == idea.id }
    assert_equal "red", entry[:color]
  end

  test "idea color is black when most recent completion was 7 or more days ago" do
    idea = ideas(:one)
    goal = idea.goals.create!(title: "Dead goal", priority: 1,
                               due_date: Date.current, status: :not_started)
    make_task(goal: goal, status: :completed, completion_date: 7.days.ago.to_date)
    result = call
    entry = result.ideas.find { |i| i[:id] == idea.id }
    assert_equal "black", entry[:color]
  end

  # ── time calculations ────────────────────────────────────
  test "total_estimated_minutes_today sums estimated_time for incomplete tasks due today" do
    due = Date.current
    task = Task.create!(task_name: "Timed task", status: :not_started, priority: 1,
                        due_date: due, start_date: due, estimated_time: 45, actual_time: 10)
    result = call
    assert result.total_estimated_minutes_today >= 45
    assert result.total_actual_minutes_today >= 10
  end

  test "total_estimated_minutes_today excludes completed tasks" do
    due = Date.current
    Task.create!(task_name: "Done task", status: :completed, priority: 1,
                 due_date: due, start_date: due, completion_date: due,
                 estimated_time: 999, actual_time: 999)
    result = call
    assert result.total_estimated_minutes_today < 999
  end

  # ── due today counts ─────────────────────────────────────
  test "due_today_tasks_not_started counts not-started tasks due today" do
    due = Date.current
    Task.create!(task_name: "Due today", status: :not_started, priority: 1,
                 due_date: due, start_date: due, estimated_time: 5, actual_time: 0)
    assert call.due_today_tasks_not_started >= 1
  end
end

require "test_helper"

class Dashboard::IndexDataTest < ActiveSupport::TestCase
  PAGINATOR = ->(scope, per_page:) { [scope.to_a, 1, 1] }

  def call
    Dashboard::IndexData.call(paginator: PAGINATOR)
  end

  test "returns without error" do
    assert_nothing_raised { call }
  end

  test "returns task and goal status groups" do
    result = call
    assert_respond_to result, :not_started_tasks
    assert_respond_to result, :in_progress_tasks
    assert_respond_to result, :completed_tasks
    assert_respond_to result, :not_started_goals
    assert_respond_to result, :in_progress_goals
    assert_respond_to result, :completed_goals
  end

  test "goal_counts and task_counts are hashes with status keys" do
    result = call
    %i[not_started in_progress on_hold completed].each do |status|
      assert_includes result.goal_counts.keys, status
      assert_includes result.task_counts.keys, status
    end
  end

  test "time_remaining_minutes_today is estimated minus actual" do
    result = call
    assert_equal result.total_estimated_minutes_today - result.total_actual_minutes_today,
                 result.time_remaining_minutes_today
  end

  test "ideas is an array of hashes with required keys" do
    result = call
    result.ideas.each do |idea|
      %i[id title emoji color goals_count tasks_count].each do |key|
        assert_includes idea.keys, key
      end
    end
  end
end

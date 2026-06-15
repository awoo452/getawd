require "test_helper"

class Reports::IndexDataTest < ActiveSupport::TestCase
  def call
    Reports::IndexData.call
  end

  test "returns without error" do
    assert_nothing_raised { call }
  end

  test "start_date is beginning of current month" do
    assert_equal Time.zone.today.beginning_of_month, call.start_date
  end

  test "end_date is end of current month" do
    assert_equal Time.zone.today.end_of_month, call.end_date
  end

  test "letter_grade is one of the valid grades" do
    assert_includes %w[A B C D F], call.letter_grade
  end

  test "letter_grade is F when no tasks are available" do
    assert_equal "F", call.letter_grade
  end

  test "completion_chain has 6 weekly entries" do
    assert_equal 6, call.completion_chain.size
  end

  test "completion_chain entries have the required keys" do
    entry = call.completion_chain.first
    %i[week_start completed available missed chain_completed].each do |key|
      assert_includes entry.keys, key
    end
  end

  test "completion_chain is in chronological order" do
    chain = call.completion_chain
    assert chain.each_cons(2).all? { |a, b| a[:week_start] < b[:week_start] }
  end

  test "missed_tasks_count reflects overdue incomplete tasks" do
    past = 10.days.ago.to_date
    Task.create!(task_name: "Overdue", status: :not_started, priority: 1,
                 due_date: past, start_date: past, estimated_time: 5, actual_time: 0)
    assert call.missed_tasks_count >= 1
  end

  test "completed_on_time_count reflects tasks completed by due date this month" do
    today = Time.zone.today
    Task.create!(task_name: "On time", status: :completed, priority: 1,
                 due_date: today, start_date: today, completion_date: today,
                 estimated_time: 5, actual_time: 5)
    assert call.completed_on_time_count >= 1
  end

  test "completion_rate is between 0 and 1" do
    rate = call.completion_rate
    assert rate >= 0 && rate <= 1
  end
end

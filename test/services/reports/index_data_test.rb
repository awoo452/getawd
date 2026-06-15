require "test_helper"

class Reports::IndexDataTest < ActiveSupport::TestCase
  def call
    Reports::IndexData.call
  end

  def make_task(due_date:, status: :not_started, completion_date: nil)
    Task.create!(
      task_name:       "Report task",
      status:          status,
      priority:        1,
      due_date:        due_date,
      start_date:      due_date,
      estimated_time:  10,
      actual_time:     5,
      completion_date: completion_date
    )
  end

  # ── date range ───────────────────────────────────────────
  test "start_date is beginning of current month" do
    assert_equal Time.zone.today.beginning_of_month, call.start_date
  end

  test "end_date is end of current month" do
    assert_equal Time.zone.today.end_of_month, call.end_date
  end

  # ── letter grade ─────────────────────────────────────────
  test "letter grade is F with no tasks" do
    assert_equal "F", call.letter_grade
  end

  test "letter grade is A when all tasks in 6-week window are completed on time" do
    6.times do |i|
      date = i.weeks.ago.to_date
      make_task(due_date: date, status: :completed, completion_date: date)
    end
    assert_equal "A", call.letter_grade
  end

  test "letter grade is F when no tasks are completed" do
    6.times do |i|
      make_task(due_date: i.weeks.ago.to_date)
    end
    assert_equal "F", call.letter_grade
  end

  test "completion_rate is 1.0 when all tasks completed" do
    date = 1.week.ago.to_date
    3.times { make_task(due_date: date, status: :completed, completion_date: date) }
    assert_in_delta 1.0, call.completion_rate, 0.01
  end

  test "completion_rate is 0.0 when no tasks completed" do
    assert_equal 0, call.completion_rate
  end

  # ── completed on time vs late ────────────────────────────
  test "completed_on_time_count counts tasks completed by due date this month" do
    today = Time.zone.today
    make_task(due_date: today, status: :completed, completion_date: today)
    assert call.completed_on_time_count >= 1
  end

  test "completed_late_count counts tasks completed after due date this month" do
    yesterday = 1.day.ago.to_date
    make_task(due_date: yesterday, status: :completed, completion_date: Time.zone.today)
    assert call.completed_late_count >= 1
  end

  # ── missed tasks ─────────────────────────────────────────
  test "missed_tasks_count reflects overdue incomplete tasks" do
    make_task(due_date: 5.days.ago.to_date)
    assert call.missed_tasks_count >= 1
  end

  test "missed_minutes_lost sums estimated_time of missed tasks" do
    make_task(due_date: 5.days.ago.to_date)
    assert call.missed_minutes_lost >= 10
  end

  # ── completion chain ─────────────────────────────────────
  test "completion_chain has 6 entries" do
    assert_equal 6, call.completion_chain.size
  end

  test "completion_chain is in chronological order" do
    chain = call.completion_chain
    assert chain.each_cons(2).all? { |a, b| a[:week_start] < b[:week_start] }
  end

  test "chain_completed is true for a week where nothing was missed" do
    start = Time.zone.today.beginning_of_week
    make_task(due_date: start, status: :completed, completion_date: start)
    chain = call.completion_chain
    this_week = chain.find { |w| w[:week_start].to_date == start }
    assert this_week[:chain_completed]
  end

  test "chain_completed is false for a week with missed tasks" do
    start = Time.zone.today.beginning_of_week
    make_task(due_date: start, status: :not_started)
    chain = call.completion_chain
    this_week = chain.find { |w| w[:week_start].to_date == start }
    assert_not this_week[:chain_completed]
  end

  # ── last completion ──────────────────────────────────────
  test "last_completion_date returns the most recent completion date" do
    date = 2.days.ago.to_date
    make_task(due_date: date, status: :completed, completion_date: date)
    assert_equal date, call.last_completion_date
  end

  test "days_since_last_completion is nil when no tasks completed" do
    assert_nil call.days_since_last_completion
  end
end

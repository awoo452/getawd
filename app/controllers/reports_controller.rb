class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @start_date = Time.zone.today.beginning_of_month
    @end_date   = Time.zone.today.end_of_month

    load_completion_stats
    load_missed_tasks
    load_trend_data
  end

  private

  def load_completion_stats
    completed = Task.completed
      .where(completion_date: @start_date..@end_date)

    @completed_on_time = completed.where("completion_date <= due_date")
    @completed_late    = completed.where("completion_date > due_date")

    @completed_on_time_count = @completed_on_time.count
    @completed_late_count    = @completed_late.count

    @last_completion_date = Task.completed.maximum(:completion_date)
    @days_since_last_completion =
      @last_completion_date ? (Time.zone.today - @last_completion_date.to_date).to_i : nil
  end

  def load_missed_tasks
    @missed_tasks = Task
      .where("due_date < ?", Time.zone.today)
      .where.not(status: [:completed, :on_hold])

    @missed_tasks_count   = @missed_tasks.count
    @missed_minutes_lost  = @missed_tasks.sum(:estimated_time)
  end

  def load_trend_data
    @weekly_completions = Task.completed
      .where("completion_date >= ?", 6.weeks.ago)
      .group("DATE_TRUNC('week', completion_date)")
      .count
  end
end

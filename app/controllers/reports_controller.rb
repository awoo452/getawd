class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @start_date = Time.zone.today.beginning_of_month
    @end_date   = Time.zone.today.end_of_month

    load_completion_stats
    load_missed_tasks
    load_trend_data
    load_completion_chain
    load_report_card
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

  def load_completion_chain
    @completion_chain = (0..5).map do |weeks_ago|
      start_date = weeks_ago.weeks.ago.beginning_of_week
      end_date   = weeks_ago.weeks.ago.end_of_week

      available = Task.where(due_date: start_date..end_date)
      completed = Task.completed.where(completion_date: start_date..end_date)

      available_count = available.count
      completed_count = completed.count
      missed_count    = [available_count - completed_count, 0].max

      {
        week_start: start_date,
        completed: completed_count,
        available: available_count,
        missed: missed_count,
        chain_completed: missed_count.zero?
      }
    end.reverse
  end

  def load_report_card
    start_date = 6.weeks.ago.beginning_of_week
    end_date   = Time.zone.today.end_of_week

    available = Task.where(due_date: start_date..end_date)
    completed = Task.completed.where(completion_date: start_date..end_date)

    @report_available_count = available.count
    @report_completed_count = completed.count

    @completion_rate =
      if @report_available_count.zero?
        0
      else
        (@report_completed_count.to_f / @report_available_count)
      end

    @letter_grade = case (@completion_rate * 100).round
                    when 90..100 then "A"
                    when 80..89  then "B"
                    when 70..79  then "C"
                    when 60..69  then "D"
                    else "F"
                    end
  end

end

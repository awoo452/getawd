class ReportsController < ApplicationController
  def index
    data = Reports::IndexData.call

    @start_date = data.start_date
    @end_date = data.end_date
    @completed_on_time = data.completed_on_time
    @completed_late = data.completed_late
    @completed_on_time_count = data.completed_on_time_count
    @completed_late_count = data.completed_late_count
    @last_completion_date = data.last_completion_date
    @days_since_last_completion = data.days_since_last_completion
    @missed_tasks = data.missed_tasks
    @missed_tasks_count = data.missed_tasks_count
    @missed_minutes_lost = data.missed_minutes_lost
    @weekly_completions = data.weekly_completions
    @completion_chain = data.completion_chain
    @report_available_count = data.report_available_count
    @report_completed_count = data.report_completed_count
    @completion_rate = data.completion_rate
    @letter_grade = data.letter_grade
  end

  private
end

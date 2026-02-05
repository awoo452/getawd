module Reports
  class IndexData
    Result = Struct.new(
      :start_date, :end_date,
      :completed_on_time, :completed_late,
      :completed_on_time_count, :completed_late_count,
      :last_completion_date, :days_since_last_completion,
      :missed_tasks, :missed_tasks_count, :missed_minutes_lost,
      :weekly_completions,
      :completion_chain,
      :report_available_count, :report_completed_count,
      :completion_rate, :letter_grade,
      keyword_init: true
    )

    def self.call
      new.call
    end

    def call
      start_date = Time.zone.today.beginning_of_month
      end_date = Time.zone.today.end_of_month

      completed = Task.completed.where(completion_date: start_date..end_date)
      completed_on_time = completed.where("completion_date <= due_date")
      completed_late = completed.where("completion_date > due_date")
      completed_on_time_count = completed_on_time.count
      completed_late_count = completed_late.count

      last_completion_date = Task.completed.maximum(:completion_date)
      days_since_last_completion =
        last_completion_date ? (Time.zone.today - last_completion_date.to_date).to_i : nil

      missed_tasks = Task.where("due_date < ?", Time.zone.today)
                         .where.not(status: [:completed, :on_hold])
      missed_tasks_count = missed_tasks.count
      missed_minutes_lost = missed_tasks.sum(:estimated_time)

      weekly_completions = Task.completed
        .where("completion_date >= ?", 6.weeks.ago)
        .group("DATE_TRUNC('week', completion_date)")
        .count

      completion_chain = (0..5).map do |weeks_ago|
        start_week = weeks_ago.weeks.ago.beginning_of_week
        end_week = weeks_ago.weeks.ago.end_of_week

        available = Task.where(due_date: start_week..end_week)
        completed_week = Task.completed.where(completion_date: start_week..end_week)

        available_count = available.count
        completed_count = completed_week.count
        missed_count = [available_count - completed_count, 0].max

        {
          week_start: start_week,
          completed: completed_count,
          available: available_count,
          missed: missed_count,
          chain_completed: missed_count.zero?
        }
      end.reverse

      report_start = 6.weeks.ago.beginning_of_week
      report_end = Time.zone.today.end_of_week
      report_available = Task.where(due_date: report_start..report_end)
      report_completed = Task.completed.where(completion_date: report_start..report_end)

      report_available_count = report_available.count
      report_completed_count = report_completed.count

      completion_rate =
        if report_available_count.zero?
          0
        else
          (report_completed_count.to_f / report_available_count)
        end

      letter_grade = case (completion_rate * 100).round
                     when 90..100 then "A"
                     when 80..89 then "B"
                     when 70..79 then "C"
                     when 60..69 then "D"
                     else "F"
                     end

      Result.new(
        start_date: start_date,
        end_date: end_date,
        completed_on_time: completed_on_time,
        completed_late: completed_late,
        completed_on_time_count: completed_on_time_count,
        completed_late_count: completed_late_count,
        last_completion_date: last_completion_date,
        days_since_last_completion: days_since_last_completion,
        missed_tasks: missed_tasks,
        missed_tasks_count: missed_tasks_count,
        missed_minutes_lost: missed_minutes_lost,
        weekly_completions: weekly_completions,
        completion_chain: completion_chain,
        report_available_count: report_available_count,
        report_completed_count: report_completed_count,
        completion_rate: completion_rate,
        letter_grade: letter_grade
      )
    end
  end
end

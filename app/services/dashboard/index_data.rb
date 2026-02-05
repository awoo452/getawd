# app/services/dashboard/index_data.rb
module Dashboard
  class IndexData
    Result = Struct.new(
      :tasks, :task_page, :task_total_pages,
      :goals, :goal_page, :goal_total_pages,
      :not_started_goals, :in_progress_goals, :on_hold_goals, :completed_goals,
      :not_started_tasks, :in_progress_tasks, :on_hold_tasks, :completed_tasks,
      :goal_counts, :task_counts,
      :due_today_tasks_not_started, :due_today_goals_not_started,
      :due_today_tasks_in_progress, :due_today_goals_in_progress,
      :due_today_tasks_on_hold, :due_today_goals_on_hold,
      :due_today_tasks_completed, :due_today_goals_completed,
      :total_estimated_minutes_today, :total_actual_minutes_today, :time_remaining_minutes_today,
      :rewards_total_count, :rewards_available_count,
      :ideas,
      keyword_init: true
    )

    def self.call(paginator:)
      new(paginator: paginator).call
    end

    def initialize(paginator:)
      @paginator = paginator
    end

    def call
      tasks, task_page, task_total_pages = @paginator.call(Task.all, per_page: 50)
      goals, goal_page, goal_total_pages = @paginator.call(Goal.all, per_page: 25)

      not_started_goals = Goal.not_started.order(:due_date)
      in_progress_goals = Goal.in_progress.order(:due_date)
      on_hold_goals = Goal.on_hold.order(:due_date)
      completed_goals = Goal.completed.order(:due_date)

      not_started_tasks = Task.not_started.includes(:goal).order(:due_date)
      in_progress_tasks = Task.in_progress.includes(:goal).order(:due_date)
      on_hold_tasks = Task.on_hold.includes(:goal).order(:due_date)
      completed_tasks = Task.completed.includes(:goal).order(:due_date)

      goal_counts = {
        not_started: Goal.not_started.count,
        in_progress: Goal.in_progress.count,
        on_hold: Goal.on_hold.count,
        completed: Goal.completed.count
      }

      task_counts = {
        not_started: Task.not_started.count,
        in_progress: Task.in_progress.count,
        on_hold: Task.on_hold.count,
        completed: Task.completed.count
      }

      due_today_tasks_not_started = Task.not_started.where(due_date: Time.zone.today).count
      due_today_goals_not_started = Goal.not_started.where(due_date: Time.zone.today).count
      due_today_tasks_in_progress = Task.in_progress.where(due_date: Time.zone.today).count
      due_today_goals_in_progress = Goal.in_progress.where(due_date: Time.zone.today).count
      due_today_tasks_on_hold = Task.on_hold.where(due_date: Time.zone.today).count
      due_today_goals_on_hold = Goal.on_hold.where(due_date: Time.zone.today).count
      due_today_tasks_completed = Task.completed.where(due_date: Time.zone.today).count
      due_today_goals_completed = Goal.completed.where(due_date: Time.zone.today).count

      remaining_tasks_today = Task.where.not(status: :completed)
                                  .where(due_date: Time.zone.today.all_day)

      total_estimated_minutes_today = remaining_tasks_today.sum(:estimated_time).to_i
      total_actual_minutes_today = remaining_tasks_today.sum(:actual_time).to_i
      time_remaining_minutes_today = total_estimated_minutes_today - total_actual_minutes_today

      rewards_scope = Reward.includes(:reward_rules, :tasks)
      rewards_total_count = Reward.count
      rewards_available_count = rewards_scope.select(&:eligible?).count

      ideas_map = defined?(IDEAS) ? IDEAS : {}

      ideas = Idea.includes(goals: :tasks).map do |idea|
        emoji = ideas_map[idea.title] || "❓"
        goals_for_idea = idea.goals
        tasks_for_idea = goals_for_idea.flat_map(&:tasks)

        recent_task = tasks_for_idea.select { |t| t.completion_date.present? }.max_by(&:completion_date)
        days_ago = recent_task ? (Time.zone.today - recent_task.completion_date.to_date).to_i : nil

        color = case days_ago
                when nil then "gray"
                when 0 then "green"
                when 1..2 then "yellow"
                when 3..6 then "red"
                else "black"
                end

        {
          id: idea.id,
          title: idea.title,
          emoji: emoji,
          color: color,
          goals_count: goals_for_idea.size,
          tasks_count: tasks_for_idea.size,
          completed_time: tasks_for_idea
            .select { |t| t.status == "completed" || t.status == 3 }
            .sum { |t| t.actual_time.to_i },
          upcoming_time: tasks_for_idea
            .reject { |t| t.status == "completed" || t.status == 3 }
            .sum { |t| [t.estimated_time.to_i - t.actual_time.to_i, 0].max },
          partial_time: tasks_for_idea
            .select { |t| t.status == "in_progress" || t.status == 1 }
            .sum { |t| t.actual_time.to_i }
        }
      end

      Result.new(
        tasks: tasks,
        task_page: task_page,
        task_total_pages: task_total_pages,
        goals: goals,
        goal_page: goal_page,
        goal_total_pages: goal_total_pages,
        not_started_goals: not_started_goals,
        in_progress_goals: in_progress_goals,
        on_hold_goals: on_hold_goals,
        completed_goals: completed_goals,
        not_started_tasks: not_started_tasks,
        in_progress_tasks: in_progress_tasks,
        on_hold_tasks: on_hold_tasks,
        completed_tasks: completed_tasks,
        goal_counts: goal_counts,
        task_counts: task_counts,
        due_today_tasks_not_started: due_today_tasks_not_started,
        due_today_goals_not_started: due_today_goals_not_started,
        due_today_tasks_in_progress: due_today_tasks_in_progress,
        due_today_goals_in_progress: due_today_goals_in_progress,
        due_today_tasks_on_hold: due_today_tasks_on_hold,
        due_today_goals_on_hold: due_today_goals_on_hold,
        due_today_tasks_completed: due_today_tasks_completed,
        due_today_goals_completed: due_today_goals_completed,
        total_estimated_minutes_today: total_estimated_minutes_today,
        total_actual_minutes_today: total_actual_minutes_today,
        time_remaining_minutes_today: time_remaining_minutes_today,
        rewards_total_count: rewards_total_count,
        rewards_available_count: rewards_available_count,
        ideas: ideas
      )
    end
  end
end

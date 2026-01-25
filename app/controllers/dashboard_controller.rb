class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # Paginate tasks
    @tasks, @task_page, @task_total_pages = paginate(Task.all, per_page: 50)

    # Paginate goals
    @goals, @goal_page, @goal_total_pages = paginate(Goal.all, per_page: 25)

    @not_started_goals = Goal.not_started.order(:due_date)
    @in_progress_goals = Goal.in_progress.order(:due_date)
    @on_hold_goals     = Goal.on_hold.order(:due_date)
    @completed_goals   = Goal.completed.order(:due_date)

    @not_started_tasks = Task.not_started.includes(:goal).order(:due_date)
    @in_progress_tasks = Task.in_progress.includes(:goal).order(:due_date)
    @on_hold_tasks     = Task.on_hold.includes(:goal).order(:due_date)
    @completed_tasks   = Task.completed.includes(:goal).order(:due_date)

    @goal_counts = {
      not_started: Goal.not_started.count,
      in_progress: Goal.in_progress.count,
      on_hold:     Goal.on_hold.count,
      completed:   Goal.completed.count
    }

    @task_counts = {
      not_started: Task.not_started.count,
      in_progress: Task.in_progress.count,
      on_hold:     Task.on_hold.count,
      completed:   Task.completed.count
    }

    @due_today_tasks_not_started = Task.not_started.where(due_date: Time.zone.today).count
    @due_today_goals_not_started = Goal.not_started.where(due_date: Time.zone.today).count
    @due_today_tasks_in_progress = Task.in_progress.where(due_date: Time.zone.today).count
    @due_today_goals_in_progress = Goal.in_progress.where(due_date: Time.zone.today).count
    @due_today_tasks_on_hold = Task.on_hold.where(due_date: Time.zone.today).count
    @due_today_goals_on_hold = Goal.on_hold.where(due_date: Time.zone.today).count
    @due_today_tasks_completed = Task.completed.where(due_date: Time.zone.today).count
    @due_today_goals_completed = Goal.completed.where(due_date: Time.zone.today).count

    remaining_tasks_today = Task.where.not(status: :completed)
                                .where(due_date: Time.zone.today.all_day)

    @total_estimated_minutes_today = remaining_tasks_today.sum(:estimated_time).to_i
    @total_actual_minutes_today    = remaining_tasks_today.sum(:actual_time).to_i
    @time_remaining_minutes_today  = @total_estimated_minutes_today - @total_actual_minutes_today

    rewards_scope = Reward.includes(:reward_rules, :tasks)
    @rewards_total_count = Reward.count
    @rewards_available_count = rewards_scope.select(&:eligible?).count

    ideas_map = defined?(IDEAS) ? IDEAS : {}

    # Build ideas with stats included
    @ideas = Idea.includes(goals: :tasks).map do |idea|
      emoji = ideas_map[idea.title] || "❓"

      goals = idea.goals
      tasks = goals.flat_map(&:tasks)

      recent_task = tasks.select { |t| t.completion_date.present? }.max_by(&:completion_date)
      days_ago = recent_task ? (Time.zone.today - recent_task.completion_date.to_date).to_i : nil

      color = case days_ago
              when nil then 'gray'
              when 0 then 'green'
              when 1..2 then 'yellow'
              when 3..6 then 'red'
              else 'black'
              end

      {
        id: idea.id,
        title: idea.title,
        emoji: emoji,
        color: color,
        goals_count: goals.size,
        tasks_count: tasks.size,

        # ✅ total actual time for completed tasks
        completed_time: tasks
          .select { |t| t.status == "completed" || t.status == 3 }
          .sum { |t| t.actual_time.to_i },

        # ⏳ total remaining time (est - actual) for all not completed
        upcoming_time: tasks
          .reject { |t| t.status == "completed" || t.status == 3 }
          .sum { |t| [t.estimated_time.to_i - t.actual_time.to_i, 0].max },

        # ➖ actual time already logged on in_progress tasks
        partial_time: tasks
          .select { |t| t.status == "in_progress" || t.status == 1 }
          .sum { |t| t.actual_time.to_i }
      }
    end
  end
end

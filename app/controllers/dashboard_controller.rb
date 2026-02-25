class DashboardController < ApplicationController
  def index
    data = Dashboard::IndexData.call(paginator: method(:paginate))

    @tasks = data.tasks
    @task_page = data.task_page
    @task_total_pages = data.task_total_pages
    @goals = data.goals
    @goal_page = data.goal_page
    @goal_total_pages = data.goal_total_pages
    @not_started_goals = data.not_started_goals
    @in_progress_goals = data.in_progress_goals
    @on_hold_goals = data.on_hold_goals
    @completed_goals = data.completed_goals
    @not_started_tasks = data.not_started_tasks
    @in_progress_tasks = data.in_progress_tasks
    @on_hold_tasks = data.on_hold_tasks
    @completed_tasks = data.completed_tasks
    @goal_counts = data.goal_counts
    @task_counts = data.task_counts
    @due_today_tasks_not_started = data.due_today_tasks_not_started
    @due_today_goals_not_started = data.due_today_goals_not_started
    @due_today_tasks_in_progress = data.due_today_tasks_in_progress
    @due_today_goals_in_progress = data.due_today_goals_in_progress
    @due_today_tasks_on_hold = data.due_today_tasks_on_hold
    @due_today_goals_on_hold = data.due_today_goals_on_hold
    @due_today_tasks_completed = data.due_today_tasks_completed
    @due_today_goals_completed = data.due_today_goals_completed
    @total_estimated_minutes_today = data.total_estimated_minutes_today
    @total_actual_minutes_today = data.total_actual_minutes_today
    @time_remaining_minutes_today = data.time_remaining_minutes_today
    @rewards_total_count = data.rewards_total_count
    @rewards_available_count = data.rewards_available_count
    @ideas = data.ideas
  end
end

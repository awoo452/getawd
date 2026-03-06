class RecurringTasksController < ApplicationController
  before_action :set_recurring_task, only: %i[show edit update destroy]

  def index
    @recurring_tasks = RecurringTask.includes(:goal).order(created_at: :desc)
  end

  def show
  end

  def new
    @recurring_task = RecurringTask.new
  end

  def create
    @recurring_task = RecurringTask.new(recurring_task_params)

    if @recurring_task.save
      redirect_to @recurring_task, notice: "Recurring task created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @recurring_task.update(recurring_task_params)
      redirect_to @recurring_task, notice: "Recurring task updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recurring_task.destroy
    redirect_to recurring_tasks_path, notice: "Recurring task deleted."
  end

  private

  def set_recurring_task
    @recurring_task = RecurringTask.find(params[:id])
  end

  def recurring_task_params
    params.require(:recurring_task).permit(
      :task_name,
      :description,
      :status,
      :hold_until,
      :priority,
      :start_date,
      :due_date,
      :completion_date,
      :assigned_to,
      :estimated_time,
      :actual_time,
      :goal_id,
      :eligible_reward,
      :specific,
      :measurable,
      :attainable,
      :relevant,
      :time_bound,
      :active
    )
  end
end

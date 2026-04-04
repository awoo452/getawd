class RecurringTasksController < ApplicationController
  before_action :set_goal
  before_action :set_recurring_task, only: %i[show update destroy]

  def create
    @recurring_task = @goal.recurring_tasks.build(recurring_task_params)
    if @recurring_task.save
      redirect_to goal_path(@goal), notice: "Recurring task created."
    else
      load_recurring_tasks
      @new_recurring_task = @recurring_task
      flash.now[:alert] = @recurring_task.errors.full_messages.join(", ")
      render "goals/show", status: :unprocessable_entity
    end
  end

  def show
  end

  def update
    if @recurring_task.update(recurring_task_params)
      redirect_to goal_recurring_task_path(@goal, @recurring_task), notice: "Recurring task updated."
    else
      flash.now[:alert] = @recurring_task.errors.full_messages.join(", ")
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @recurring_task.destroy
    redirect_to goal_path(@goal), notice: "Recurring task deleted."
  end

  private

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def set_recurring_task
    @recurring_task = @goal.recurring_tasks.find(params[:id])
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
      :eligible_reward,
      :specific,
      :measurable,
      :attainable,
      :relevant,
      :time_bound,
      :active
    )
  end

  def load_recurring_tasks
    @recurring_tasks = @goal.recurring_tasks.order(created_at: :desc)
  end

end

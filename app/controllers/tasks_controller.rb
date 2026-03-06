class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit ]

  def index
    result = Tasks::IndexData.call(params: params)
    @tasks_by_status = result.tasks_by_status
    flash.now[:alert] = "Invalid filters: #{result.errors.join(', ')}" if result.errors.any?
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    if recurring_requested?
      @recurring_task = RecurringTask.new(recurring_task_params)
      if @recurring_task.save
        redirect_to @recurring_task, notice: "Recurring task created."
      else
        @task = @recurring_task
        render :new, status: :unprocessable_entity
      end
      return
    end

    result = Tasks::CreateTask.call(params: task_params)

    if result.success?
      redirect_to result.task, notice: "Task created."
    else
      @task = result.task
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    result = Tasks::UpdateTask.call(task_id: params[:id], params: task_params)
    @task = result.task

    if result.success?
      redirect_to @task, notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Tasks::DestroyTask.call(task_id: params[:id])
    redirect_to tasks_url, notice: 'Task was successfully deleted.'
  end

  # app/controllers/tasks_controller.rb
  def complete_on_time
    @task = Tasks::CompleteOnTime.call(task_id: params[:id])
    return_to = params[:return_to].to_s
    if return_to.start_with?("/") && !return_to.start_with?("//")
      redirect_to return_to, notice: "Task completed on time."
    else
      redirect_back fallback_location: tasks_path, notice: "Task completed on time."
    end
  end
  
  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
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
      :repeat_until,
      :specific,
      :measurable,
      :attainable,
      :relevant,
      :time_bound
    )
  end

  def recurring_task_params
    params.require(:task).permit(
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

  def recurring_requested?
    params.dig(:task, :recurring).to_s == "1"
  end
  
end

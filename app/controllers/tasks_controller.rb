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
    redirect_to @task, notice: "Task completed on time."
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
  
end

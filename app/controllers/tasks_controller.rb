class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    scope = Task.all

    if params[:status].present? && Task.statuses.key?(params[:status])
      scope = scope.where(status: Task.statuses[params[:status]])
    end

    if params[:due].present?
      begin
        date = Time.zone.parse(params[:due]).to_date
        scope = scope.where(due_date: date)
      rescue ArgumentError
      end
    end

    scope = scope.where(goal_id: params[:goal_id]) if params[:goal_id].present?

    allowed_sort_columns = %w[task_name status priority due_date]
    if params[:sort].present? && allowed_sort_columns.include?(params[:sort])
      scope = scope.order(params[:sort])
    end

    scope = scope.where("task_name ILIKE ?", "%#{params[:search]}%") if params[:search].present?

    @tasks, @page, @total_pages = paginate(scope, per_page: 25)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    base_task = Task.new(task_params.except(:repeat_until))
    repeat_until = params[:task][:repeat_until].presence

    if base_task.save
      if repeat_until.present?
        end_date = Date.parse(repeat_until)
        if end_date < base_task.due_date
          base_task.errors.add(:repeat_until, "must be after due date")
          @task = base_task
          return render :new, status: :unprocessable_entity
        end

        (1..(end_date - base_task.due_date).to_i).each do |i|
          Task.create(
            base_task.attributes.except("id", "created_at", "updated_at").merge(
              "due_date"   => base_task.due_date + i.days,
              "start_date" => base_task.start_date ? base_task.start_date + i.days : nil
            )
          )
        end
      end

      redirect_to base_task, notice: "Task created."
    else
      @task = base_task
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully deleted.'
  end

  def complete_on_time
    @task = Task.find(params[:id])
    @task.update(
      status: :completed,
      completion_date: Time.zone.today,
      actual_time: @task.estimated_time
    )
    redirect_to @task, notice: "Task completed on time."
  end

  private

  def task_params
    params.require(:task).permit(
      :task_name,
      :description,
      :status,
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
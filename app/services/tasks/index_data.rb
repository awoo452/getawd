# app/services/tasks/index_data.rb
module Tasks
  class IndexData
    Result = Struct.new(:tasks_by_status, keyword_init: true)

    ALLOWED_SORT_COLUMNS = %w[task_name status priority due_date].freeze

    def self.call(params:)
      new(params: params).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      scope = Task.all
      scope = apply_status_filter(scope)
      scope = apply_due_filter(scope)
      scope = apply_goal_filter(scope)
      scope = apply_sort(scope)
      scope = apply_search(scope)
      scope = scope.includes(:goal)

      Result.new(
        tasks_by_status: {
          in_progress: scope.in_progress.order(due_date: :asc),
          not_started: scope.not_started.order(due_date: :asc),
          on_hold: scope.on_hold.order(due_date: :asc),
          completed: scope.completed.order(due_date: :asc)
        }
      )
    end

    private

    def apply_status_filter(scope)
      status = Params::Normalize.enum(@params[:status], Task.statuses)
      return scope unless status

      scope.where(status: Task.statuses[status])
    end

    def apply_due_filter(scope)
      date = Params::Normalize.date(@params[:due])
      return scope unless date

      scope.where(due_date: date)
    end

    def apply_goal_filter(scope)
      goal_id = Params::Normalize.integer(@params[:goal_id])
      return scope unless goal_id

      scope.where(goal_id: goal_id)
    end

    def apply_sort(scope)
      sort_column = Params::Normalize.sort_column(@params[:sort], ALLOWED_SORT_COLUMNS)
      return scope unless sort_column

      scope.order(sort_column)
    end

    def apply_search(scope)
      search = Params::Normalize.string(@params[:search])
      return scope unless search

      scope.where("task_name ILIKE ?", "%#{search}%")
    end
  end
end

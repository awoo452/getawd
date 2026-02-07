# app/services/tasks/index_data.rb
module Tasks
  class IndexData
    Result = Struct.new(:tasks_by_status, :errors, keyword_init: true)

    ALLOWED_SORT_COLUMNS = %w[task_name status priority due_date].freeze

    def self.call(params:)
      new(params: params).call
    end

    def initialize(params:)
      @params = params
      @errors = []
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
        },
        errors: @errors
      )
    end

    private

    def apply_status_filter(scope)
      return scope unless @params[:status].present?

      status = Params::Normalize.enum(@params[:status], Task.statuses)
      return invalid_filter(scope, :status, @params[:status]) unless status

      scope.where(status: Task.statuses[status])
    end

    def apply_due_filter(scope)
      return scope unless @params[:due].present?

      date = Params::Normalize.date(@params[:due])
      return invalid_filter(scope, :due, @params[:due]) unless date

      scope.where(due_date: date)
    end

    def apply_goal_filter(scope)
      return scope unless @params[:goal_id].present?

      goal_id = Params::Normalize.integer(@params[:goal_id])
      return invalid_filter(scope, :goal_id, @params[:goal_id]) unless goal_id

      scope.where(goal_id: goal_id)
    end

    def apply_sort(scope)
      return scope unless @params[:sort].present?

      sort_column = Params::Normalize.sort_column(@params[:sort], ALLOWED_SORT_COLUMNS)
      return invalid_filter(scope, :sort, @params[:sort]) unless sort_column

      scope.order(sort_column)
    end

    def apply_search(scope)
      return scope unless @params[:search].present?

      search = Params::Normalize.string(@params[:search])
      return scope unless search

      scope.where("task_name ILIKE ?", "%#{search}%")
    end

    def invalid_filter(scope, key, value)
      @errors << "#{key} is invalid (#{value})"
      scope
    end
  end
end

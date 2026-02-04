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
      return scope unless @params[:status].present? && Task.statuses.key?(@params[:status])

      scope.where(status: Task.statuses[@params[:status]])
    end

    def apply_due_filter(scope)
      return scope unless @params[:due].present?

      begin
        date = Time.zone.parse(@params[:due]).to_date
        scope.where(due_date: date)
      rescue ArgumentError
        scope
      end
    end

    def apply_goal_filter(scope)
      return scope unless @params[:goal_id].present?

      scope.where(goal_id: @params[:goal_id])
    end

    def apply_sort(scope)
      return scope unless @params[:sort].present? && ALLOWED_SORT_COLUMNS.include?(@params[:sort])

      scope.order(@params[:sort])
    end

    def apply_search(scope)
      return scope unless @params[:search].present?

      scope.where("task_name ILIKE ?", "%#{@params[:search]}%")
    end
  end
end

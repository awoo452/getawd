# app/services/goals/index_data.rb
module Goals
  class IndexData
    Result = Struct.new(:goals_by_status, :errors, keyword_init: true)

    def self.call(params:)
      new(params: params).call
    end

    def initialize(params:)
      @params = params
      @errors = []
    end

    def call
      scope = Goal.all
      scope = apply_status_filter(scope)
      scope = apply_due_filter(scope)
      scope = apply_search(scope)
      scope = scope.includes(:idea)

      Result.new(
        goals_by_status: {
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

      status = Params::Normalize.enum(@params[:status], Goal.statuses)
      return invalid_filter(scope, :status, @params[:status]) unless status

      scope.where(status: Goal.statuses[status])
    end

    def apply_due_filter(scope)
      return scope unless @params[:due].present?

      date = Params::Normalize.date(@params[:due])
      return invalid_filter(scope, :due, @params[:due]) unless date

      scope.where(due_date: date)
    end

    def apply_search(scope)
      return scope unless @params[:search].present?

      search = Params::Normalize.string(@params[:search])
      return scope unless search

      scope.where("title ILIKE ?", "%#{search}%")
    end

    def invalid_filter(scope, key, value)
      @errors << "#{key} is invalid (#{value})"
      scope
    end
  end
end

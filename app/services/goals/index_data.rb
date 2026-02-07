# app/services/goals/index_data.rb
module Goals
  class IndexData
    Result = Struct.new(:goals_by_status, keyword_init: true)

    def self.call(params:)
      new(params: params).call
    end

    def initialize(params:)
      @params = params
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
        }
      )
    end

    private

    def apply_status_filter(scope)
      status = Params::Normalize.enum(@params[:status], Goal.statuses)
      return scope unless status

      scope.where(status: Goal.statuses[status])
    end

    def apply_due_filter(scope)
      date = Params::Normalize.date(@params[:due])
      return scope unless date

      scope.where(due_date: date)
    end

    def apply_search(scope)
      search = Params::Normalize.string(@params[:search])
      return scope unless search

      scope.where("title ILIKE ?", "%#{search}%")
    end
  end
end

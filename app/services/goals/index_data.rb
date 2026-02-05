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
      return scope unless @params[:status].present? && Goal.statuses.key?(@params[:status])

      scope.where(status: Goal.statuses[@params[:status]])
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

    def apply_search(scope)
      return scope unless @params[:search].present?

      scope.where("title ILIKE ?", "%#{@params[:search]}%")
    end
  end
end

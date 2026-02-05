module Goals
  class UpdateGoal
    Result = Struct.new(:success?, :goal, keyword_init: true)

    def self.call(goal_id:, params:)
      new(goal_id: goal_id, params: params).call
    end

    def initialize(goal_id:, params:)
      @goal_id = goal_id
      @params = params
    end

    def call
      goal = Goal.find(@goal_id)
      if goal.update(@params)
        Result.new(success?: true, goal: goal)
      else
        Result.new(success?: false, goal: goal)
      end
    end
  end
end

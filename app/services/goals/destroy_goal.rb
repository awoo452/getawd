module Goals
  class DestroyGoal
    def self.call(goal_id:)
      new(goal_id: goal_id).call
    end

    def initialize(goal_id:)
      @goal_id = goal_id
    end

    def call
      goal = Goal.find(@goal_id)
      goal.destroy!
      goal
    end
  end
end

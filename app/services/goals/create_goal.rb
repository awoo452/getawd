module Goals
  class CreateGoal
    Result = Struct.new(:success?, :goal, keyword_init: true)

    def self.call(params:)
      new(params: params).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      goal = Goal.new(@params)
      if goal.save
        Result.new(success?: true, goal: goal)
      else
        Result.new(success?: false, goal: goal)
      end
    end
  end
end

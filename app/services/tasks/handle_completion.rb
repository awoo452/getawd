module Tasks
  class HandleCompletion
    def self.call(task:)
      new(task: task).call
    end

    def initialize(task:)
      @task = task
    end

    def call
      return unless @task.completed?

      earn_task_reward
      DailyRewardEarner.run_for_level(@task.priority, earned_on_date)
    end

    private

    def earned_on_date
      @task.completion_date || @task.due_date || Date.current
    end

    def earn_task_reward
      return if @task.eligible_reward.blank?

      already = Reward
        .joins(:reward_tasks)
        .where(scope: "task", reward_tasks: { task_id: @task.id })
        .where("reward_payload ->> 'earned_date' = ?", earned_on_date.to_s)
        .exists?

      return if already

      reward = Reward.create!(
        scope: "task",
        kind: "earned",
        reward_payload: {
          task_id: @task.id,
          goal_id: @task.goal_id,
          level: @task.priority,
          item: @task.eligible_reward,
          earned_date: earned_on_date.to_s
        }
      )

      RewardTask.create!(reward: reward, task: @task)
    end
  end
end

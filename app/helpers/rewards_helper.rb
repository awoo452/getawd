# app/helpers/rewards_helper.rb
module RewardsHelper
  def level_1_reward_state
    level_1_goals = Goal.where(recurring: true, priority: 1)

    tasks_today = Task.where(
      goal: level_1_goals,
      due_date: Time.zone.today
    )

    completed = tasks_today.completed.count
    total     = tasks_today.count

    {
      total: total,
      completed: completed,
      remaining: [total - completed, 0].max,
      unlocked: total.positive? && completed == total
    }
  end
end

module RewardsHelper
  def level_1_reward_state
    today = Time.zone.today

    tasks_today = Task.where(
      priority: 1,
      due_date: today
    )

    total     = tasks_today.count
    completed = tasks_today.completed.count

    earned_today = Reward.where(
      "reward_payload ->> 'level' = '1'",
      "reward_payload ->> 'earned_date' = ?",
      today.to_s
    ).exists?

    {
      total: total,
      completed: completed,
      remaining: [total - completed, 0].max,
      unlocked: earned_today
    }
  end
end
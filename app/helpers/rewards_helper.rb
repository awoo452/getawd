module RewardsHelper
  def level_1_completed_for?(date = Time.zone.today)
    tasks = Task.where(priority: 1, due_date: date).where.not(status: Task.statuses[:on_hold])
    tasks.exists? && tasks.all?(&:completed?)
  end

  def level_2_completed_for?(date = Time.zone.today)
    return false unless level_1_completed_for?(date)

    tasks = Task.where(priority: 2, due_date: date).where.not(status: Task.statuses[:on_hold])
    tasks.exists? && tasks.all?(&:completed?)
  end

  def level_1_reward_state
    today = Time.zone.today

    tasks_today = Task.where(priority: 1, due_date: today).where.not(status: Task.statuses[:on_hold])

    total     = tasks_today.count
    completed = tasks_today.completed.count

    earned_today = Reward.where(kind: "earned", scope: "level")
                          .where(
                            "reward_payload ->> 'level' = '1' AND reward_payload ->> 'earned_date' = ?",
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

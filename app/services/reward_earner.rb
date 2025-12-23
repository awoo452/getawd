class RewardEarner
  def self.run(date = Date.current)
    if already_earned?(date)
      raise "Duplicate reward attempt for #{date}"
    end

    return unless eligible_for_level_1?(date)

    Reward.create!(
      name: "Level 1 Reward",
      reward_payload: {
        level: 1,
        duration_minutes: 60,
        earned_for_date: date.to_s
      }
    )
  end

  def self.eligible_for_level_1?(date)
    tasks = Task.where(priority: 1, due_date: date)
    return false if tasks.empty?

    tasks.all?(&:completed?)
  end
  
  def self.already_earned?(date)
    Reward.where(
      "reward_payload ->> 'level' = '1'",
      "reward_payload ->> 'earned_for_date' = ?",
      date.to_s
    ).exists?
  end
end
# app/services/reward_earner.rb
class RewardEarner
  def self.run(date = Time.zone.today)
    return unless eligible_for_level_1?(date)
    return if already_earned?(date)

    Reward.create!(
      name: "Level 1 Earned",
      kind: "earned",
      reward_payload: {
        level: 1,
        earned_date: date.to_s,
        duration_minutes: 60
      }
    )
  end

  def self.eligible_for_level_1?(date)
    tasks = Task.where(priority: 1, due_date: date)
    tasks.any? && tasks.all?(&:completed?)
  end

  def self.already_earned?(date)
    Reward.where(kind: "earned")
          .where("reward_payload ->> 'earned_date' = ?", date.to_s)
          .exists?
  end
end
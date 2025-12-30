class DailyRewardEarner
  LEVELS = [1, 2, 3].freeze

  def self.run(date = Time.zone.today)
    LEVELS.each do |level|
      next unless level_completed?(level, date)
      next if already_earned?(level, date)

      Reward.create!(
        name: "Level #{level} Earned",
        kind: "earned",
        reward_payload: {
          level: level,
          earned_date: date.to_s
        }
      )
    end
  end

  def self.level_completed?(level, date)
    tasks = Task.where(priority: level, due_date: date)
    tasks.exists? && tasks.all?(&:completed?)
  end

  def self.already_earned?(level, date)
    Reward.where(
      "reward_payload ->> 'level' = ? AND reward_payload ->> 'earned_date' = ?",
      level.to_s,
      date.to_s
    ).exists?
  end
end
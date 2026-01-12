# app/services/daily_reward_earner.rb
class DailyRewardEarner
  LEVELS = [1, 2, 3].freeze

  def self.run_for_level(level, date = Time.zone.today)
    return unless date == Time.zone.today

    return unless level_completed?(level, date)

    Reward.create!(
      name: "Level #{level} Earned",
      kind: "earned",
      scope: "level",
      reward_payload: {
        level: level,
        earned_date: date.to_s
      }
    )
  rescue ActiveRecord::RecordNotUnique
    # already earned, ignore
  end

  def self.level_completed?(level, date)
    tasks = Task.where(priority: level, due_date: date).where.not(status: Task.statuses[:on_hold])

    return false unless tasks.exists?

    tasks.all? { |t| t.completed? && t.completion_date == date }
  end
end

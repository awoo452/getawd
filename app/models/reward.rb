class Reward < ApplicationRecord

  belongs_to :goal, optional: true
  has_many :reward_rules, dependent: :destroy
  has_many :reward_tasks, dependent: :destroy
  has_many :tasks, through: :reward_tasks
  
  def eligible?
    all_rules_met? && all_tasks_done? && cooldown_met?
  end

  def all_rules_met?
    reward_rules.all?(&:satisfied?)
  end

  def all_tasks_done?
    tasks.all?(&:completed?)
  end

  def cooldown_met?
    return true if cooldown_days.nil? || cooldown_days.zero?
    last_redeemed_at.nil? || last_redeemed_at.to_date <= Time.zone.today - cooldown_days
  end

  def evaluate!
    update(available: eligible?)
  end

  def redeem!
  game = Game.where(show_to_public: true).order(Arel.sql("RANDOM()")).first
  raise "No public games available" unless game

  update!(
    last_redeemed_at: Time.zone.now,
    reward_payload: reward_payload.merge(
      game_id: game.id,
      game_title: game.game_title,
      redeemed_at: Time.zone.now
    )
  )
end


end
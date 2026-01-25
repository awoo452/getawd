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

  validate :completed_reward_requires_url, if: -> { kind == "completed" && scope == "level" }

  def completed_reward_requires_url
    if completed_reward_url.blank?
      errors.add(:completed_reward_url, "required to complete reward")
    end
  end

end

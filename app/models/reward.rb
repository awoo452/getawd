class Reward < ApplicationRecord

  belongs_to :goal, optional: true
  has_many :reward_rules, dependent: :destroy
  has_many :reward_tasks, dependent: :destroy
  has_many :tasks, through: :reward_tasks
  
  def eligible?
    Rewards::Eligibility.eligible?(self)
  end

  def all_rules_met?
    Rewards::Eligibility.new(self).all_rules_met?
  end

  def all_tasks_done?
    Rewards::Eligibility.new(self).all_tasks_done?
  end

  def cooldown_met?
    Rewards::Eligibility.new(self).cooldown_met?
  end

  def evaluate!
    update(available: Rewards::Eligibility.eligible?(self))
  end

  validate :completed_reward_requires_url, if: -> { kind == "completed" && scope == "level" }

  def completed_reward_requires_url
    if completed_reward_url.blank?
      errors.add(:completed_reward_url, "required to complete reward")
    end
  end

end

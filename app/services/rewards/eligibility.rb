module Rewards
  class Eligibility
    def self.eligible?(reward)
      new(reward).eligible?
    end

    def initialize(reward)
      @reward = reward
    end

    def eligible?
      all_rules_met? && all_tasks_done? && cooldown_met?
    end

    def all_rules_met?
      @reward.reward_rules.all?(&:satisfied?)
    end

    def all_tasks_done?
      @reward.tasks.all?(&:completed?)
    end

    def cooldown_met?
      return true if @reward.cooldown_days.nil? || @reward.cooldown_days.zero?
      @reward.last_redeemed_at.nil? || @reward.last_redeemed_at.to_date <= Time.zone.today - @reward.cooldown_days
    end
  end
end

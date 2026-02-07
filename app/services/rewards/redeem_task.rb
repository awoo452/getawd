# app/services/rewards/redeem_task.rb
module Rewards
  class RedeemTask
    Result = Struct.new(:success?, :alert, :notice, keyword_init: true)

    def self.call(reward_id:)
      new(reward_id: reward_id).call
    end

    def initialize(reward_id:)
      @raw_reward_id = reward_id
      @reward_id = @raw_reward_id.present? ? Params::Normalize.integer(@raw_reward_id) : nil
    end

    def call
      return Result.new(success?: false, alert: "Invalid reward selection.") if @raw_reward_id.present? && @reward_id.nil?

      reward = Reward.find_by(id: @reward_id)
      return Result.new(success?: false, alert: "Reward not found.") unless reward

      unless reward.scope == "task" && reward.kind == "earned"
        return Result.new(success?: false, alert: "Invalid task reward.")
      end

      reward.update!(
        kind: "redeemed",
        reward_payload: reward.reward_payload.merge(
          redeemed_at: Time.zone.now
        )
      )

      Result.new(success?: true, notice: "Task reward redeemed.")
    end
  end
end

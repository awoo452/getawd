# app/services/rewards/redeem_task.rb
module Rewards
  class RedeemTask
    Result = Struct.new(:success?, :alert, :notice, keyword_init: true)

    def self.call(reward_id:)
      new(reward_id: reward_id).call
    end

    def initialize(reward_id:)
      @reward_id = reward_id
    end

    def call
      reward = Reward.find(@reward_id)

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

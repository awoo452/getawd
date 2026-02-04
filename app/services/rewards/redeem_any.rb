# app/services/rewards/redeem_any.rb
module Rewards
  class RedeemAny
    Result = Struct.new(:success?, :alert, :notice, keyword_init: true)

    def self.call(reward_id:, game_id: nil)
      new(reward_id: reward_id, game_id: game_id).call
    end

    def initialize(reward_id:, game_id:)
      @reward_id = reward_id
      @game_id = game_id
    end

    def call
      reward = Reward.find(@reward_id)

      return Result.new(success?: false, alert: "Already redeemed.") if reward.kind != "earned"

      payload = reward.reward_payload.merge(
        redeemed_at: Time.zone.now
      )

      if reward.scope == "level"
        result = apply_level_payload!(reward, payload)
        return result if result.is_a?(Result)
      end

      reward.update!(
        kind: "redeemed",
        reward_payload: payload
      )

      Result.new(success?: true, notice: "Reward redeemed.")
    end

    private

    def apply_level_payload!(reward, payload)
      case reward.reward_payload["level"].to_i
      when 1
        game = Game.where(show_to_public: true).order(Arel.sql("RANDOM()")).first
        payload.merge!(game_id: game&.id, game_title: game&.game_title)
      when 2
        return Result.new(success?: false, alert: "Select a game.") if @game_id.blank?

        game = Game.find_by(id: @game_id, show_to_public: true)
        return Result.new(success?: false, alert: "Invalid game selection.") unless game

        payload.merge!(game_id: game.id, game_title: game.game_title)
      when 3
        payload.merge!(
          fund_amount: 1,
          fund_currency: "USD",
          fund_label: "Game fund"
        )
      end
      payload
    end
  end
end

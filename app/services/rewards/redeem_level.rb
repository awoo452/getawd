# app/services/rewards/redeem_level.rb
module Rewards
  class RedeemLevel
    Result = Struct.new(:success?, :alert, :notice, keyword_init: true)
    LEVELS = (1..5).freeze

    def self.call(level:, reward_id: nil, game_id: nil, today: Time.zone.today)
      new(level: level, reward_id: reward_id, game_id: game_id, today: today).call
    end

    def initialize(level:, reward_id:, game_id:, today:)
      @raw_level = level
      @raw_reward_id = reward_id
      @raw_game_id = game_id
      @level = @raw_level.present? ? Params::Normalize.integer(@raw_level) : nil
      @reward_id = @raw_reward_id.present? ? Params::Normalize.integer(@raw_reward_id) : nil
      @game_id = @raw_game_id.present? ? Params::Normalize.integer(@raw_game_id) : nil
      @today = today
    end

    def call
      return Result.new(success?: false, alert: "Invalid reward selection.") if @raw_reward_id.present? && @reward_id.nil?
      return Result.new(success?: false, alert: "Invalid reward level.") if @raw_level.present? && @level.nil?
      return Result.new(success?: false, alert: "Invalid game selection.") if @raw_game_id.present? && @game_id.nil?

      if @reward_id.blank? && (@level.nil? || @level <= 0)
        return Result.new(success?: false, alert: "Reward level is required.")
      end
      if @reward_id.blank? && !LEVELS.cover?(@level)
        return Result.new(success?: false, alert: "Invalid reward level.")
      end

      earned_reward = find_earned_reward

      if @reward_id.present? && earned_reward.nil?
        return Result.new(success?: false, alert: "Reward not found.")
      end

      return Result.new(success?: false, alert: "No reward earned for Level #{@level} today.") unless earned_reward
      return Result.new(success?: false, alert: "Invalid reward selection.") unless valid_level_reward?(earned_reward)
      unless LEVELS.cover?(earned_reward.reward_payload["level"].to_i)
        return Result.new(success?: false, alert: "Invalid reward level.")
      end

      apply_reward_level!(earned_reward) if @reward_id.present?
      payload_result = build_payload(earned_reward)
      return payload_result if payload_result.is_a?(Result)

      earned_reward.update!(
        kind: "redeemed",
        reward_payload: payload_result
      )

      Result.new(success?: true, notice: "Level #{@level} reward redeemed.")
    end

    private

    def find_earned_reward
      return Reward.find_by(id: @reward_id) if @reward_id.present?

      Reward.where(
        kind: "earned",
        scope: "level"
      ).where(
        "reward_payload ->> 'earned_date' = ?", @today.to_s
      ).where(
        "reward_payload ->> 'level' = ?", @level.to_s
      ).first
    end

    def valid_level_reward?(reward)
      reward.kind == "earned" && reward.scope == "level"
    end

    def apply_reward_level!(reward)
      reward_level = reward.reward_payload["level"].to_i
      @level = reward_level if LEVELS.cover?(reward_level)
    end

    def build_payload(earned_reward)
      payload = earned_reward.reward_payload.merge(
        redeemed_at: Time.zone.now
      )

      case @level
      when 1
        game = Game.where(show_to_public: true)
                   .order(Arel.sql("RANDOM()"))
                   .first
        payload.merge!(
          game_id: game&.id,
          game_title: game&.game_title
        )
      when 2
        return Result.new(success?: false, alert: "Select a game before redeeming this reward.") if @game_id.blank?

        game = Game.find_by(id: @game_id, show_to_public: true)
        return Result.new(success?: false, alert: "Invalid game selection.") unless game

        payload.merge!(
          game_id: game.id,
          game_title: game.game_title
        )
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

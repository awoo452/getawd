# app/controllers/rewards_controller.rb
class RewardsController < ApplicationController
  before_action :authenticate_user!
  helper RewardsHelper

  def index
    today = Time.zone.today

    earned = Reward.where(kind: "earned")
      .where("reward_payload ->> 'earned_date' = ?", today.to_s)

    redeemed = Reward.where(kind: "redeemed")
      .where("reward_payload ->> 'earned_date' = ?", today.to_s)

    @earned_by_level = earned.index_by { |r| r.reward_payload["level"].to_i }
    @redeemed_levels = redeemed.pluck(Arel.sql("(reward_payload->>'level')::int")).to_set

    @public_games = Game.where(show_to_public: true).limit(5)
    @redeemed_count = Reward.where(kind: "redeemed").count
    @rewards = Reward.order(created_at: :desc)
  end

  def show
    @reward = Reward.find_by(id: params[:id])

    unless @reward
      redirect_to rewards_path, alert: "Reward not found."
    end
  end

  def redeem
    today = Time.zone.today
    level = params[:level].to_i
    level = 1 if level.zero?

    earned_reward = Reward.where(kind: "earned")
      .where("reward_payload ->> 'earned_date' = ?", today.to_s)
      .where("reward_payload ->> 'level' = ?", level.to_s)
      .first

    unless earned_reward
      redirect_to rewards_path, alert: "No reward earned for Level #{level} today."
      return
    end

    payload = earned_reward.reward_payload.merge(
      redeemed_at: Time.zone.now
    )

    # Only Level 1 is a gaming reward
    if level == 1
      game = Game.where(show_to_public: true)
                .order(Arel.sql("RANDOM()"))
                .first

      payload.merge!(
        game_id: game&.id,
        game_title: game&.game_title
      )
    end

    earned_reward.update!(
      kind: "redeemed",
      reward_payload: payload
    )

    redirect_to rewards_path, notice: "Level #{level} reward redeemed."
  end

end
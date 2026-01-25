# app/controllers/rewards_controller.rb
class RewardsController < ApplicationController
  before_action :authenticate_user!
  helper RewardsHelper

  def index
    today = Time.zone.today.to_s

    redeemed = Reward.where(
      kind: "redeemed",
      scope: "level"
    ).where("reward_payload ->> 'earned_date' = ?", today)

    @redeemed_levels = redeemed
      .pluck(Arel.sql("(reward_payload->>'level')::int"))
      .to_set

    earned_levels = Reward.where(
      kind: "earned",
      scope: "level"
    ).where("reward_payload ->> 'earned_date' = ?", today)

    @earned_by_level = earned_levels.index_by { |r| r.reward_payload["level"].to_i }

    completed = Reward.where(kind: "completed")
                      .where("updated_at >= ?", 7.days.ago)

    @task_rewards_today = Reward.where(
      scope: "task",
      kind: "earned"
    ).where("reward_payload ->> 'earned_date' = ?", today)

    @public_games = Game.where(show_to_public: true)

    @recent_rewards = (redeemed + completed).uniq
    @rewards = Reward.order(created_at: :desc)
  end


  def show
    @reward = Reward.find_by(id: params[:id])

    unless @reward
      redirect_to rewards_path, alert: "Reward not found."
    end
  end

  def redeem_task
    reward = Reward.find(params[:id])

    unless reward.scope == "task" && reward.kind == "earned"
      redirect_to rewards_path, alert: "Invalid task reward."
      return
    end

    reward.update!(
      kind: "redeemed",
      reward_payload: reward.reward_payload.merge(
        redeemed_at: Time.zone.now
      )
    )

    redirect_to rewards_path, notice: "Task reward redeemed."
  end

  def redeem
    today = Time.zone.today
    level = params[:level].to_i
    level = 1 if level.zero?

    earned_reward =
      if params[:reward_id].present?
        Reward.find(params[:reward_id])
      else
        Reward.where(
          kind: "earned",
          scope: "level"
        ).where(
          "reward_payload ->> 'earned_date' = ?", today.to_s
        ).where(
          "reward_payload ->> 'level' = ?", level.to_s
        ).first
      end


    unless earned_reward
      redirect_to rewards_path, alert: "No reward earned for Level #{level} today."
      return
    end

    if earned_reward.kind != "earned" || earned_reward.scope != "level"
      redirect_to rewards_path, alert: "Invalid reward selection."
      return
    end

    if params[:reward_id].present?
      reward_level = earned_reward.reward_payload["level"].to_i
      level = reward_level if reward_level.positive?
    end

    payload = earned_reward.reward_payload.merge(
      redeemed_at: Time.zone.now
    )

    if level == 1
      game = Game.where(show_to_public: true)
                .order(Arel.sql("RANDOM()"))
                .first

      payload.merge!(
        game_id: game&.id,
        game_title: game&.game_title
      )

    elsif level == 2
      if params[:game_id].blank?
        redirect_to rewards_path, alert: "Select a game before redeeming this reward."
        return
      end

      game = Game.find_by(id: params[:game_id], show_to_public: true)

      unless game
        redirect_to rewards_path, alert: "Invalid game selection."
        return
      end

      payload.merge!(
        game_id: game.id,
        game_title: game.game_title
      )
    end

    earned_reward.update!(
      kind: "redeemed",
      reward_payload: payload
    )

    redirect_to rewards_path, notice: "Level #{level} reward redeemed."
  end

  def redeem_any
    reward = Reward.find(params[:id])

    if reward.kind != "earned"
      redirect_to rewards_path, alert: "Already redeemed."
      return
    end

    payload = reward.reward_payload.merge(
      redeemed_at: Time.zone.now
    )

    if reward.scope == "level"
      if reward.reward_payload["level"].to_i == 1
        game = Game.where(show_to_public: true).order(Arel.sql("RANDOM()")).first
        payload.merge!(game_id: game&.id, game_title: game&.game_title)

      elsif reward.reward_payload["level"].to_i == 2
        if params[:game_id].blank?
          redirect_to rewards_path, alert: "Select a game."
          return
        end

        game = Game.find_by(id: params[:game_id], show_to_public: true)
        unless game
          redirect_to rewards_path, alert: "Invalid game selection."
          return
        end

        payload.merge!(game_id: game.id, game_title: game.game_title)
      end
    end

    reward.update!(
      kind: "redeemed",
      reward_payload: payload
    )

    redirect_to rewards_path, notice: "Reward redeemed."
  end

  def update
    @reward = Reward.find(params[:id])

    if @reward.update(reward_params)
      redirect_to @reward, notice: "Reward updated."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def reward_params
    params.require(:reward).permit(
      :description,
      :kind,
      :completed_reward_url,
      :completed_reward_notes
    )
  end

end

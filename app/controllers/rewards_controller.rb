class RewardsController < ApplicationController
  before_action :authenticate_user!
  helper RewardsHelper

  def index
    today = Time.zone.today

    @earned_reward = Reward.where(kind: "earned")
      .where("reward_payload ->> 'earned_date' = ?", today.to_s)
      .first

    @reward_consumed_today = Reward.where(kind: "redeemed")
      .where("reward_payload ->> 'earned_date' = ?", today.to_s)
      .exists?

    level_1_tasks_today = Task.where(priority: 1)
      .where(due_date: today)

    @level_1_completed_today =
      level_1_tasks_today.exists? &&
      level_1_tasks_today.all?(&:completed?)

    @public_games = Game.where(show_to_public: true).limit(5)
    @redeemed_count = Reward.where(kind: "redeemed").count
    @rewards = Reward.order(created_at: :desc)
  end

  def new
    @reward = Reward.new
    @goals = Goal.all
    @tasks = Task.where(status: [:not_started, :in_progress, :on_hold])
  end

  def create
    @reward = Reward.new(reward_params)

    if @reward.save
      flash[:notice] = "Reward created!"
      redirect_to rewards_path
    else
      flash[:alert] = "Something went wrong."
      @goals = Goal.all
      @tasks = Task.all
      render :new
    end
  end

  def destroy
    reward = Reward.find(params[:id])
    reward.destroy
    flash[:notice] = "#{reward.name} deleted."
    redirect_to rewards_path
  end

  def evaluate
    reward = Reward.find(params[:id])
    reward.evaluate!
    flash[:notice] = "Re-evaluated #{reward.name}"
    redirect_to rewards_path
  end

  def show
    @reward = Reward.find(params[:id])
  end

  def redeem
    today = Time.zone.today

    earned_reward = Reward.where(kind: "earned")
      .where("reward_payload ->> 'earned_date' = ?", today.to_s)
      .first

    unless earned_reward
      redirect_to rewards_path, alert: "No reward earned today."
      return
    end

    game = Game.where(show_to_public: true)
              .order(Arel.sql("RANDOM()"))
              .first

    earned_reward.update!(
      kind: "redeemed",
      reward_payload: earned_reward.reward_payload.merge(
        redeemed_at: Time.zone.now,
        game_id: game.id,
        game_title: game.game_title
      )
    )

    redirect_to rewards_path, notice: "Reward redeemed."
  end

  private

  def reward_params
    params.require(:reward).permit(
      :name,
      :description,
      :goal_id,
      :cooldown_days,
      :allowed_duration_days,
      task_ids: []
    )
  end
end
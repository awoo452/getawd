class RewardsController < ApplicationController
  before_action :authenticate_user!
  helper RewardsHelper

  def index

    @level_1_reward = Reward.first
    @public_games = Game.where(show_to_public: true).limit(5)
    @banked_level_1_count = Reward.where(
      "reward_payload ->> 'level' = '1'",
      last_redeemed_at: nil
    ).count

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
    reward = Reward.find(params[:id])

    if reward.eligible?
      reward.redeem!
      flash[:notice] = "#{reward.name} redeemed!"
      redirect_to reward_path(reward)
    else
      flash[:alert] = "#{reward.name} is not currently available."
      redirect_to rewards_path
    end
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
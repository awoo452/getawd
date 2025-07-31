class RewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rewards = Reward.includes(:goal, :tasks, :reward_rules)
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

  def redeem
    reward = Reward.find(params[:id])

    if reward.eligible?
        reward.redeem!
        flash[:notice] = "#{reward.name} redeemed!"
    else
        flash[:alert] = "#{reward.name} is not currently available."
    end

    redirect_to rewards_path
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
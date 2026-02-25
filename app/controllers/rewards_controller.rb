# app/controllers/rewards_controller.rb
class RewardsController < ApplicationController
  helper RewardsHelper

  def index
    data = Rewards::IndexData.call(paginator: method(:paginate))

    @redeemed_levels = data.redeemed_levels
    @earned_by_level = data.earned_by_level
    @task_rewards_today = data.task_rewards_today
    @public_games = data.public_games
    @recent_rewards = data.recent_rewards
    @rewards = data.rewards
    @rewards_page = data.rewards_page
    @rewards_total_pages = data.rewards_total_pages
  end


  def show
    @reward = Reward.find_by(id: params[:id])

    unless @reward
      redirect_to rewards_path, alert: "Reward not found."
    end
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

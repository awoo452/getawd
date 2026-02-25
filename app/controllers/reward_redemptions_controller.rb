class RewardRedemptionsController < ApplicationController
  def redeem_task
    result = Rewards::RedeemTask.call(reward_id: params[:id])

    if result.success?
      redirect_to rewards_path, notice: result.notice
    else
      redirect_to rewards_path, alert: result.alert
    end
  end

  def redeem
    result = Rewards::RedeemLevel.call(
      level: params[:level],
      reward_id: params[:reward_id],
      game_id: params[:game_id]
    )

    if result.success?
      redirect_to rewards_path, notice: result.notice
    else
      redirect_to rewards_path, alert: result.alert
    end
  end

  def redeem_any
    result = Rewards::RedeemAny.call(
      reward_id: params[:id],
      game_id: params[:game_id]
    )

    if result.success?
      redirect_to rewards_path, notice: result.notice
    else
      redirect_to rewards_path, alert: result.alert
    end
  end
end

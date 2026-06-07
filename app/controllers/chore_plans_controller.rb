class ChorePlansController < ApplicationController
  before_action :set_chore_plan, only: [:destroy]

  def create
    @chore_plan = ChorePlan.new(chore_plan_params)
    if @chore_plan.save
      redirect_to chores_path, notice: "Chore planned."
    else
      redirect_to chores_path, alert: @chore_plan.errors.full_messages.to_sentence
    end
  end

  def destroy
    @chore_plan.destroy
    redirect_to chores_path, notice: "Chore removed."
  end

  private

  def set_chore_plan
    @chore_plan = ChorePlan.find(params[:id])
  end

  def chore_plan_params
    params.require(:chore_plan).permit(:planned_on, :chore_type)
  end
end

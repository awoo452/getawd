class MealPlansController < ApplicationController
  before_action :set_meal_plan, only: [:update, :destroy]

  def create
    @meal_plan = MealPlan.new(meal_plan_params)
    if @meal_plan.save
      redirect_to kitchen_path, notice: "Meal planned."
    else
      redirect_to kitchen_path, alert: @meal_plan.errors.full_messages.to_sentence
    end
  end

  def update
    if @meal_plan.update(meal_plan_params.except(:planned_on, :meal_slot))
      redirect_to kitchen_path, notice: "Meal updated."
    else
      redirect_to kitchen_path, alert: @meal_plan.errors.full_messages.to_sentence
    end
  end

  def destroy
    @meal_plan.destroy
    redirect_to kitchen_path, notice: "Meal removed."
  end

  private

  def set_meal_plan
    @meal_plan = MealPlan.find(params[:id])
  end

  def meal_plan_params
    params.require(:meal_plan).permit(:planned_on, :meal_slot, :recipe_id)
  end
end

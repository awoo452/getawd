class MealPlanRecipesController < ApplicationController
  include KitchenHelpers
  include MealCellResponder

  def create
    return head :unprocessable_entity if params[:recipe_id].blank?

    ActiveRecord::Base.transaction do
      meal_plan = MealPlan.find_or_create_by!(
        planned_on: Date.parse(params[:planned_on].to_s),
        meal_slot:  params[:meal_slot]
      )
      mpr = meal_plan.meal_plan_recipes.find_or_initialize_by(recipe_id: params[:recipe_id].to_i)
      mpr.new_record? ? mpr.save! : mpr.increment!(:quantity)
      respond_with_cell(meal_plan.reload)
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ArgumentError
    head :unprocessable_entity
  end

  def destroy
    mpr       = MealPlanRecipe.find(params[:id])
    meal_plan = mpr.meal_plan
    date      = meal_plan.planned_on
    slot      = meal_plan.meal_slot
    mpr.destroy
    meal_plan.reload
    if meal_plan.recipes.empty? && meal_plan.meal_plan_items.empty?
      meal_plan.destroy
      respond_with_empty_cell(date, slot)
    else
      respond_with_cell(meal_plan)
    end
  end
end

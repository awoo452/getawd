class MealPlanItemsController < ApplicationController
  include KitchenHelpers
  include MealCellResponder

  def create
    return head :unprocessable_entity if params[:food_item_id].blank?

    ActiveRecord::Base.transaction do
      meal_plan = MealPlan.find_or_create_by!(
        planned_on: Date.parse(params[:planned_on].to_s),
        meal_slot:  params[:meal_slot]
      )
      meal_plan.meal_plan_items.create!(food_item_id: params[:food_item_id], quantity: [params[:quantity].to_i, 1].max)
      respond_with_cell(meal_plan.reload)
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ArgumentError
    head :unprocessable_entity
  end

  def destroy
    item      = MealPlanItem.find(params[:id])
    meal_plan = item.meal_plan
    date      = meal_plan.planned_on
    slot      = meal_plan.meal_slot
    destroyed = false
    ActiveRecord::Base.transaction do
      item.destroy
      if meal_plan.meal_plan_items.reload.empty? && meal_plan.recipes.empty?
        meal_plan.destroy
        destroyed = true
      end
    end
    destroyed ? respond_with_empty_cell(date, slot) : respond_with_cell(meal_plan)
  end
end

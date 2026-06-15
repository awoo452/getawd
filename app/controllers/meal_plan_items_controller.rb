class MealPlanItemsController < ApplicationController
  include KitchenHelpers
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
    ActiveRecord::Base.transaction do
      item.destroy
      meal_plan.destroy if meal_plan.meal_plan_items.reload.empty? && meal_plan.recipes.empty?
    end
    respond_with_cell(meal_plan)
  end

  private

  def respond_with_cell(meal_plan)
    date = meal_plan.planned_on
    slot = meal_plan.meal_slot
    still_exists = MealPlan.exists?(meal_plan.id)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "meal_cell_#{date.iso8601}_#{slot}",
          partial: "kitchen/meal_cell",
          locals: {
            date:              date,
            slot:              slot,
            meal_plan:         still_exists ? MealPlan.includes(:meal_plan_recipes, :recipes, meal_plan_items: :food_item).find(meal_plan.id) : nil,
            recipes_for_slot:  Recipe.active.by_meal_type(slot).ordered,
            food_items_grouped: grouped_food_items
          }
        )
      end
      format.html { redirect_to kitchen_path }
    end
  end
end

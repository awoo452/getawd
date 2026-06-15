class MealPlanRecipesController < ApplicationController
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
    mpr = MealPlanRecipe.find(params[:id])
    meal_plan = mpr.meal_plan
    mpr.destroy
    meal_plan.reload
    if meal_plan.recipes.empty? && meal_plan.meal_plan_items.empty?
      date = meal_plan.planned_on
      slot = meal_plan.meal_slot
      meal_plan.destroy
      respond_with_empty_cell(date, slot)
    else
      respond_with_cell(meal_plan)
    end
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
            date:               date,
            slot:               slot,
            meal_plan:          still_exists ? MealPlan.includes(:meal_plan_recipes, :recipes, meal_plan_items: :food_item).find(meal_plan.id) : nil,
            recipes_for_slot:   Recipe.active.by_meal_type(slot).ordered,
            food_items_grouped: grouped_food_items
          }
        )
      end
      format.html { redirect_to kitchen_path }
    end
  end

  def respond_with_empty_cell(date, slot)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "meal_cell_#{date.iso8601}_#{slot}",
          partial: "kitchen/meal_cell",
          locals: {
            date:               date,
            slot:               slot,
            meal_plan:          nil,
            recipes_for_slot:   Recipe.active.by_meal_type(slot).ordered,
            food_items_grouped: grouped_food_items
          }
        )
      end
      format.html { redirect_to kitchen_path }
    end
  end

  def grouped_food_items
    FoodItem.active.ordered.group_by { |fi| fi.food_type.humanize }
            .transform_values { |items| items.map { |fi| [fi.name, fi.id] } }
  end
end

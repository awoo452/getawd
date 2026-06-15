module MealCellResponder
  extend ActiveSupport::Concern

  private

  def respond_with_cell(meal_plan)
    date = meal_plan.planned_on
    slot = meal_plan.meal_slot
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "meal_cell_#{date.iso8601}_#{slot}",
          partial: "kitchen/meal_cell",
          locals: {
            date:               date,
            slot:               slot,
            meal_plan:          MealPlan.includes(:meal_plan_recipes, :recipes, meal_plan_items: :food_item).find(meal_plan.id),
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
end

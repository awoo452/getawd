class MealPlansController < ApplicationController
  before_action :set_meal_plan, only: [:update, :destroy, :remove_recipe, :toggle_cooked]

  def create
    @meal_plan = MealPlan.new(meal_plan_params)
    if @meal_plan.save
      respond_with_cell(@meal_plan)
    else
      redirect_to kitchen_path, alert: @meal_plan.errors.full_messages.to_sentence
    end
  end

  def update
    if @meal_plan.update(meal_plan_params.except(:planned_on, :meal_slot))
      respond_with_cell(@meal_plan)
    else
      redirect_to kitchen_path, alert: @meal_plan.errors.full_messages.to_sentence
    end
  end

  def destroy
    date = @meal_plan.planned_on
    slot = @meal_plan.meal_slot
    @meal_plan.destroy
    respond_with_empty_cell(date, slot)
  end

  def toggle_cooked
    if @meal_plan.cooked?
      @meal_plan.restore_inventory!
      @meal_plan.update!(cooked: false)
    else
      @meal_plan.deduct_inventory!
      @meal_plan.update!(cooked: true)
    end
    respond_with_cell(@meal_plan.reload)
  end

  def remove_recipe
    @meal_plan.update!(recipe_id: nil)
    if @meal_plan.meal_plan_items.empty?
      date = @meal_plan.planned_on
      slot = @meal_plan.meal_slot
      @meal_plan.destroy
      respond_with_empty_cell(date, slot)
    else
      respond_with_cell(@meal_plan.reload)
    end
  end

  private

  def set_meal_plan
    @meal_plan = MealPlan.find(params[:id])
  end

  def meal_plan_params
    params.require(:meal_plan).permit(:planned_on, :meal_slot, :recipe_id)
  end

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
            meal_plan:          MealPlan.includes(:recipe, meal_plan_items: :food_item).find(meal_plan.id),
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

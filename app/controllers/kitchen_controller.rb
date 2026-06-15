class KitchenController < ApplicationController
  include KitchenHelpers
  def index
    @low_stock_count      = PantryItem.low_stock.count
    @out_of_stock_count   = PantryItem.out_of_stock.count
    @active_shopping_list = ShoppingList.active.order(generated_on: :desc).first
    @recipes_by_type      = Recipe.active
                                   .includes(recipe_ingredients: :food_item)
                                   .ordered
                                   .group_by(&:meal_type_suggestion)

    @selected_date = parse_selected_date(params[:selected_date])
    @selected_col  = @selected_date.wday
    @week_start    = params[:selected_date].present? ? @selected_date.beginning_of_week(:sunday) : parse_week_start(params[:week_start])
    @week_dates    = (0..6).map { |i| @week_start + i.days }
    week_end       = @week_start + 6.days

    meal_plans = MealPlan.includes(:meal_plan_recipes, :recipes, meal_plan_items: :food_item).where(planned_on: @week_start..week_end)
    @meal_plans_by_date_slot = meal_plans.index_by { |mp| [mp.planned_on, mp.meal_slot] }

    @recipes_for_slot = MealPlan::SLOTS.index_with do |slot|
      Recipe.active.by_meal_type(slot).ordered
    end

    @food_items_grouped = FoodItem.active.ordered
                                  .group_by { |fi| fi.food_type.humanize }
                                  .transform_values { |items| items.map { |fi| [fi.name, fi.id] } }

    @prepared_dishes = PreparedDish.active.by_date

    eat_logs = EatLog.for_week(@week_start).includes(:prepared_dish)
    @eat_logs_by_date_slot = eat_logs.group_by { |el| [el.date, el.meal_slot] }
  end

  private

  def parse_week_start(date_str)
    Date.parse(date_str.to_s).beginning_of_week(:sunday)
  rescue ArgumentError, TypeError
    Time.zone.today.beginning_of_week(:sunday)
  end

  def parse_selected_date(date_str)
    Date.parse(date_str.to_s)
  rescue ArgumentError, TypeError
    Time.zone.today
  end
end

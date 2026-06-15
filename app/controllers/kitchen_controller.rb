class KitchenController < ApplicationController
  def index
    data = Kitchen::IndexData.call(params: params)
    @low_stock_count         = data.low_stock_count
    @out_of_stock_count      = data.out_of_stock_count
    @active_shopping_list    = data.active_shopping_list
    @recipes_by_type         = data.recipes_by_type
    @selected_date           = data.selected_date
    @selected_col            = data.selected_col
    @week_start              = data.week_start
    @week_dates              = data.week_dates
    @meal_plans_by_date_slot = data.meal_plans_by_date_slot
    @recipes_for_slot        = data.recipes_for_slot
    @food_items_grouped      = data.food_items_grouped
    @prepared_dishes         = data.prepared_dishes
    @eat_logs_by_date_slot   = data.eat_logs_by_date_slot
  end
end

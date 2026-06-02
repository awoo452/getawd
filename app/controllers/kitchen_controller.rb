class KitchenController < ApplicationController
  def index
    @low_stock_count      = PantryItem.low_stock.count
    @out_of_stock_count   = PantryItem.out_of_stock.count
    @active_shopping_list = ShoppingList.active.order(generated_on: :desc).first
    @recipes_by_type      = Recipe.active
                                   .includes(recipe_ingredients: :food_item)
                                   .ordered
                                   .group_by(&:meal_type_suggestion)
  end
end

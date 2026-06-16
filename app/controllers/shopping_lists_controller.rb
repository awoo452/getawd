class ShoppingListsController < ApplicationController
  include KitchenHelpers
  before_action :set_shopping_list, only: [:show, :destroy, :archive]

  def index
    @active_lists   = ShoppingList.active.order(generated_on: :desc)
    @archived_lists = ShoppingList.archived.recent.limit(10)
  end

  def show
    @items_by_type = @shopping_list.shopping_list_items
                                    .includes(food_item: :pantry_item)
                                    .ordered_by_food
                                    .group_by { |i| i.food_item.food_type }
    @food_items_grouped = grouped_food_items
  end

  def create
    upcoming_plans = MealPlan
      .where(planned_on: Date.current.., cooked: false)
      .includes(
        meal_plan_recipes: { recipe: { recipe_ingredients: { food_item: :pantry_item } } },
        meal_plan_items: { food_item: :pantry_item }
      )

    needed_servings  = Hash.new(0.0)
    food_items_cache = {}

    upcoming_plans.each do |mp|
      mp.meal_plan_recipes.each do |mpr|
        mpr.recipe.recipe_ingredients.each do |ri|
          fi = ri.food_item
          food_items_cache[fi.id] = fi
          needed_servings[fi.id] += mpr.quantity * ri.quantity * fi.servings_per_unit
        end
      end
      mp.meal_plan_items.each do |item|
        fi = item.food_item
        food_items_cache[fi.id] = fi
        needed_servings[fi.id] += item.quantity * fi.servings_per_unit
      end
    end

    shortfalls = needed_servings.filter_map do |food_item_id, servings_needed|
      fi        = food_items_cache[food_item_id]
      on_hand   = fi.pantry_item&.servings_on_hand.to_f
      shortfall = servings_needed - on_hand
      next unless shortfall > 0
      units = [(shortfall / fi.servings_per_unit).ceil, 1].max
      { food_item: fi, quantity_needed: units }
    end

    if shortfalls.none?
      redirect_to shopping_lists_path, alert: "Nothing needed — you have everything for your planned meals."
      return
    end

    list = ShoppingList.create!(generated_on: Date.current, status: "active", label: "From Meal Plans")
    shortfalls.each do |s|
      list.shopping_list_items.create!(food_item: s[:food_item], quantity_needed: s[:quantity_needed])
    end

    redirect_to list, notice: "Shopping list generated with #{list.total_count} items."
  end

  def destroy
    @shopping_list.destroy
    redirect_to shopping_lists_path, notice: "List deleted."
  end

  def archive
    @shopping_list.archive!
    redirect_to shopping_lists_path, notice: "List archived."
  end

  private

  def set_shopping_list
    @shopping_list = ShoppingList.find(params[:id])
  end
end

class ShoppingListsController < ApplicationController
  include KitchenHelpers
  before_action :set_shopping_list, only: [:show, :destroy, :archive, :unarchive]

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

    list = ShoppingList.active.find_or_create_by!(label: "From Meal Plans") do |l|
      l.generated_on = Date.current
      l.status       = "active"
    end
    list.update!(generated_on: Date.current)
    list.shopping_list_items.destroy_all

    shortfalls.each do |s|
      list.shopping_list_items.create!(food_item: s[:food_item], quantity_needed: s[:quantity_needed])
    end

    redirect_to list, notice: "Shopping list generated with #{list.total_count} items."
  end

  def merge
    active_lists = ShoppingList.active.to_a
    if active_lists.size < 2
      redirect_to shopping_lists_path, alert: "Need at least 2 active lists to merge."
      return
    end

    merged = Hash.new(0)
    active_lists.each do |list|
      list.shopping_list_items.each do |item|
        merged[item.food_item_id] = [merged[item.food_item_id], item.quantity_needed].max
      end
    end

    labels = active_lists.map(&:display_label).join(" + ")
    new_list = ShoppingList.create!(label: labels, generated_on: Date.current, status: "active")
    merged.each do |food_item_id, quantity|
      new_list.shopping_list_items.create!(food_item_id: food_item_id, quantity_needed: quantity)
    end

    active_lists.each(&:archive!)
    redirect_to new_list, notice: "Merged #{active_lists.size} lists into one (#{new_list.total_count} items)."
  end

  def destroy
    @shopping_list.destroy
    redirect_to shopping_lists_path, notice: "List deleted."
  end

  def archive
    @shopping_list.shopping_list_items.includes(food_item: :pantry_item).each do |item|
      pi = item.food_item.pantry_item
      next unless pi
      pi.increment!(:servings_on_hand, item.quantity_needed * item.food_item.servings_per_unit)
    end
    @shopping_list.archive!
    redirect_to shopping_lists_path, notice: "Done shopping! Pantry updated."
  end

  def unarchive
    @shopping_list.shopping_list_items.includes(food_item: :pantry_item).each do |item|
      pi = item.food_item.pantry_item
      next unless pi
      pi.decrement!(:servings_on_hand, item.quantity_needed * item.food_item.servings_per_unit)
    end
    @shopping_list.update!(status: "active")
    redirect_to shopping_lists_path, notice: "List reactivated and pantry reversed."
  end

  private

  def set_shopping_list
    @shopping_list = ShoppingList.find(params[:id])
  end
end

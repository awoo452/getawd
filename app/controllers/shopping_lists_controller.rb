class ShoppingListsController < ApplicationController
  before_action :set_shopping_list, only: [:show, :destroy, :archive]

  def index
    @active_list    = ShoppingList.active.order(generated_on: :desc).first
    @archived_lists = ShoppingList.archived.recent.limit(10)
  end

  def show
    @items_by_type = @shopping_list.shopping_list_items
                                    .includes(:food_item)
                                    .ordered_by_food
                                    .group_by { |i| i.food_item.food_type }
  end

  def create
    existing = ShoppingList.active.first
    if existing
      redirect_to existing, notice: "You already have an active shopping list."
      return
    end

    list = ShoppingList.new(generated_on: Date.current, status: "active")

    low_items = PantryItem.low_stock.includes(:food_item)
    if low_items.none?
      redirect_to shopping_lists_path, alert: "Nothing is low — pantry looks good!"
      return
    end

    list.save!
    low_items.each do |pi|
      needed = [pi.min_quantity - pi.quantity_on_hand + 1, 1].max
      list.shopping_list_items.create!(food_item: pi.food_item, quantity_needed: needed)
    end

    redirect_to list, notice: "Shopping list generated with #{list.shopping_list_items.count} items."
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

class ShoppingListItemsController < ApplicationController
  before_action :set_item
  before_action :set_food_items, only: [:update, :replace]

  def update
    was_checked = @item.checked_off
    @item.toggle!
    adjust_pantry(@item.food_item, @item.quantity_needed, checking_on: !was_checked)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "shopping_list_item_#{@item.id}",
          partial: "shopping_list_items/item",
          locals: { item: @item }
        )
      end
      format.html { redirect_to @item.shopping_list }
    end
  end

  def replace
    decrement_pantry(@item.food_item, @item.quantity_needed) if @item.checked_off
    @item.update!(
      food_item_id:    replace_params[:food_item_id],
      quantity_needed: [replace_params[:quantity_needed].to_i, 1].max,
      checked_off:     false
    )
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "shopping_list_item_#{@item.id}",
          partial: "shopping_list_items/item",
          locals: { item: @item.reload }
        )
      end
      format.html { redirect_to @item.shopping_list }
    end
  end

  private

  def set_item
    @item = ShoppingListItem.find(params[:id])
  end

  def set_food_items
    @food_items_grouped = FoodItem.active.ordered
                                  .group_by { |fi| fi.food_type.humanize }
                                  .transform_values { |items| items.map { |fi| [fi.name, fi.id] } }
  end

  def replace_params
    params.permit(:food_item_id, :quantity_needed)
  end

  def adjust_pantry(food_item, qty, checking_on:)
    pi = food_item.pantry_item
    return unless pi
    unit_sv = food_item.unit_servings&.to_f&.nonzero? || 1.0
    amount  = qty * unit_sv * food_item.servings_per_unit
    if checking_on
      pi.update!(servings_on_hand: pi.servings_on_hand + amount, last_restocked_at: Date.current)
    else
      pi.update!(servings_on_hand: [pi.servings_on_hand - amount, 0].max)
    end
  end

  def decrement_pantry(food_item, qty)
    adjust_pantry(food_item, qty, checking_on: false)
  end
end

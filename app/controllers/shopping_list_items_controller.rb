class ShoppingListItemsController < ApplicationController
  before_action :set_item

  def update
    @item.toggle!
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

  private

  def set_item
    @item = ShoppingListItem.find(params[:id])
  end
end

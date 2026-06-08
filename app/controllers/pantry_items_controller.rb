class PantryItemsController < ApplicationController
  before_action :set_pantry_item, only: [:update, :set_servings, :add_unit]

  def index
    @pantry_by_type = FoodItem.active
                               .includes(:pantry_item)
                               .ordered
                               .group_by(&:food_type)
  end

  def update
    if @pantry_item.update(pantry_item_params)
      redirect_to pantry_items_path, notice: "#{@pantry_item.food_item.name} updated."
    else
      redirect_to pantry_items_path, alert: "Could not update."
    end
  end

  def set_servings
    amount = [params[:amount].to_f, 0].max
    @pantry_item.set_servings!(amount)
    respond_with_turbo
  end

  def add_unit
    @pantry_item.add_unit!
    respond_with_turbo
  end

  private

  def set_pantry_item
    @pantry_item = PantryItem.find(params[:id])
  end

  def pantry_item_params
    params.require(:pantry_item).permit(:servings_on_hand, :min_servings)
  end

  def respond_with_turbo
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "pantry_item_#{@pantry_item.id}",
          partial: "pantry_items/pantry_item",
          locals: { pantry_item: @pantry_item }
        )
      end
      format.html { redirect_to pantry_items_path }
    end
  end
end

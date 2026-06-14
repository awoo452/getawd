class FoodItemsController < ApplicationController
  before_action :set_food_item, only: [:edit, :update, :destroy]

  def index
    @food_items_by_type = FoodItem::FOOD_TYPES.index_with do |type|
      FoodItem.where(food_type: type).order(:position, :name)
    end
  end

  def new
    @food_item = FoodItem.new(active: true, position: 0)
  end

  def create
    @food_item = FoodItem.new(food_item_params)
    if @food_item.save
      redirect_to food_items_path, notice: "#{@food_item.name} added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @food_item.build_pantry_item if @food_item.pantry_item.nil?
  end

  def update
    if @food_item.update(food_item_params)
      redirect_to food_items_path, notice: "#{@food_item.name} updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    name = @food_item.name
    @food_item.destroy
    redirect_to food_items_path, notice: "#{name} removed."
  end

  private

  def set_food_item
    @food_item = FoodItem.find(params[:id])
  end

  def food_item_params
    params.require(:food_item).permit(:name, :food_type, :location, :unit, :active, :position, :serving_size, :servings_per_unit, :unit_servings, :shelf_life_days, pantry_item_attributes: [:id, :min_servings])
  end
end

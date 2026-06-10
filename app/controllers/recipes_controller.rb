class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def index
    @meal_type_filter = params[:meal_type].presence
    recipes = Recipe.active.includes(recipe_ingredients: :food_item).ordered
    recipes = recipes.by_meal_type(@meal_type_filter) if @meal_type_filter
    @recipes_by_type = recipes.group_by(&:meal_type_suggestion)
  end

  def show
  end

  def new
    @recipe = Recipe.new(active: true, servings: 2)
    build_ingredient_rows
    @food_items_by_type = active_food_items_by_type
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if params[:add_ingredient].present?
      @recipe.recipe_ingredients.build
      @food_items_by_type = active_food_items_by_type
      render :new, status: :unprocessable_entity
      return
    end

    if @recipe.save
      redirect_to @recipe, notice: "#{@recipe.name} created."
    else
      build_ingredient_rows
      @food_items_by_type = active_food_items_by_type
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    build_ingredient_rows
    @food_items_by_type = active_food_items_by_type
  end

  def update
    if params[:add_ingredient].present?
      @recipe.assign_attributes(recipe_params)
      @recipe.recipe_ingredients.build
      @food_items_by_type = active_food_items_by_type
      render :edit, status: :unprocessable_entity
      return
    end

    if @recipe.update(recipe_params)
      redirect_to edit_recipe_path(@recipe), notice: "#{@recipe.name} updated."
    else
      build_ingredient_rows
      @food_items_by_type = active_food_items_by_type
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path, notice: "Recipe deleted."
  end

  private

  def set_recipe
    @recipe = Recipe.includes(recipe_ingredients: :food_item).find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(
      :name, :meal_type_suggestion, :servings, :active, :position,
      recipe_ingredients_attributes: [:id, :food_item_id, :quantity, :position, :_destroy]
    )
  end

  def active_food_items_by_type
    FoodItem::FOOD_TYPES.index_with do |type|
      FoodItem.active.by_type(type).order(:name).to_a
    end
  end

  def build_ingredient_rows
    @recipe.recipe_ingredients.build if @recipe.recipe_ingredients.none?(&:new_record?)
  end
end

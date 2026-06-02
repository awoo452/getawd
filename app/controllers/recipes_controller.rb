class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :cook]

  def index
    @meal_type_filter = params[:meal_type].presence
    recipes = Recipe.active.includes(recipe_ingredients: :food_item).ordered
    recipes = recipes.by_meal_type(@meal_type_filter) if @meal_type_filter
    @recipes_by_type = recipes.group_by(&:meal_type_suggestion)
  end

  def show
  end

  def cook
    ingredients = @recipe.recipe_ingredients.includes(food_item: :pantry_item)

    ingredients.each do |ri|
      ri.food_item.pantry_item&.decrement!(ri.quantity)
    end

    redirect_to @recipe, notice: "#{@recipe.name} cooked! Pantry updated."
  end

  private

  def set_recipe
    @recipe = Recipe.includes(recipe_ingredients: :food_item).find(params[:id])
  end
end

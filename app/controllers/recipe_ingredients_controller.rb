class RecipeIngredientsController < ApplicationController
  def destroy
    ingredient = RecipeIngredient.find(params[:id])
    ingredient.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("recipe_ingredient_#{params[:id]}") }
      format.html         { redirect_to edit_recipe_path(ingredient.recipe_id) }
    end
  end
end

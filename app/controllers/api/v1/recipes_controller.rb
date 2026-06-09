module Api
  module V1
    class RecipesController < Api::V1::ApplicationController
      def index
        recipes = Recipe.active.ordered
        render json: recipes.map { |r| { id: r.id, name: r.name, meal_type: r.meal_type, servings: r.servings } }
      end
    end
  end
end

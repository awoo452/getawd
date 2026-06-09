module Api
  module V1
    class DishesController < Api::V1::ApplicationController
      def consume
        recipe_id = params[:recipe_id].to_i
        return render json: { error: "recipe_id is required" }, status: :unprocessable_entity if recipe_id.zero?

        dish = PreparedDish.active.where(recipe_id: recipe_id)
                           .order(cooked_on: :asc, created_at: :asc).first
        dish&.consume_one!

        render json: { ok: true, found: dish.present? }
      end

      def restore
        recipe_id = params[:recipe_id].to_i
        return render json: { error: "recipe_id is required" }, status: :unprocessable_entity if recipe_id.zero?

        dish = PreparedDish.where(recipe_id: recipe_id)
                           .order(cooked_on: :desc, created_at: :desc).first
        dish&.increment!(:servings_remaining)

        render json: { ok: true, found: dish.present? }
      end
    end
  end
end

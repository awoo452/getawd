module Api
  module V1
    class DishesController < Api::V1::ApplicationController
      def consume
        recipe_id = params[:recipe_id].to_i
        return render json: { error: "recipe_id is required" }, status: :unprocessable_entity if recipe_id.zero?

        dish = PreparedDish.active.where(recipe_id: recipe_id)
                           .order(cooked_on: :asc, created_at: :asc).first
        dish&.consume_one!

        render json: { ok: true, found: dish.present?, dish_id: dish&.id }
      end

      def restore
        dish_id   = params[:dish_id].presence&.to_i
        recipe_id = params[:recipe_id].to_i

        dish = if dish_id&.positive?
          PreparedDish.find_by(id: dish_id)
        elsif recipe_id.positive?
          PreparedDish.where(recipe_id: recipe_id)
                      .order(cooked_on: :asc, created_at: :asc).first
        end

        return render json: { error: "dish_id or recipe_id is required" }, status: :unprocessable_entity unless dish || recipe_id.positive? || dish_id&.positive?

        dish&.increment!(:servings_remaining)

        render json: { ok: true, found: dish.present? }
      end
    end
  end
end

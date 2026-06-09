module Api
  module V1
    class PantryController < ApplicationController
      def index
        items = FoodItem.includes(:pantry_item).active.order(:food_type, :position, :name)
        render json: items.map { |fi| serialize_food_item(fi) }
      end

      def deduct
        ids = Array(params[:food_item_ids]).map(&:to_i).uniq
        return render json: { error: "food_item_ids is required" }, status: :unprocessable_entity if ids.empty?

        FoodItem.includes(:pantry_item).where(id: ids).each do |fi|
          fi.pantry_item&.decrement!(fi.servings_per_unit)
        end

        render json: { ok: true }
      end

      def restore
        ids = Array(params[:food_item_ids]).map(&:to_i).uniq
        return render json: { error: "food_item_ids is required" }, status: :unprocessable_entity if ids.empty?

        FoodItem.includes(:pantry_item).where(id: ids).each do |fi|
          fi.pantry_item&.increment!(fi.servings_per_unit)
        end

        render json: { ok: true }
      end

      private

      def serialize_food_item(fi)
        pi = fi.pantry_item
        {
          id:               fi.id,
          name:             fi.name,
          food_type:        fi.food_type,
          servings_on_hand: pi&.servings_on_hand,
          stock_status:     pi&.stock_status || "unknown"
        }
      end
    end
  end
end

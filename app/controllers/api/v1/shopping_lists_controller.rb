module Api
  module V1
    class ShoppingListsController < Api::V1::ApplicationController
      def submit
        items = Array(params[:items])
        return render json: { error: "items is required" }, status: :unprocessable_entity if items.empty?

        list = ShoppingList.create!(generated_on: Date.current, status: "active", label: "Ryder's Picks")
        items.each do |item|
          food_item_id = item[:food_item_id].to_i
          quantity     = [item[:quantity].to_i, 1].max
          next unless food_item_id > 0

          list.shopping_list_items.create!(food_item_id: food_item_id, quantity_needed: quantity)
        end

        render json: { ok: true, shopping_list_id: list.id }
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
  end
end

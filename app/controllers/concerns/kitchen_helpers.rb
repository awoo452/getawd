module KitchenHelpers
  extend ActiveSupport::Concern

  private

  def grouped_food_items
    FoodItem.active.ordered.group_by { |fi| fi.food_type.humanize }
            .transform_values { |items| items.map { |fi| [fi.name, fi.id] } }
  end
end

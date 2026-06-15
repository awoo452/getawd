class AddFoodTypeCheckConstraintToFoodItems < ActiveRecord::Migration[8.1]
  def change
    add_check_constraint :food_items,
      "food_type IN ('protein', 'vegetable', 'fruit', 'side', 'sauce', 'snack', 'dessert')",
      name: "food_type_valid_values"
  end
end

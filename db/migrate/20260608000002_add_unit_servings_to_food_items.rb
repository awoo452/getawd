class AddUnitServingsToFoodItems < ActiveRecord::Migration[8.1]
  def change
    add_column :food_items, :unit_servings, :decimal, precision: 6, scale: 2
  end
end

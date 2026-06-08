class ChangeServingsPerUnitToDecimal < ActiveRecord::Migration[8.1]
  def change
    change_column :food_items, :servings_per_unit, :decimal, precision: 8, scale: 2, default: 1, null: false
  end
end

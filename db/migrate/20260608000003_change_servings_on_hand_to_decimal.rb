class ChangeServingsOnHandToDecimal < ActiveRecord::Migration[8.1]
  def change
    change_column :pantry_items, :servings_on_hand, :decimal, precision: 8, scale: 2, default: 0, null: false
  end
end

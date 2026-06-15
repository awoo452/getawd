class RemoveStalePantryColumns < ActiveRecord::Migration[8.1]
  def change
    remove_column :pantry_items, :quantity_on_hand, :integer
    remove_column :pantry_items, :min_quantity, :integer
  end
end

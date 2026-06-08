class AddServingsTracking < ActiveRecord::Migration[8.1]
  def change
    add_column :food_items, :serving_size, :string
    add_column :food_items, :servings_per_unit, :integer, null: false, default: 1

    add_column :pantry_items, :servings_on_hand, :integer, null: false, default: 0
    add_column :pantry_items, :min_servings, :integer, null: false, default: 1

    reversible do |dir|
      dir.up do
        execute <<~SQL
          UPDATE pantry_items SET servings_on_hand = quantity_on_hand, min_servings = min_quantity
        SQL
      end
    end
  end
end

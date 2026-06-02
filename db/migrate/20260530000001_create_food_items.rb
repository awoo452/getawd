class CreateFoodItems < ActiveRecord::Migration[8.1]
  def change
    create_table :food_items do |t|
      t.string  :name,      null: false
      t.string  :food_type, null: false
      t.string  :location,  null: false
      t.string  :unit,      null: false, default: "each"
      t.boolean :active,    null: false, default: true
      t.integer :position,  null: false, default: 0
      t.timestamps
    end

    add_index :food_items, :food_type
    add_index :food_items, :location
    add_index :food_items, [:active, :position]
  end
end

class CreatePantryItems < ActiveRecord::Migration[8.1]
  def change
    create_table :pantry_items do |t|
      t.references :food_item, null: false, foreign_key: true, index: { unique: true }
      t.integer :quantity_on_hand, null: false, default: 0
      t.integer :min_quantity,     null: false, default: 1
      t.date    :last_restocked_at
      t.timestamps
    end
  end
end

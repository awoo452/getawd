class CreateShoppingListItems < ActiveRecord::Migration[8.1]
  def change
    create_table :shopping_list_items do |t|
      t.references :shopping_list, null: false, foreign_key: true
      t.references :food_item,     null: false, foreign_key: true
      t.integer    :quantity_needed, null: false, default: 1
      t.boolean    :checked_off,     null: false, default: false
      t.timestamps
    end

    add_index :shopping_list_items, [:shopping_list_id, :food_item_id], unique: true
  end
end

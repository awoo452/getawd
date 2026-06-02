class CreateShoppingLists < ActiveRecord::Migration[8.1]
  def change
    create_table :shopping_lists do |t|
      t.string :status,       null: false, default: "active"
      t.date   :generated_on, null: false
      t.timestamps
    end

    add_index :shopping_lists, :status
  end
end

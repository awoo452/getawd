class AddLabelToShoppingLists < ActiveRecord::Migration[8.1]
  def change
    add_column :shopping_lists, :label, :string
  end
end

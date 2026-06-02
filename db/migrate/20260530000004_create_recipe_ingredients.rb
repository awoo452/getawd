class CreateRecipeIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :recipe_ingredients do |t|
      t.references :recipe,     null: false, foreign_key: true
      t.references :food_item,  null: false, foreign_key: true
      t.integer    :quantity,   null: false, default: 1
      t.string     :slot_type
      t.integer    :position,   null: false, default: 0
      t.timestamps
    end

    add_index :recipe_ingredients, [:recipe_id, :food_item_id], unique: true
  end
end

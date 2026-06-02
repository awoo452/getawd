class CreateRecipes < ActiveRecord::Migration[8.1]
  def change
    create_table :recipes do |t|
      t.string  :name,                null: false
      t.string  :meal_type_suggestion
      t.integer :servings,            null: false, default: 2
      t.boolean :active,              null: false, default: true
      t.integer :position,            null: false, default: 0
      t.timestamps
    end

    add_index :recipes, :meal_type_suggestion
    add_index :recipes, :active
  end
end

class CreatePreparedDishes < ActiveRecord::Migration[8.1]
  def change
    create_table :prepared_dishes do |t|
      t.string  :name,               null: false
      t.integer :servings_remaining, null: false, default: 1
      t.date    :cooked_on,          null: false
      t.bigint  :recipe_id
      t.bigint  :meal_plan_id

      t.timestamps
    end

    add_index :prepared_dishes, :recipe_id
    add_index :prepared_dishes, :meal_plan_id
    add_index :prepared_dishes, :cooked_on
  end
end

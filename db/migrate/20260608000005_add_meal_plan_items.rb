class AddMealPlanItems < ActiveRecord::Migration[8.1]
  def change
    change_column_null :meal_plans, :recipe_id, true

    create_table :meal_plan_items do |t|
      t.references :meal_plan, null: false, foreign_key: true
      t.references :food_item,  null: false, foreign_key: true
      t.integer :position, default: 1, null: false
      t.timestamps
    end
  end
end

class AddQuantityToMealPlanItems < ActiveRecord::Migration[8.1]
  def change
    add_column :meal_plan_items, :quantity, :integer, default: 1, null: false
  end
end

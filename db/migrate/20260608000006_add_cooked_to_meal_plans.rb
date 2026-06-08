class AddCookedToMealPlans < ActiveRecord::Migration[8.1]
  def change
    add_column :meal_plans, :cooked, :boolean, default: false, null: false
  end
end

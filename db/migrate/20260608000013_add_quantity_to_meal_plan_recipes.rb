class AddQuantityToMealPlanRecipes < ActiveRecord::Migration[8.0]
  def change
    add_column :meal_plan_recipes, :quantity, :integer, default: 1, null: false
  end
end

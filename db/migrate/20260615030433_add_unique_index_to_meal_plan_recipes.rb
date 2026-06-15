class AddUniqueIndexToMealPlanRecipes < ActiveRecord::Migration[8.1]
  def change
    add_index :meal_plan_recipes, [:meal_plan_id, :recipe_id], unique: true
  end
end

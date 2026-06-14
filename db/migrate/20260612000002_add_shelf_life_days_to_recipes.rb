class AddShelfLifeDaysToRecipes < ActiveRecord::Migration[8.0]
  def change
    add_column :recipes, :shelf_life_days, :integer
  end
end

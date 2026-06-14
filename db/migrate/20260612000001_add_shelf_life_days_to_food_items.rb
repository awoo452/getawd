class AddShelfLifeDaysToFoodItems < ActiveRecord::Migration[8.0]
  def change
    add_column :food_items, :shelf_life_days, :integer
  end
end

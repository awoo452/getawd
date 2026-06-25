class RenameCupboardToPantryInFoodItems < ActiveRecord::Migration[8.1]
  def up
    execute "UPDATE food_items SET location = 'pantry' WHERE location = 'cupboard'"
  end

  def down
    execute "UPDATE food_items SET location = 'cupboard' WHERE location = 'pantry'"
  end
end

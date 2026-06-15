class DropMealsTable < ActiveRecord::Migration[8.1]
  def up
    drop_table :meals
  end

  def down
    create_table :meals do |t|
      t.string  :title,              null: false
      t.text    :description
      t.text    :ingredients
      t.text    :instructions
      t.string  :image
      t.string  :secondary_image
      t.string  :source_url
      t.integer :servings
      t.integer :calories_per_serving
      t.integer :total_time_minutes
      t.timestamps
    end
  end
end

class AddShelfLifeDaysToPreparedDishes < ActiveRecord::Migration[8.0]
  def change
    add_column :prepared_dishes, :shelf_life_days, :integer
  end
end

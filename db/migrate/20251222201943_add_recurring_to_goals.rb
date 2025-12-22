class AddRecurringToGoals < ActiveRecord::Migration[7.1]
  def change
    add_column :goals, :recurring, :boolean, default: false
  end
end

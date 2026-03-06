class RemoveRecurringFromGoals < ActiveRecord::Migration[8.1]
  def change
    remove_column :goals, :recurring, :boolean if column_exists?(:goals, :recurring)
  end
end

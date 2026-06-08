class AddNotesAndCompletedToWorkoutPlans < ActiveRecord::Migration[8.1]
  def change
    add_column :workout_plans, :notes,     :text
    add_column :workout_plans, :completed, :boolean, default: false, null: false
  end
end

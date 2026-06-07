class CreateWorkoutPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_plans do |t|
      t.date    :planned_on,   null: false
      t.integer :workout_type, null: false
      t.references :task, foreign_key: { on_delete: :nullify }
      t.timestamps
    end

    add_index :workout_plans, :planned_on, unique: true
  end
end

class CreateMealPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :meal_plans do |t|
      t.date    :planned_on, null: false
      t.integer :meal_slot,  null: false
      t.references :recipe, null: false, foreign_key: true
      t.references :task,   foreign_key: { on_delete: :nullify }
      t.timestamps
    end

    add_index :meal_plans, [:planned_on, :meal_slot], unique: true
  end
end

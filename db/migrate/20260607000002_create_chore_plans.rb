class CreateChorePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :chore_plans do |t|
      t.date    :planned_on, null: false
      t.integer :chore_type, null: false
      t.references :task, foreign_key: { on_delete: :nullify }
      t.timestamps
    end

    add_index :chore_plans, [:planned_on, :chore_type], unique: true
  end
end

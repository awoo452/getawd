class CreateEatLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :eat_logs do |t|
      t.date    :date,             null: false
      t.string  :meal_slot,        null: false
      t.string  :description
      t.bigint  :prepared_dish_id
      t.boolean :eaten,            null: false, default: false

      t.timestamps
    end

    add_index :eat_logs, :date
    add_index :eat_logs, :prepared_dish_id
  end
end

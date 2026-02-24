class CreateServices < ActiveRecord::Migration[8.1]
  def change
    create_table :services do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :category
      t.string :image
      t.string :url
      t.boolean :featured, default: false, null: false
      t.integer :position, default: 0, null: false

      t.timestamps
    end
  end
end

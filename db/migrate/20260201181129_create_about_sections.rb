class CreateAboutSections < ActiveRecord::Migration[8.1]
    def change
    create_table :about_sections do |t|
      t.string :header, null: false
      t.text :body, null: false
      t.integer :position, null: false
      t.timestamps
    end

    add_index :about_sections, :position, unique: true
  end
end

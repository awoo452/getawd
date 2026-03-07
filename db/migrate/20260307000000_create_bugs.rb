class CreateBugs < ActiveRecord::Migration[8.1]
  def change
    create_table :bugs do |t|
      t.string  :title, null: false
      t.text    :body
      t.string  :section
      t.boolean :completed, default: false, null: false
      t.string  :commit_ref

      t.timestamps
    end
  end
end

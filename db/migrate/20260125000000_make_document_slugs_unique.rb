class MakeDocumentSlugsUnique < ActiveRecord::Migration[7.1]
  def change
    remove_index :documents, :slug
    add_index :documents, :slug, unique: true
  end
end

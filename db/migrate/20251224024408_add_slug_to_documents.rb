class AddSlugToDocuments < ActiveRecord::Migration[7.1]
  def change
    add_column :documents, :slug, :string
    add_index :documents, :slug
  end
end

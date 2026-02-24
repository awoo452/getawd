class AddServiceTypeToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :service_type, :string
    add_index :projects, :service_type
  end
end

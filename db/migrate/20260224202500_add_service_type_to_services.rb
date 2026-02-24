class AddServiceTypeToServices < ActiveRecord::Migration[8.1]
  def change
    add_column :services, :service_type, :string
    add_index :services, :service_type
  end
end

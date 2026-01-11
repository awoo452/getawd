class AddScopeToRewards < ActiveRecord::Migration[7.1]
  def change
    add_column :rewards, :scope, :string, null: false, default: "level"
    add_index :rewards, :scope
  end
end

class AddKindToRewards < ActiveRecord::Migration[7.1]
  def change
    add_column :rewards, :kind, :string
  end
end

class AddShowToPublicToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :show_to_public, :boolean, default: false
  end
end

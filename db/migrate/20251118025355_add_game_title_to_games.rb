class AddGameTitleToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :game_title, :string
  end
end

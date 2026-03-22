class ChangeGameNotesToJson < ActiveRecord::Migration[7.1]
  def change
    change_column :games, :game_notes, 'json', using: 'game_notes::json', default: []
  end
end

class AddProgressDataToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :progress_data, :jsonb, default: {}
  end
end
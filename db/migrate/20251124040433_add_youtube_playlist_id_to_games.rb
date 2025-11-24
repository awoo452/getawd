class AddYoutubePlaylistIdToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :youtube_playlist_id, :string
  end
end

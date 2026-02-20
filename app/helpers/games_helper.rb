module GamesHelper
  def game_image_key(game)
    "games/#{game.id}/#{game.game_image}"
  end

  def game_image_url(game)
    s3_url(game_image_key(game))
  end
end

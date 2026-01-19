module GamesHelper
  def game_image_url(game)
    s3_url(game.game_image)
  end
end
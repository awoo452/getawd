module GamesHelper
  def game_cover_url(game)
    "https://getawd-prod.s3.amazonaws.com/games/#{game.id}/game1.png"
  end
end
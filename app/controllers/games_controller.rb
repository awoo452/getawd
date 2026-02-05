class GamesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    data = Games::IndexData.call(paginator: method(:paginate))
    @games = data.games
    @games_page = data.games_page
    @games_total_pages = data.games_total_pages
  end

  def show
    @game = Game.find(params[:id])
  end
end

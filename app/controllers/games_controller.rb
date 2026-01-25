class GamesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    scope = Game.where(show_to_public: true).order(created_at: :desc)
    @games, @games_page, @games_total_pages = paginate(scope, per_page: 25)
  end

  def show
    @game = Game.find(params[:id])
  end
end

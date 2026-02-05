class BlackjackController < ApplicationController
  protect_from_forgery with: :exception

  def show
    blackjack_game.init_if_needed
  end

  def bet
    amount = params[:amount].to_i
    blackjack_game.bet(amount)
    redirect_to blackjack_path
  end

  def clear_bet
    blackjack_game.clear_bet
    redirect_to blackjack_path
  end

  def deal
    blackjack_game.deal
    redirect_to blackjack_path
  end

  def hit
    blackjack_game.hit
    redirect_to blackjack_path
  end

  def stand
    blackjack_game.stand
    redirect_to blackjack_path
  end

  def reset
    blackjack_game.reset
    redirect_to blackjack_path
  end

  def hard_reset
    reset_session
    redirect_to blackjack_path
  end

  private
  def blackjack_game
    @blackjack_game ||= Blackjack::Game.new(session)
  end
end

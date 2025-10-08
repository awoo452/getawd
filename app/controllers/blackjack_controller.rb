class BlackjackController < ApplicationController
  protect_from_forgery with: :exception

  def show
    init_game_if_needed
  end

  def bet
    init_game_if_needed
    amount = params[:amount].to_i
    return redirect_to blackjack_path if amount <= 0
    return redirect_to blackjack_path if session[:chips] < amount

    session[:bet] += amount
    session[:chips] -= amount
    redirect_to blackjack_path
  end

  def clear_bet
    session[:chips] += session[:bet]
    session[:bet] = 0
    redirect_to blackjack_path
  end

  def deal
    return redirect_to blackjack_path if session[:bet] <= 0

    reset_hands
    2.times { session[:player] << draw_card }
    2.times { session[:dealer] << draw_card }
    session[:state] = "player_turn"

    redirect_to blackjack_path
  end

  def hit
    return redirect_to blackjack_path unless session[:state] == "player_turn"

    session[:player] << draw_card
    if hand_value(session[:player]) > 21
      session[:state] = "player_bust"
      resolve_bet
    end
    redirect_to blackjack_path
  end

  def stand
    return redirect_to blackjack_path unless session[:state] == "player_turn"

    while hand_value(session[:dealer]) < 17
      session[:dealer] << draw_card
    end

    player_total = hand_value(session[:player])
    dealer_total = hand_value(session[:dealer])

    session[:state] =
      if dealer_total > 21
        "dealer_bust"
      elsif dealer_total > player_total
        "dealer_win"
      elsif dealer_total < player_total
        "player_win"
      else
        "push"
      end

    resolve_bet
    redirect_to blackjack_path
  end

  def reset
    reset_game
    redirect_to blackjack_path
  end

  def hard_reset
    reset_session
    redirect_to blackjack_path
  end

  private

  def init_game_if_needed
    session[:deck] ||= new_shuffled_deck
    session[:player] ||= []
    session[:dealer] ||= []
    session[:state] ||= "ready"
    session[:chips] ||= 100
    session[:bet] ||= 0
  end

  def reset_game
    session[:deck] = new_shuffled_deck
    session[:player] = []
    session[:dealer] = []
    session[:state] = "ready"
    session[:bet] = 0 if session[:chips] <= 0
  end

  def reset_hands
    session[:deck] = new_shuffled_deck
    session[:player] = []
    session[:dealer] = []
  end

  def resolve_bet
    bet = session[:bet]
    return if bet <= 0

    case session[:state]
    when "player_win"
      session[:chips] += bet * 2
    when "dealer_win", "player_bust"
      # already removed on bet
    when "dealer_bust"
      session[:chips] += bet * 2
    when "push"
      session[:chips] += bet
    end

    # blackjack payout 3:2
    if blackjack?(session[:player]) && session[:state] == "player_win"
      session[:chips] += (bet * 0.5).floor
    end

    session[:bet] = 0
  end

  def blackjack?(hand)
    hand_value(hand) == 21 && hand.length == 2
  end

  def new_shuffled_deck
    ranks = %w[2 3 4 5 6 7 8 9 10 J Q K A]
    suits = %w[♠ ♥ ♦ ♣]
    suits.product(ranks).map { |s, r| "#{r}#{s}" }.shuffle
  end

  def draw_card
    session[:deck] = new_shuffled_deck if session[:deck].empty?
    session[:deck].pop
  end

  def hand_value(cards)
    values = cards.map { |c| card_value(c) }
    total = values.sum
    aces = cards.count { |c| c.start_with?("A") }
    while total > 21 && aces.positive?
      total -= 10
      aces -= 1
    end
    total
  end

  def card_value(card)
    rank = card.gsub(/[♠♥♦♣]/, "")
    return 11 if rank == "A"
    return 10 if %w[J Q K].include?(rank)
    rank.to_i
  end
end

module BlackjackHelper
  def result_message(state)
    case state
    when "ready"        then "Place your bet"
    when "player_turn" then "Your turn"
    when "player_win"  then "You win"
    when "dealer_win"  then "Dealer wins"
    when "player_bust" then "You busted"
    when "dealer_bust" then "Dealer busted"
    when "push"        then "Push"
    else "Game in progress"
    end
  end

  def hand_total(cards)
    return 0 if cards.blank?

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

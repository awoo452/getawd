require "test_helper"

class Games::IndexDataTest < ActiveSupport::TestCase
  PAGINATOR = ->(scope, per_page:) { [scope.to_a, 1, 1] }

  test "returns without error" do
    assert_nothing_raised { Games::IndexData.call(paginator: PAGINATOR) }
  end

  test "only returns public games" do
    Game.create!(game_name: "Public Game", show_to_public: true)
    Game.create!(game_name: "Private Game", show_to_public: false)
    result = Games::IndexData.call(paginator: PAGINATOR)
    assert result.games.any?
    result.games.each { |g| assert g.show_to_public? }
  end
end

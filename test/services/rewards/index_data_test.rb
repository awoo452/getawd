require "test_helper"

class Rewards::IndexDataTest < ActiveSupport::TestCase
  PAGINATOR = ->(scope, per_page:) { [scope.to_a, 1, 1] }

  test "returns without error" do
    assert_nothing_raised { Rewards::IndexData.call(paginator: PAGINATOR) }
  end

  test "returns expected fields" do
    result = Rewards::IndexData.call(paginator: PAGINATOR)
    assert_respond_to result, :redeemed_levels
    assert_respond_to result, :earned_by_level
    assert_respond_to result, :task_rewards_today
    assert_respond_to result, :public_games
    assert_respond_to result, :rewards
  end
end

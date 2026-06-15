require "test_helper"

class KitchenHelpersTest < ActionDispatch::IntegrationTest
  test "food item names appear in meal planner item selects" do
    get kitchen_url
    assert_select "select[name='food_item_id'] option", text: "Bacon"
    assert_select "select[name='food_item_id'] option", text: "Bread"
  end

  test "inactive food items are excluded from meal planner item selects" do
    food_items(:bacon).update!(active: false)
    get kitchen_url
    assert_select "select[name='food_item_id'] option", text: "Bacon", count: 0
  end
end

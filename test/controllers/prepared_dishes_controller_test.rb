require "test_helper"

class PreparedDishesControllerTest < ActionDispatch::IntegrationTest
  test "destroy removes the dish" do
    dish = prepared_dishes(:scrambled_eggs_batch)
    assert_difference "PreparedDish.count", -1 do
      delete prepared_dish_path(dish), as: :turbo_stream
    end
    assert_response :ok
  end

  test "destroy via html redirects to kitchen" do
    dish = prepared_dishes(:empty_dish)
    delete prepared_dish_path(dish)
    assert_redirected_to kitchen_path
  end
end

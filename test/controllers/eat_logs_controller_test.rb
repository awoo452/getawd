require "test_helper"

class EatLogsControllerTest < ActionDispatch::IntegrationTest
  test "create with prepared dish marks eaten and decrements serving" do
    dish = prepared_dishes(:scrambled_eggs_batch)
    before = dish.servings_remaining
    assert_difference "EatLog.count", 1 do
      post eat_logs_path,
           params: { eat_log: { date: "2026-06-09", meal_slot: "breakfast", prepared_dish_id: dish.id } },
           as: :turbo_stream
    end
    assert_response :ok
    log = EatLog.last
    assert log.eaten?
    assert_equal dish.id, log.prepared_dish_id
    assert_equal before - 1, dish.reload.servings_remaining
  end

  test "create with free text marks eaten" do
    assert_difference "EatLog.count", 1 do
      post eat_logs_path,
           params: { eat_log: { date: "2026-06-09", meal_slot: "lunch", description: "Toast" } },
           as: :turbo_stream
    end
    assert_response :ok
    log = EatLog.last
    assert_equal "Toast", log.description
    assert log.eaten?
  end

  test "create without dish or description redirects with alert" do
    assert_no_difference "EatLog.count" do
      post eat_logs_path,
           params: { eat_log: { date: "2026-06-09", meal_slot: "dinner" } }
    end
    assert_redirected_to kitchen_path
  end

  test "destroy removes the log" do
    log = eat_logs(:free_text)
    assert_difference "EatLog.count", -1 do
      delete eat_log_path(log), as: :turbo_stream
    end
    assert_response :ok
  end

  test "toggle_eaten marks as eaten and decrements dish" do
    log = eat_logs(:linked)
    dish = log.prepared_dish
    before = dish.servings_remaining

    patch toggle_eaten_eat_log_path(log), as: :turbo_stream
    assert_response :ok

    assert log.reload.eaten?
    assert_equal before - 1, dish.reload.servings_remaining
  end

  test "toggle_eaten unmarks eaten and restores serving when dish linked" do
    log = eat_logs(:linked)
    log.update!(eaten: true)
    dish = log.prepared_dish
    before = dish.servings_remaining

    patch toggle_eaten_eat_log_path(log), as: :turbo_stream
    assert_response :ok
    assert_not log.reload.eaten?
    assert_equal before + 1, dish.reload.servings_remaining
  end

  test "toggle_eaten unmarks eaten with no dish" do
    log = eat_logs(:eaten_log)
    patch toggle_eaten_eat_log_path(log), as: :turbo_stream
    assert_response :ok
    assert_not log.reload.eaten?
  end
end

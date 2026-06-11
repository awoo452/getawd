require "test_helper"

class Api::V1::DishesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @token = "test-secret-token"
    ENV["GETAWD_API_TOKEN"] = @token
    @recipe = Recipe.create!(name: "Chili", servings: 2, meal_type_suggestion: "dinner", active: true)
  end

  teardown do
    ENV.delete("GETAWD_API_TOKEN")
  end

  def auth_headers
    { "Authorization" => "Bearer #{@token}" }
  end

  # ── Consume ──────────────────────────────────────────────

  test "consume decrements the oldest active dish" do
    old_dish = PreparedDish.create!(name: "Chili", recipe: @recipe, servings_remaining: 2, cooked_on: 3.days.ago)
    new_dish = PreparedDish.create!(name: "Chili", recipe: @recipe, servings_remaining: 2, cooked_on: 1.day.ago)

    post consume_api_v1_dishes_path,
         params: { recipe_id: @recipe.id },
         headers: auth_headers, as: :json

    assert_equal 1, old_dish.reload.servings_remaining
    assert_equal 2, new_dish.reload.servings_remaining
  end

  test "consume returns dish_id in response" do
    dish = PreparedDish.create!(name: "Chili", recipe: @recipe, servings_remaining: 1, cooked_on: 1.day.ago)

    post consume_api_v1_dishes_path,
         params: { recipe_id: @recipe.id },
         headers: auth_headers, as: :json

    assert_equal dish.id, response.parsed_body["dish_id"]
  end

  test "consume returns nil dish_id when no active dish" do
    post consume_api_v1_dishes_path,
         params: { recipe_id: @recipe.id },
         headers: auth_headers, as: :json

    assert_nil response.parsed_body["dish_id"]
  end

  test "consume is a no-op when no active dish exists" do
    PreparedDish.create!(name: "Chili", recipe: @recipe, servings_remaining: 0, cooked_on: 1.day.ago)

    assert_nothing_raised do
      post consume_api_v1_dishes_path,
           params: { recipe_id: @recipe.id },
           headers: auth_headers, as: :json
    end
    assert_response :ok
  end

  # ── Restore ──────────────────────────────────────────────

  test "restore by dish_id increments the exact dish" do
    dish_a = PreparedDish.create!(name: "Chili", recipe: @recipe, servings_remaining: 0, cooked_on: 3.days.ago)
    dish_b = PreparedDish.create!(name: "Chili", recipe: @recipe, servings_remaining: 1, cooked_on: 1.day.ago)

    post restore_api_v1_dishes_path,
         params: { dish_id: dish_a.id },
         headers: auth_headers, as: :json

    assert_equal 1, dish_a.reload.servings_remaining, "should restore the specified dish"
    assert_equal 1, dish_b.reload.servings_remaining, "should not touch the other dish"
  end

  test "restore by dish_id does not inflate a newly-cooked dish" do
    dish_a = PreparedDish.create!(name: "Chili", recipe: @recipe, servings_remaining: 0, cooked_on: 3.days.ago)
    dish_b = PreparedDish.create!(name: "Chili", recipe: @recipe, servings_remaining: 1, cooked_on: 1.day.ago)

    post restore_api_v1_dishes_path,
         params: { dish_id: dish_a.id },
         headers: auth_headers, as: :json

    assert_equal 1, dish_b.reload.servings_remaining, "should not inflate the freshly-cooked dish"
  end

  test "restore falls back to oldest-first when no dish_id given" do
    old_dish = PreparedDish.create!(name: "Chili", recipe: @recipe, servings_remaining: 0, cooked_on: 3.days.ago)
    new_dish = PreparedDish.create!(name: "Chili", recipe: @recipe, servings_remaining: 1, cooked_on: 1.day.ago)

    post restore_api_v1_dishes_path,
         params: { recipe_id: @recipe.id },
         headers: auth_headers, as: :json

    assert_equal 1, old_dish.reload.servings_remaining
    assert_equal 1, new_dish.reload.servings_remaining
  end

  test "restore is a no-op when no dish exists for recipe" do
    assert_nothing_raised do
      post restore_api_v1_dishes_path,
           params: { recipe_id: @recipe.id },
           headers: auth_headers, as: :json
    end
    assert_response :ok
  end
end

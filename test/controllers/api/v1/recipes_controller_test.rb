require "test_helper"

class Api::V1::RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @token = "test-api-token"
    ENV["GETAWD_API_TOKEN"] = @token
  end

  teardown do
    ENV.delete("GETAWD_API_TOKEN")
  end

  def auth_headers
    { "Authorization" => "Bearer #{@token}" }
  end

  test "index returns active recipes as JSON" do
    get api_v1_recipes_path, headers: auth_headers, as: :json
    assert_response :ok
    body = response.parsed_body
    assert body.is_a?(Array)
    names = body.map { |r| r["name"] }
    assert_includes names, recipes(:breakfast_recipe).name
    assert_includes names, recipes(:dinner_recipe).name
  end

  test "index response includes id, name, meal_type, and servings fields" do
    get api_v1_recipes_path, headers: auth_headers, as: :json
    recipe = response.parsed_body.first
    assert recipe.key?("id")
    assert recipe.key?("name")
    assert recipe.key?("meal_type")
    assert recipe.key?("servings")
  end

  test "index returns 401 without an authorization token" do
    get api_v1_recipes_path, as: :json
    assert_response :unauthorized
  end

  test "index returns 401 with a wrong token" do
    get api_v1_recipes_path,
        headers: { "Authorization" => "Bearer wrong-token" },
        as: :json
    assert_response :unauthorized
  end
end

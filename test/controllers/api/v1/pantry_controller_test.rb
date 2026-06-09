require "test_helper"

class Api::V1::PantryControllerTest < ActionDispatch::IntegrationTest
  setup do
    @token = "test-secret-token"
    ENV["GETAWD_API_TOKEN"] = @token
  end

  teardown do
    ENV.delete("GETAWD_API_TOKEN")
  end

  # ── Auth ────────────────────────────────────────────────

  test "index returns 401 without token" do
    get api_v1_pantry_index_path, as: :json
    assert_response :unauthorized
  end

  test "index returns 401 with wrong token" do
    get api_v1_pantry_index_path,
        headers: { "Authorization" => "Bearer wrong-token" },
        as: :json
    assert_response :unauthorized
  end

  test "index returns 401 when GETAWD_API_TOKEN env is blank" do
    ENV.delete("GETAWD_API_TOKEN")
    get api_v1_pantry_index_path,
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json
    assert_response :unauthorized
  end

  # ── Index ────────────────────────────────────────────────

  test "index returns food items as JSON" do
    get api_v1_pantry_index_path,
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json
    assert_response :ok
    body = response.parsed_body
    assert_instance_of Array, body
  end

  test "index response includes expected keys" do
    get api_v1_pantry_index_path,
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json
    item = response.parsed_body.first
    assert_not_nil item
    %w[id name food_type stock_status].each do |key|
      assert item.key?(key), "Expected key '#{key}' in response"
    end
  end

  test "index includes pantry stock status for items with a pantry_item" do
    get api_v1_pantry_index_path,
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json
    eggs = response.parsed_body.find { |i| i["name"] == "Eggs" }
    assert_not_nil eggs
    assert_includes %w[ok low out], eggs["stock_status"]
    assert_not_nil eggs["servings_on_hand"]
  end

  # ── Deduct ──────────────────────────────────────────────

  test "deduct returns 401 without token" do
    post deduct_api_v1_pantry_index_path, as: :json
    assert_response :unauthorized
  end

  test "deduct returns 422 when food_item_ids is missing" do
    post deduct_api_v1_pantry_index_path,
         headers: { "Authorization" => "Bearer #{@token}" },
         as: :json
    assert_response :unprocessable_entity
  end

  test "deduct decrements servings_on_hand by servings_per_unit" do
    fi = food_items(:eggs)
    before = fi.pantry_item.servings_on_hand

    post deduct_api_v1_pantry_index_path,
         params: { food_item_ids: [fi.id] },
         headers: { "Authorization" => "Bearer #{@token}" },
         as: :json

    assert_response :ok
    assert_equal({ "ok" => true }, response.parsed_body)
    assert_equal before - fi.servings_per_unit, fi.pantry_item.reload.servings_on_hand
  end

  test "deduct ignores food_item_ids with no pantry_item" do
    fi = food_items(:eggs)
    fi.pantry_item.destroy

    assert_nothing_raised do
      post deduct_api_v1_pantry_index_path,
           params: { food_item_ids: [fi.id] },
           headers: { "Authorization" => "Bearer #{@token}" },
           as: :json
    end
    assert_response :ok
  end

  test "deduct does not go below zero" do
    fi = food_items(:eggs)
    fi.pantry_item.update!(servings_on_hand: 0)

    post deduct_api_v1_pantry_index_path,
         params: { food_item_ids: [fi.id] },
         headers: { "Authorization" => "Bearer #{@token}" },
         as: :json

    assert_response :ok
    assert_equal 0, fi.pantry_item.reload.servings_on_hand
  end

  test "index returns unknown stock_status for items without pantry_item" do
    fi = food_items(:eggs)
    fi.pantry_item&.destroy

    get api_v1_pantry_index_path,
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json
    eggs = response.parsed_body.find { |i| i["id"] == fi.id }
    assert_equal "unknown", eggs["stock_status"]
    assert_nil eggs["servings_on_hand"]
  end
end

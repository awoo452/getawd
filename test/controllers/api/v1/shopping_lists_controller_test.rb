require "test_helper"

class Api::V1::ShoppingListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @token = "test-secret-token"
    ENV["GETAWD_API_TOKEN"] = @token
    @eggs  = food_items(:eggs)
    @bacon = food_items(:bacon)
  end

  teardown do
    ENV.delete("GETAWD_API_TOKEN")
  end

  def api_submit(params, token: @token)
    post submit_api_v1_shopping_lists_path,
         params: params,
         headers: { "Authorization" => "Bearer #{token}" },
         as: :json
  end

  # ── Auth ────────────────────────────────────────────────

  test "returns 401 without token" do
    post submit_api_v1_shopping_lists_path, as: :json
    assert_response :unauthorized
  end

  test "returns 401 with wrong token" do
    api_submit({ items: [] }, token: "wrong")
    assert_response :unauthorized
  end

  # ── Validation ──────────────────────────────────────────

  test "returns 422 when items param is missing" do
    api_submit({})
    assert_response :unprocessable_entity
  end

  test "returns 422 when items is empty" do
    api_submit({ items: [] })
    assert_response :unprocessable_entity
  end

  # ── Submit ──────────────────────────────────────────────

  test "creates a new active shopping list" do
    assert_difference "ShoppingList.count" do
      api_submit({ items: [{ food_item_id: @eggs.id, quantity: 2 }] })
    end
    assert_response :ok
    assert ShoppingList.active.exists?
  end

  test "returns ok true and shopping_list_id" do
    api_submit({ items: [{ food_item_id: @eggs.id, quantity: 1 }] })
    body = response.parsed_body
    assert_equal true, body["ok"]
    assert_not_nil body["shopping_list_id"]
  end

  test "creates shopping list items with correct food_item_id and quantity_needed" do
    api_submit({ items: [
      { food_item_id: @eggs.id,  quantity: 3 },
      { food_item_id: @bacon.id, quantity: 1 }
    ] })
    assert_response :ok
    list = ShoppingList.find(response.parsed_body["shopping_list_id"])
    eggs_item  = list.shopping_list_items.find_by(food_item_id: @eggs.id)
    bacon_item = list.shopping_list_items.find_by(food_item_id: @bacon.id)
    assert_not_nil eggs_item
    assert_equal 3, eggs_item.quantity_needed
    assert_not_nil bacon_item
    assert_equal 1, bacon_item.quantity_needed
  end

  test "archives the existing active list before creating a new one" do
    existing = shopping_lists(:active_list)
    assert existing.active?

    api_submit({ items: [{ food_item_id: @eggs.id, quantity: 1 }] })
    assert_response :ok

    assert_equal "archived", existing.reload.status
    assert_equal 1, ShoppingList.active.count
  end

  test "clamps quantity to 1 when zero is sent" do
    api_submit({ items: [{ food_item_id: @eggs.id, quantity: 0 }] })
    assert_response :ok
    list = ShoppingList.find(response.parsed_body["shopping_list_id"])
    assert_equal 1, list.shopping_list_items.first.quantity_needed
  end

  test "skips items with food_item_id of zero" do
    api_submit({ items: [{ food_item_id: 0, quantity: 2 }] })
    assert_response :ok
    list = ShoppingList.find(response.parsed_body["shopping_list_id"])
    assert_empty list.shopping_list_items
  end
end

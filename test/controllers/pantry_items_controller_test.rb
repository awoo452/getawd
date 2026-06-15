require "test_helper"

class PantryItemsControllerTest < ActionDispatch::IntegrationTest
  # ── index ────────────────────────────────────────────────────
  test "index is successful" do
    get pantry_items_path
    assert_response :success
  end

  # ── update ───────────────────────────────────────────────────
  test "update via turbo_stream replaces the pantry_item partial" do
    pi = pantry_items(:eggs_pantry)
    patch pantry_item_path(pi),
          params: { pantry_item: { servings_on_hand: 12.0, min_servings: 3 } },
          as: :turbo_stream
    assert_response :ok
    assert_match "pantry_item_#{pi.id}", response.body
    assert_equal 12.0, pi.reload.servings_on_hand
    assert_equal 3,    pi.reload.min_servings
  end

  test "update via html redirects to pantry_items_path" do
    pi = pantry_items(:eggs_pantry)
    patch pantry_item_path(pi),
          params: { pantry_item: { servings_on_hand: 5.0, min_servings: 1 } }
    assert_redirected_to pantry_items_path
  end

  test "update with invalid params redirects with alert" do
    pi = pantry_items(:eggs_pantry)
    patch pantry_item_path(pi),
          params: { pantry_item: { servings_on_hand: 5.0, min_servings: -1 } },
          as: :turbo_stream
    assert_redirected_to pantry_items_path
    assert_match /Could not update/, flash[:alert]
  end

  # ── set_servings ─────────────────────────────────────────────
  test "set_servings sets the servings amount" do
    pi = pantry_items(:eggs_pantry)
    patch set_servings_pantry_item_path(pi), params: { amount: 8.0 }, as: :turbo_stream
    assert_response :ok
    assert_equal 8.0, pi.reload.servings_on_hand
  end

  test "set_servings does not go below zero" do
    pi = pantry_items(:eggs_pantry)
    patch set_servings_pantry_item_path(pi), params: { amount: -5.0 }, as: :turbo_stream
    assert_response :ok
    assert_equal 0, pi.reload.servings_on_hand
  end

  # ── add_unit ─────────────────────────────────────────────────
  test "add_unit increases servings by unit_servings * servings_per_unit" do
    pi = pantry_items(:bread_pantry)  # unit_servings: 20, servings_per_unit: 1.0
    before = pi.servings_on_hand
    patch add_unit_pantry_item_path(pi), as: :turbo_stream
    assert_response :ok
    assert_equal before + 20.0, pi.reload.servings_on_hand
  end
end

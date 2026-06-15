require "test_helper"

class ShoppingListsControllerTest < ActionDispatch::IntegrationTest
  test "index is successful" do
    get shopping_lists_path
    assert_response :success
  end

  test "show renders the list with items" do
    get shopping_list_path(shopping_lists(:active_list))
    assert_response :success
    assert_select "li#shopping_list_item_#{shopping_list_items(:unchecked_item).id}"
    assert_select "li#shopping_list_item_#{shopping_list_items(:checked_item).id}"
  end

  test "create redirects to existing active list" do
    assert_no_difference "ShoppingList.count" do
      post shopping_lists_path
    end
    assert_redirected_to shopping_lists(:active_list)
    assert_match /already have an active/, flash[:notice]
  end

  test "create generates list when pantry items are low" do
    shopping_lists(:active_list).archive!
    pantry_items(:eggs_pantry).update!(servings_on_hand: 0)

    assert_difference "ShoppingList.count", 1 do
      post shopping_lists_path
    end
    assert_redirected_to ShoppingList.last
    assert_match /Shopping list generated/, flash[:notice]
    assert ShoppingList.last.shopping_list_items.any?
  end

  test "create alerts when nothing is needed" do
    shopping_lists(:active_list).archive!

    assert_no_difference "ShoppingList.count" do
      post shopping_lists_path
    end
    assert_redirected_to shopping_lists_path
    assert_match /Nothing needed/, flash[:alert]
  end

  test "destroy deletes the list" do
    assert_difference "ShoppingList.count", -1 do
      delete shopping_list_path(shopping_lists(:archived_list))
    end
    assert_redirected_to shopping_lists_path
  end

  test "archive marks list as archived" do
    list = shopping_lists(:active_list)
    patch archive_shopping_list_path(list)
    assert_redirected_to shopping_lists_path
    assert_equal "archived", list.reload.status
  end
end

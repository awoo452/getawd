require "test_helper"

class RecipeIngredientsControllerTest < ActionDispatch::IntegrationTest
  test "destroy removes the ingredient and redirects to recipe edit" do
    ri = recipe_ingredients(:eggs_in_breakfast)
    assert_difference "RecipeIngredient.count", -1 do
      delete recipe_ingredient_url(ri)
    end
    assert_redirected_to edit_recipe_path(ri.recipe_id)
  end

  test "destroy with turbo stream accept returns turbo remove" do
    ri = recipe_ingredients(:eggs_in_breakfast)
    delete recipe_ingredient_url(ri), headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_match "remove", response.body
    assert_match "recipe_ingredient_#{ri.id}", response.body
  end
end

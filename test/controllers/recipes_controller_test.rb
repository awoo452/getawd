require "test_helper"

class RecipesControllerTest < ActionDispatch::IntegrationTest
  def valid_params(name: "Chicken Stir Fry")
    { recipe: { name: name, meal_type_suggestion: "dinner",
                servings: 2, active: true, position: 0 } }
  end

  # ── index ────────────────────────────────────────────────────
  test "index is successful" do
    get recipes_path
    assert_response :success
  end

  test "index filtered by meal_type is successful" do
    get recipes_filter_path("breakfast")
    assert_response :success
  end

  # ── show ─────────────────────────────────────────────────────
  test "show is successful" do
    get recipe_path(recipes(:breakfast_recipe))
    assert_response :success
  end

  # ── new ──────────────────────────────────────────────────────
  test "new is successful" do
    get new_recipe_path
    assert_response :success
  end

  # ── create ───────────────────────────────────────────────────
  test "create saves a recipe and redirects to show" do
    assert_difference "Recipe.count", 1 do
      post recipes_path, params: valid_params
    end
    assert_redirected_to recipe_path(Recipe.last)
    assert_match /created/, flash[:notice]
  end

  test "create with invalid params renders new with 422" do
    post recipes_path, params: { recipe: { name: "", servings: 0 } }
    assert_response :unprocessable_entity
  end

  test "create with add_ingredient param renders new without saving" do
    assert_no_difference "Recipe.count" do
      post recipes_path, params: valid_params.merge(add_ingredient: "1")
    end
    assert_response :unprocessable_entity
  end

  # ── edit ─────────────────────────────────────────────────────
  test "edit is successful" do
    get edit_recipe_path(recipes(:breakfast_recipe))
    assert_response :success
  end

  # ── update ───────────────────────────────────────────────────
  test "update with valid params redirects to show" do
    patch recipe_path(recipes(:breakfast_recipe)),
          params: { recipe: { name: "Fluffy Scrambled Eggs" } }
    assert_redirected_to recipe_path(recipes(:breakfast_recipe))
    assert_equal "Fluffy Scrambled Eggs", recipes(:breakfast_recipe).reload.name
  end

  test "update with invalid params renders edit with 422" do
    patch recipe_path(recipes(:breakfast_recipe)),
          params: { recipe: { name: "", servings: 0 } }
    assert_response :unprocessable_entity
  end

  test "update with add_ingredient param renders edit without saving" do
    patch recipe_path(recipes(:breakfast_recipe)),
          params: { recipe: { name: "Scrambled Eggs" }, add_ingredient: "1" }
    assert_response :unprocessable_entity
    assert_equal "Scrambled Eggs", recipes(:breakfast_recipe).reload.name
  end

  test "update with remove_ingredient param renders edit without saving" do
    ri = recipe_ingredients(:eggs_in_breakfast)
    patch recipe_path(recipes(:breakfast_recipe)),
          params: { recipe: { name: "Scrambled Eggs" }, remove_ingredient: { ri.id => "1" } }
    assert_response :unprocessable_entity
  end

  # ── destroy ──────────────────────────────────────────────────
  test "destroy removes the recipe and redirects" do
    assert_difference "Recipe.count", -1 do
      delete recipe_path(recipes(:dinner_recipe))
    end
    assert_redirected_to recipes_path
    assert_match /deleted/, flash[:notice]
  end

  test "destroy fails and alerts when recipe is on a meal plan" do
    assert_no_difference "Recipe.count" do
      delete recipe_path(recipes(:breakfast_recipe))
    end
    assert_redirected_to recipes_path
    assert_match /can't be deleted/, flash[:alert]
  end
end

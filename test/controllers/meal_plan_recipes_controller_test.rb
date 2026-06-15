require "test_helper"

class MealPlanRecipesControllerTest < ActionDispatch::IntegrationTest
  # ── create ───────────────────────────────────────────────────
  test "create returns 422 without recipe_id" do
    post meal_plan_recipes_path,
         params: { planned_on: "2026-08-01", meal_slot: "breakfast" },
         as: :turbo_stream
    assert_response :unprocessable_entity
  end

  test "create builds a new meal plan and recipe link" do
    assert_difference [ "MealPlan.count", "MealPlanRecipe.count" ], 1 do
      post meal_plan_recipes_path,
           params: { planned_on: "2026-08-01", meal_slot: "breakfast", recipe_id: recipes(:breakfast_recipe).id },
           as: :turbo_stream
    end
    assert_response :ok
  end

  test "create targets the correct turbo stream cell" do
    post meal_plan_recipes_path,
         params: { planned_on: "2026-08-01", meal_slot: "breakfast", recipe_id: recipes(:breakfast_recipe).id },
         as: :turbo_stream
    assert_match "meal_cell_2026-08-01_breakfast", response.body
  end

  test "create reuses existing meal plan for the same date and slot" do
    mp = meal_plans(:one)  # 2026-06-01, breakfast
    assert_no_difference "MealPlan.count" do
      assert_difference "MealPlanRecipe.count", 1 do
        post meal_plan_recipes_path,
             params: { planned_on: mp.planned_on.to_s, meal_slot: "breakfast", recipe_id: recipes(:lunch_recipe).id },
             as: :turbo_stream
      end
    end
    assert_response :ok
  end

  test "create increments quantity when same recipe already on the meal plan" do
    mpr = meal_plan_recipes(:one)  # meal_plan :one + breakfast_recipe, qty 1
    post meal_plan_recipes_path,
         params: { planned_on: meal_plans(:one).planned_on.to_s, meal_slot: "breakfast", recipe_id: recipes(:breakfast_recipe).id },
         as: :turbo_stream
    assert_response :ok
    assert_equal 2, mpr.reload.quantity
  end

  test "create works for snack slots" do
    assert_difference [ "MealPlan.count", "MealPlanRecipe.count" ], 1 do
      post meal_plan_recipes_path,
           params: { planned_on: "2026-08-01", meal_slot: "morning_snack", recipe_id: recipes(:breakfast_recipe).id },
           as: :turbo_stream
    end
    assert_response :ok
  end

  # ── destroy ──────────────────────────────────────────────────
  test "destroy removes the recipe link" do
    mpr = meal_plan_recipes(:one)
    meal_plans(:one).meal_plan_items.create!(food_item: food_items(:eggs), quantity: 1)

    assert_difference "MealPlanRecipe.count", -1 do
      delete meal_plan_recipe_path(mpr), as: :turbo_stream
    end
    assert_response :ok
  end

  test "destroy keeps meal plan when other items remain" do
    mpr = meal_plan_recipes(:one)
    meal_plans(:one).meal_plan_items.create!(food_item: food_items(:eggs), quantity: 1)

    assert_no_difference "MealPlan.count" do
      delete meal_plan_recipe_path(mpr), as: :turbo_stream
    end
  end

  test "destroy removes meal plan when it becomes empty" do
    mpr = meal_plan_recipes(:one)
    meal_plans(:one).meal_plan_items.destroy_all

    assert_difference "MealPlan.count", -1 do
      delete meal_plan_recipe_path(mpr), as: :turbo_stream
    end
    assert_response :ok
  end

  test "destroy targets the correct turbo stream cell when plan survives" do
    mpr = meal_plan_recipes(:one)
    mp  = meal_plans(:one)
    mp.meal_plan_items.create!(food_item: food_items(:eggs), quantity: 1)

    delete meal_plan_recipe_path(mpr), as: :turbo_stream
    assert_match "meal_cell_#{mp.planned_on.iso8601}_breakfast", response.body
  end
end

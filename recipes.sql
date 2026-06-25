-- ============================================================
-- recipes.sql
-- 'Merican Mon / Taco Tue / Italian Wed / Hawaiian Thu / Seafood Fri
-- Breakfast + Lunch + Dinner x5 = 15 recipes
-- Run via: heroku pg:psql < recipes.sql
-- ============================================================

-- Deactivate all existing recipes
UPDATE recipes SET active = false;

-- ============================================================
-- NEW FOOD ITEMS (not yet in system)
-- Pantry entries inserted manually since Rails callback won't fire in SQL
-- ============================================================

INSERT INTO food_items (name, food_type, location, unit, active, position, serving_size, servings_per_unit, unit_servings, created_at, updated_at)
VALUES
  ('Blue Cheese Crumbles', 'protein', 'fridge',   'bag', true, 0, 'oz',  1.0, 1.0, NOW(), NOW()),
  ('Craisins',             'snack',   'pantry',  'bag', true, 0, 'tbsp', 1.0, 1.0, NOW(), NOW()),
  ('Parmesan',             'protein', 'fridge',    'bag', true, 0, 'oz',  1.0, 1.0, NOW(), NOW());

INSERT INTO pantry_items (food_item_id, quantity_on_hand, min_quantity, servings_on_hand, min_servings, created_at, updated_at)
SELECT id, 0, 1, 0.0, 1, NOW(), NOW()
FROM food_items
WHERE name IN ('Blue Cheese Crumbles', 'Craisins', 'Parmesan')
  AND NOT EXISTS (SELECT 1 FROM pantry_items pi WHERE pi.food_item_id = food_items.id);

-- ============================================================
-- MONDAY — 'Merican Monday
-- ============================================================

INSERT INTO recipes (name, meal_type_suggestion, servings, active, position, created_at, updated_at)
VALUES ('Steak & Eggs + Hashbrowns', 'breakfast', 2, true, 1, NOW(), NOW());

INSERT INTO recipe_ingredients (recipe_id, food_item_id, quantity, slot_type, position, created_at, updated_at) VALUES
  ((SELECT id FROM recipes WHERE name = 'Steak & Eggs + Hashbrowns'), 4,   1, 'protein', 1, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Steak & Eggs + Hashbrowns'), 8,   3, 'protein', 2, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Steak & Eggs + Hashbrowns'), 116, 1, 'side',    3, NOW(), NOW());

INSERT INTO recipes (name, meal_type_suggestion, servings, active, position, created_at, updated_at)
VALUES ('Everything Bagel Salad w/ Chicken Patty', 'lunch', 2, true, 2, NOW(), NOW());

INSERT INTO recipe_ingredients (recipe_id, food_item_id, quantity, slot_type, position, created_at, updated_at) VALUES
  ((SELECT id FROM recipes WHERE name = 'Everything Bagel Salad w/ Chicken Patty'), 20,  1, 'vegetable', 1, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Everything Bagel Salad w/ Chicken Patty'), 2,   1, 'protein',   2, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Everything Bagel Salad w/ Chicken Patty'), 107, 2, 'protein',   3, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Everything Bagel Salad w/ Chicken Patty'), 118, 1, 'fruit',     4, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Everything Bagel Salad w/ Chicken Patty'), 7,   1, 'protein',   5, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Everything Bagel Salad w/ Chicken Patty'), (SELECT id FROM food_items WHERE name = 'Blue Cheese Crumbles'), 1, 'protein', 6, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Everything Bagel Salad w/ Chicken Patty'), (SELECT id FROM food_items WHERE name = 'Craisins'),             1, 'snack',   7, NOW(), NOW());

INSERT INTO recipes (name, meal_type_suggestion, servings, active, position, created_at, updated_at)
VALUES ('Homemade Pepperoni Pizza', 'dinner', 2, true, 3, NOW(), NOW());

INSERT INTO recipe_ingredients (recipe_id, food_item_id, quantity, slot_type, position, created_at, updated_at) VALUES
  ((SELECT id FROM recipes WHERE name = 'Homemade Pepperoni Pizza'), 36, 1, 'side',    1, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Homemade Pepperoni Pizza'), 49, 1, 'sauce',   2, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Homemade Pepperoni Pizza'), 14, 1, 'protein', 3, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Homemade Pepperoni Pizza'), 58, 1, 'protein', 4, NOW(), NOW());

-- ============================================================
-- TUESDAY — Taco Tuesday
-- ============================================================

INSERT INTO recipes (name, meal_type_suggestion, servings, active, position, created_at, updated_at)
VALUES ('Bacon Breakfast Burritos', 'breakfast', 2, true, 4, NOW(), NOW());

INSERT INTO recipe_ingredients (recipe_id, food_item_id, quantity, slot_type, position, created_at, updated_at) VALUES
  ((SELECT id FROM recipes WHERE name = 'Bacon Breakfast Burritos'), 8,  3, 'protein', 1, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Bacon Breakfast Burritos'), 7,  1, 'protein', 2, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Bacon Breakfast Burritos'), 28, 2, 'side',    3, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Bacon Breakfast Burritos'), 62, 1, 'sauce',   4, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Bacon Breakfast Burritos'), 52, 1, 'sauce',   5, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Bacon Breakfast Burritos'), 58, 1, 'protein', 6, NOW(), NOW());

INSERT INTO recipes (name, meal_type_suggestion, servings, active, position, created_at, updated_at)
VALUES ('Canned Chicken Quesadillas', 'lunch', 2, true, 5, NOW(), NOW());

INSERT INTO recipe_ingredients (recipe_id, food_item_id, quantity, slot_type, position, created_at, updated_at) VALUES
  ((SELECT id FROM recipes WHERE name = 'Canned Chicken Quesadillas'), 103, 1, 'protein', 1, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Canned Chicken Quesadillas'), 28,  2, 'side',    2, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Canned Chicken Quesadillas'), 58,  1, 'protein', 3, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Canned Chicken Quesadillas'), 47,  1, 'side',    4, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Canned Chicken Quesadillas'), 61,  1, 'sauce',   5, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Canned Chicken Quesadillas'), 62,  1, 'sauce',   6, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Canned Chicken Quesadillas'), 117, 1, 'side',    7, NOW(), NOW());

INSERT INTO recipes (name, meal_type_suggestion, servings, active, position, created_at, updated_at)
VALUES ('Chicken Burrito Bowl', 'dinner', 2, true, 6, NOW(), NOW());

INSERT INTO recipe_ingredients (recipe_id, food_item_id, quantity, slot_type, position, created_at, updated_at) VALUES
  ((SELECT id FROM recipes WHERE name = 'Chicken Burrito Bowl'), 103, 1, 'protein', 1, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Chicken Burrito Bowl'), 29,  1, 'side',    2, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Chicken Burrito Bowl'), 47,  1, 'side',    3, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Chicken Burrito Bowl'), 61,  1, 'sauce',   4, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Chicken Burrito Bowl'), 62,  1, 'sauce',   5, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Chicken Burrito Bowl'), 52,  1, 'sauce',   6, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Chicken Burrito Bowl'), 117, 1, 'side',    7, NOW(), NOW());

-- ============================================================
-- WEDNESDAY — Italian Wednesday
-- ============================================================

INSERT INTO recipes (name, meal_type_suggestion, servings, active, position, created_at, updated_at)
VALUES ('PB Toast + Fresh Berries', 'breakfast', 2, true, 7, NOW(), NOW());

INSERT INTO recipe_ingredients (recipe_id, food_item_id, quantity, slot_type, position, created_at, updated_at) VALUES
  ((SELECT id FROM recipes WHERE name = 'PB Toast + Fresh Berries'), 27,  2, 'side',  1, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'PB Toast + Fresh Berries'), 65,  1, 'sauce', 2, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'PB Toast + Fresh Berries'), 25,  1, 'fruit', 3, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'PB Toast + Fresh Berries'), 108, 1, 'fruit', 4, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'PB Toast + Fresh Berries'), 23,  1, 'fruit', 5, NOW(), NOW());

INSERT INTO recipes (name, meal_type_suggestion, servings, active, position, created_at, updated_at)
VALUES ('Spaghetti Vodka Sauce + Bacon', 'lunch', 2, true, 8, NOW(), NOW());

INSERT INTO recipe_ingredients (recipe_id, food_item_id, quantity, slot_type, position, created_at, updated_at) VALUES
  ((SELECT id FROM recipes WHERE name = 'Spaghetti Vodka Sauce + Bacon'), 34, 1, 'side',    1, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Spaghetti Vodka Sauce + Bacon'), 51, 1, 'sauce',   2, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Spaghetti Vodka Sauce + Bacon'), 7,  1, 'protein', 3, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Spaghetti Vodka Sauce + Bacon'), (SELECT id FROM food_items WHERE name = 'Parmesan'), 1, 'protein', 4, NOW(), NOW());

INSERT INTO recipes (name, meal_type_suggestion, servings, active, position, created_at, updated_at)
VALUES ('Spaghetti Traditional Sauce + Chicken', 'dinner', 2, true, 9, NOW(), NOW());

INSERT INTO recipe_ingredients (recipe_id, food_item_id, quantity, slot_type, position, created_at, updated_at) VALUES
  ((SELECT id FROM recipes WHERE name = 'Spaghetti Traditional Sauce + Chicken'), 34,  1, 'side',    1, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Spaghetti Traditional Sauce + Chicken'), 50,  1, 'sauce',   2, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Spaghetti Traditional Sauce + Chicken'), 103, 1, 'protein', 3, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Spaghetti Traditional Sauce + Chicken'), (SELECT id FROM food_items WHERE name = 'Parmesan'), 1, 'protein', 4, NOW(), NOW());

-- ============================================================
-- THURSDAY — Hawaiian Thursday
-- ============================================================

INSERT INTO recipes (name, meal_type_suggestion, servings, active, position, created_at, updated_at)
VALUES ('Oatmeal Bowl + Granola + Berries', 'breakfast', 2, true, 10, NOW(), NOW());

INSERT INTO recipe_ingredients (recipe_id, food_item_id, quantity, slot_type, position, created_at, updated_at) VALUES
  ((SELECT id FROM recipes WHERE name = 'Oatmeal Bowl + Granola + Berries'), 46,  1, 'side',  1, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Oatmeal Bowl + Granola + Berries'), 45,  1, 'side',  2, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Oatmeal Bowl + Granola + Berries'), 23,  1, 'fruit', 3, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Oatmeal Bowl + Granola + Berries'), 108, 1, 'fruit', 4, NOW(), NOW());

INSERT INTO recipes (name, meal_type_suggestion, servings, active, position, created_at, updated_at)
VALUES ('Teriyaki Chicken Rice Bowl', 'lunch', 2, true, 11, NOW(), NOW());

INSERT INTO recipe_ingredients (recipe_id, food_item_id, quantity, slot_type, position, created_at, updated_at) VALUES
  ((SELECT id FROM recipes WHERE name = 'Teriyaki Chicken Rice Bowl'), 103, 1, 'protein',   1, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Teriyaki Chicken Rice Bowl'), 29,  1, 'side',      2, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Teriyaki Chicken Rice Bowl'), 100, 1, 'vegetable', 3, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Teriyaki Chicken Rice Bowl'), 110, 1, 'sauce',     4, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Teriyaki Chicken Rice Bowl'), 109, 1, 'sauce',     5, NOW(), NOW());

INSERT INTO recipes (name, meal_type_suggestion, servings, active, position, created_at, updated_at)
VALUES ('Teriyaki Steak Bowl', 'dinner', 2, true, 12, NOW(), NOW());

INSERT INTO recipe_ingredients (recipe_id, food_item_id, quantity, slot_type, position, created_at, updated_at) VALUES
  ((SELECT id FROM recipes WHERE name = 'Teriyaki Steak Bowl'), 4,   1, 'protein',   1, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Teriyaki Steak Bowl'), 29,  1, 'side',      2, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Teriyaki Steak Bowl'), 100, 1, 'vegetable', 3, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Teriyaki Steak Bowl'), 110, 1, 'sauce',     4, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Teriyaki Steak Bowl'), 109, 1, 'sauce',     5, NOW(), NOW());

-- ============================================================
-- FRIDAY — Seafood Friday
-- ============================================================

INSERT INTO recipes (name, meal_type_suggestion, servings, active, position, created_at, updated_at)
VALUES ('Bacon & Egg Sandwich', 'breakfast', 2, true, 13, NOW(), NOW());

INSERT INTO recipe_ingredients (recipe_id, food_item_id, quantity, slot_type, position, created_at, updated_at) VALUES
  ((SELECT id FROM recipes WHERE name = 'Bacon & Egg Sandwich'), 8,  2, 'protein', 1, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Bacon & Egg Sandwich'), 7,  1, 'protein', 2, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Bacon & Egg Sandwich'), 27, 2, 'side',    3, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Bacon & Egg Sandwich'), 59, 1, 'side',    4, NOW(), NOW());

INSERT INTO recipes (name, meal_type_suggestion, servings, active, position, created_at, updated_at)
VALUES ('Gorton''s Fish Fillets + Veggies', 'lunch', 2, true, 14, NOW(), NOW());

INSERT INTO recipe_ingredients (recipe_id, food_item_id, quantity, slot_type, position, created_at, updated_at) VALUES
  ((SELECT id FROM recipes WHERE name = 'Gorton''s Fish Fillets + Veggies'), 16,  1, 'protein',   1, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Gorton''s Fish Fillets + Veggies'), 101, 1, 'vegetable', 2, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Gorton''s Fish Fillets + Veggies'), 114, 1, 'sauce',     3, NOW(), NOW());

INSERT INTO recipes (name, meal_type_suggestion, servings, active, position, created_at, updated_at)
VALUES ('Tuna Mac', 'dinner', 2, true, 15, NOW(), NOW());

INSERT INTO recipe_ingredients (recipe_id, food_item_id, quantity, slot_type, position, created_at, updated_at) VALUES
  ((SELECT id FROM recipes WHERE name = 'Tuna Mac'), 35,  1, 'side',      1, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Tuna Mac'), 6,   1, 'protein',   2, NOW(), NOW()),
  ((SELECT id FROM recipes WHERE name = 'Tuna Mac'), 101, 1, 'vegetable', 3, NOW(), NOW());

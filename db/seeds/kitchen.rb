# Kitchen seed: food items, pantry defaults, and recipes.
# All quantities are calibrated for 1 active adult male + 1 five-year-old child.
# min_quantity = reorder threshold (shopping list triggers when on_hand <= min)

# ── Food Items ─────────────────────────────────────────────────────────────────
# Format: [name, food_type, location, unit, position, min_quantity]
FOOD_ITEM_DATA = [
  # Proteins
  ["Chicken (Fresh)",             "protein", "fridge",   "each",      1,  2],
  ["Chicken Patty (Frozen)",      "protein", "freezer",  "each",      2,  6],
  ["Chicken Nuggets",             "protein", "freezer",  "bag",       3,  1],
  ["Steak",                       "protein", "fridge",   "each",      4,  1],
  ["Salmon",                      "protein", "fridge",   "each",      5,  1],
  ["Tuna",                        "protein", "cupboard", "can",       6,  4],
  ["Bacon",                       "protein", "fridge",   "pack",      7,  1],
  ["Egg",                         "protein", "fridge",   "each",      8,  8],
  ["Lunch Meat - Turkey",         "protein", "fridge",   "pack",      9,  1],
  ["Meatballs",                   "protein", "freezer",  "bag",       10, 1],
  ["Hot Dogs",                    "protein", "freezer",  "pack",      11, 1],
  ["Lil Smokies",                 "protein", "fridge",   "pack",      12, 1],
  ["Spam",                        "protein", "cupboard", "can",       13, 2],
  ["Pepperoni (Sliced)",          "protein", "fridge",   "pack",      14, 1],
  ["Pepperoni Stick",             "protein", "cupboard", "each",      15, 4],
  ["Gorton's Frozen Fish Fillets", "protein", "freezer",  "bag",       16, 1],

  # Vegetables
  ["Broccoli",                    "vegetable", "fridge",  "each",      1,  1],
  ["Carrots",                     "vegetable", "fridge",  "bag",       2,  1],
  ["Canned Corn",                 "vegetable", "cupboard", "can",       3,  2],
  ["Everything Bagel Salad Kit",  "vegetable", "fridge",  "kit",       4,  2],
  ["Caesar Salad Kit",            "vegetable", "fridge",  "kit",       5,  1],

  # Fruits
  ["Apple",                       "fruit",   "fridge",   "each",      1,  5],
  ["Banana",                      "fruit",   "cupboard", "each",      2,  4],
  ["Grapes",                      "fruit",   "fridge",   "bag",       3,  1],
  ["Raspberries",                 "fruit",   "fridge",   "container", 4,  1],
  ["Blueberries",                 "fruit",   "fridge",   "container", 5,  1],

  # Sides
  ["Bread",                       "side",    "fridge",   "loaf",      1,  1],
  ["Tortilla",                    "side",    "fridge",   "pack",      2,  1],
  ["Rice",                        "side",    "cupboard", "bag",       3,  1],
  ["French Fries",                "side",    "freezer",  "bag",       4,  2],
  ["Tater Tots",                  "side",    "freezer",  "bag",       5,  1],
  ["Potato",                      "side",    "cupboard", "each",      6,  3],
  ["Mashed Potatoes (Instant)",   "side",    "cupboard", "box",       7,  1],
  ["Spaghetti (Noodles)",         "side",    "cupboard", "box",       8,  2],
  ["Mac & Cheese",                "side",    "cupboard", "box",       9,  3],
  ["Pizza Dough",                 "side",    "fridge",   "each",      10, 1],
  ["Bagel",                       "side",    "fridge",   "each",      11, 4],
  ["Hoagie Roll",                 "side",    "fridge",   "each",      12, 3],
  ["French Toast Sticks",         "side",    "freezer",  "box",       13, 1],
  ["Hashbrown Patty",             "side",    "freezer",  "each",      14, 4],
  ["Uncrustable",                 "side",    "freezer",  "each",      15, 4],
  ["Hot Pocket",                  "side",    "freezer",  "each",      16, 2],
  ["Garlic Bread",                "side",    "freezer",  "loaf",      17, 1],
  ["Cereal",                      "side",    "cupboard", "box",       18, 1],
  ["Granola",                     "side",    "cupboard", "bag",       19, 1],
  ["Oatmeal Packets",             "side",    "cupboard", "box",       20, 1],
  ["Refried Beans",               "side",    "cupboard", "can",       21, 1],
  ["Chicken Noodle Soup",         "side",    "cupboard", "can",       22, 3],

  # Sauces / Condiments / Dairy
  ["Pizza Sauce",                 "sauce",   "cupboard", "can",       1,  1],
  ["Spaghetti Sauce (Traditional)", "sauce",  "cupboard", "jar",       2,  1],
  ["Spaghetti Sauce (Vodka)",     "sauce",   "cupboard", "jar",       3,  1],
  ["Sour Cream",                  "sauce",   "fridge",   "container", 4,  1],
  ["Butter",                      "sauce",   "fridge",   "pack",      5,  1],
  ["Ketchup",                     "sauce",   "fridge",   "bottle",    6,  1],
  ["Chic-Fil-A Sauce",            "sauce",   "fridge",   "bottle",    7,  1],
  ["Mayo",                        "sauce",   "fridge",   "jar",       8,  1],
  ["Mustard",                     "sauce",   "fridge",   "bottle",    9,  1],
  ["Shredded Cheese",             "sauce",   "fridge",   "bag",       10, 2],
  ["Cheese - Kraft Singles",      "sauce",   "fridge",   "pack",      11, 1],
  ["Cheese Stick",                "sauce",   "fridge",   "each",      12, 6],
  ["Queso",                       "sauce",   "fridge",   "jar",       13, 1],
  ["Salsa",                       "sauce",   "fridge",   "jar",       14, 1],
  ["Syrup",                       "sauce",   "cupboard", "bottle",    15, 1],
  ["Gravy",                       "sauce",   "cupboard", "can",       16, 1],
  ["Peanut Butter",               "sauce",   "cupboard", "jar",       17, 1],
  ["Milk",                        "sauce",   "fridge",   "jug",       18, 1],
  ["Colby Jack Cheese",           "sauce",   "fridge",   "bag",       19, 1],
  ["Vanilla Yogurt",              "sauce",   "fridge",   "container", 20, 1],

  # Snacks
  ["Z Bar",                       "snack",   "cupboard", "each",      1,  4],
  ["Beef Jerky",                  "snack",   "cupboard", "bag",       2,  1],
  ["Cheese Balls",                "snack",   "cupboard", "bag",       3,  1],
  ["Popcorn",                     "snack",   "cupboard", "bag",       4,  3],
  ["Pretzels - Dots Parmesan Garlic", "snack", "cupboard", "bag",       5,  1],
  ["Goldfish",                    "snack",   "cupboard", "bag",       6,  2],
  ["Cheez-Its",                   "snack",   "cupboard", "box",       7,  1],
  ["Clif Bar",                    "snack",   "cupboard", "each",      8,  4],
  ["Chips",                       "snack",   "cupboard", "bag",       9,  2],

  # Desserts
  ["Yogurt (Pouch)",              "dessert", "fridge",   "each",      1,  6],
  ["Yogurt (Drink)",              "dessert", "fridge",   "each",      2,  4],
  ["Yogurt (Camping)",            "dessert", "cupboard", "each",      3,  2]
].freeze

puts "Seeding food items..."
FOOD_ITEM_DATA.each do |name, food_type, location, unit, position, min_qty|
  item = FoodItem.find_or_initialize_by(name: name)
  item.assign_attributes(
    food_type: food_type,
    location:  location,
    unit:      unit,
    position:  position,
    active:    true
  )
  item.save!

  pantry = PantryItem.find_or_initialize_by(food_item: item)
  pantry.assign_attributes(min_quantity: min_qty, quantity_on_hand: pantry.quantity_on_hand || 0)
  pantry.save!
end
puts "  #{FoodItem.count} food items, #{PantryItem.count} pantry records"

# ── Helper to look up food items by name ────────────────────────────────────
def fi(name)
  FoodItem.find_by!(name: name)
rescue ActiveRecord::RecordNotFound
  raise "FoodItem not found: #{name.inspect} — check seed data"
end

# ── Recipes ────────────────────────────────────────────────────────────────────
# Format: { name:, meal_type:, servings:, ingredients: [[name, qty, slot, pos]] }
RECIPE_DATA = [
  # ── Breakfast ──────────────────────────────────────────────────────────────
  {
    name: "Hard Boiled Eggs + Cheese Stick",
    meal_type: "breakfast", servings: 2,
    ingredients: [
      ["Egg",          2, "protein",   1],
      ["Cheese Stick", 2, "side",      2]
    ]
  },
  {
    name: "Bagel Sandwich (Egg + Kraft Single + Bacon)",
    meal_type: "breakfast", servings: 2,
    ingredients: [
      ["Bagel",               2, "side",    1],
      ["Egg",                 2, "protein", 2],
      ["Cheese - Kraft Singles", 1, "sauce", 3],
      ["Bacon",               1, "protein", 4]
    ]
  },
  {
    name: "Cereal + Milk + PB Toast",
    meal_type: "breakfast", servings: 2,
    ingredients: [
      ["Cereal",       1, "side",  1],
      ["Milk",         1, "sauce", 2],
      ["Bread",        1, "side",  3],
      ["Peanut Butter", 1, "sauce", 4]
    ]
  },
  {
    name: "French Toast Sticks + Hashbrown Patty + Eggs",
    meal_type: "breakfast", servings: 2,
    ingredients: [
      ["French Toast Sticks", 1, "side",    1],
      ["Hashbrown Patty",     4, "side",    2],
      ["Egg",                 2, "protein", 3],
      ["Syrup",               1, "sauce",   4]
    ]
  },
  {
    name: "Oatmeal Bowl w/ Granola + Apple",
    meal_type: "breakfast", servings: 2,
    ingredients: [
      ["Oatmeal Packets", 1, "side",  1],
      ["Milk",            1, "sauce", 2],
      ["Granola",         1, "side",  3],
      ["Apple",           2, "fruit", 4]
    ]
  },
  {
    name: "Spam Eggs + Rice w/ Colby Jack",
    meal_type: "breakfast", servings: 2,
    ingredients: [
      ["Spam",             1, "protein", 1],
      ["Egg",              2, "protein", 2],
      ["Rice",             1, "side",    3],
      ["Colby Jack Cheese", 1, "sauce",   4]
    ]
  },
  {
    name: "Uncrustable + Clif Bar",
    meal_type: "breakfast", servings: 2,
    ingredients: [
      ["Uncrustable", 2, "side",  1],
      ["Clif Bar",    1, "snack", 2]
    ]
  },
  {
    name: "Vanilla Yogurt & Granola + Pepperoni Stick",
    meal_type: "breakfast", servings: 2,
    ingredients: [
      ["Vanilla Yogurt",  1, "sauce",   1],
      ["Granola",         1, "side",    2],
      ["Pepperoni Stick", 2, "protein", 3]
    ]
  },
  {
    name: "Yogurt & Z Bar",
    meal_type: "breakfast", servings: 2,
    ingredients: [
      ["Yogurt (Pouch)", 2, "dessert", 1],
      ["Z Bar",          2, "snack",   2]
    ]
  },

  # ── Lunch ──────────────────────────────────────────────────────────────────
  {
    name: "Chicken & Everything Bagel Salad Wrap",
    meal_type: "lunch", servings: 2,
    ingredients: [
      ["Tortilla",                1, "side",      1],
      ["Chicken Patty (Frozen)",  1, "protein",   2],
      ["Shredded Cheese",         1, "sauce",      3],
      ["Everything Bagel Salad Kit", 1, "vegetable", 4]
    ]
  },
  {
    name: "Chicken Melt + Chips",
    meal_type: "lunch", servings: 2,
    ingredients: [
      ["Chicken Patty (Frozen)",   2, "protein", 1],
      ["Cheese - Kraft Singles",   2, "sauce",   2],
      ["Mayo",                     1, "sauce",   3],
      ["Bread",                    1, "side",    4],
      ["Chips",                    1, "snack",   5]
    ]
  },
  {
    name: "Everything Salad Kit w/ Chicken Patties",
    meal_type: "lunch", servings: 2,
    ingredients: [
      ["Everything Bagel Salad Kit", 1, "vegetable", 1],
      ["Chicken Patty (Frozen)",     2, "protein",   2]
    ]
  },
  {
    name: "Gorton's Fish Fillets + Cooked Veggies",
    meal_type: "lunch", servings: 2,
    ingredients: [
      ["Gorton's Frozen Fish Fillets", 1, "protein",   1],
      ["Broccoli",                     1, "vegetable", 2]
    ]
  },
  {
    name: "Hot Dogs + Hoagie + Fries",
    meal_type: "lunch", servings: 2,
    ingredients: [
      ["Hot Dogs",     1, "protein", 1],
      ["Hoagie Roll",  2, "side",    2],
      ["French Fries", 1, "side",    3]
    ]
  },
  {
    name: "Hot Pocket + Uncrustable",
    meal_type: "lunch", servings: 2,
    ingredients: [
      ["Hot Pocket",   2, "side", 1],
      ["Uncrustable",  2, "side", 2]
    ]
  },
  {
    name: "Tuna Melt on Bagel + Fries",
    meal_type: "lunch", servings: 2,
    ingredients: [
      ["Tuna",                  2, "protein", 1],
      ["Cheese - Kraft Singles", 2, "sauce",   2],
      ["Bagel",                 2, "side",    3],
      ["French Fries",          1, "side",    4]
    ]
  },
  {
    name: "Turkey Hoagie + Chips",
    meal_type: "lunch", servings: 2,
    ingredients: [
      ["Lunch Meat - Turkey",    1, "protein", 1],
      ["Hoagie Roll",            2, "side",    2],
      ["Cheese - Kraft Singles", 2, "sauce",   3],
      ["Mayo",                   1, "sauce",   4],
      ["Chips",                  1, "snack",   5]
    ]
  },
  {
    name: "Turkey Sandwich + Chips",
    meal_type: "lunch", servings: 2,
    ingredients: [
      ["Lunch Meat - Turkey",    1, "protein", 1],
      ["Bread",                  1, "side",    2],
      ["Cheese - Kraft Singles", 2, "sauce",   3],
      ["Mayo",                   1, "sauce",   4],
      ["Chips",                  1, "snack",   5]
    ]
  },
  {
    name: "Grilled Cheese + Chicken Noodle Soup",
    meal_type: "lunch", servings: 2,
    ingredients: [
      ["Bread",                  1, "side",  1],
      ["Cheese - Kraft Singles", 2, "sauce", 2],
      ["Butter",                 1, "sauce", 3],
      ["Chicken Noodle Soup",    1, "side",  4]
    ]
  },
  {
    name: "Uncrustable + Chips + Fruit",
    meal_type: "lunch", servings: 2,
    ingredients: [
      ["Uncrustable", 2, "side",  1],
      ["Chips",       1, "snack", 2],
      ["Apple",       2, "fruit", 3]
    ]
  },

  # ── Dinner ──────────────────────────────────────────────────────────────────
  {
    name: "Homemade Pepperoni Pizza + Fruit",
    meal_type: "dinner", servings: 3,
    ingredients: [
      ["Pizza Dough",       1, "side",    1],
      ["Pizza Sauce",       1, "sauce",   2],
      ["Pepperoni (Sliced)", 1, "protein", 3],
      ["Shredded Cheese",   1, "sauce",   4],
      ["Grapes",            1, "fruit",   5]
    ]
  },
  {
    name: "Spaghetti w/ Meatballs (Traditional)",
    meal_type: "dinner", servings: 3,
    ingredients: [
      ["Spaghetti (Noodles)",          1, "side",    1],
      ["Spaghetti Sauce (Traditional)", 1, "sauce",   2],
      ["Meatballs",                    1, "protein", 3]
    ]
  },
  {
    name: "Spaghetti + Vodka Sauce + Garlic Bread",
    meal_type: "dinner", servings: 3,
    ingredients: [
      ["Spaghetti (Noodles)",       1, "side",    1],
      ["Spaghetti Sauce (Vodka)",   1, "sauce",   2],
      ["Meatballs",                 1, "protein", 3],
      ["Garlic Bread",              1, "side",    4]
    ]
  },
  {
    name: "Fish & Chips (Gorton's + Fries)",
    meal_type: "dinner", servings: 2,
    ingredients: [
      ["Gorton's Frozen Fish Fillets", 1, "protein", 1],
      ["French Fries",                 1, "side",    2]
    ]
  },
  {
    name: "Grilled Cheese + Soup + Fruit",
    meal_type: "dinner", servings: 2,
    ingredients: [
      ["Bread",                  1, "side",  1],
      ["Cheese - Kraft Singles", 2, "sauce", 2],
      ["Butter",                 1, "sauce", 3],
      ["Chicken Noodle Soup",    1, "side",  4],
      ["Apple",                  2, "fruit", 5]
    ]
  },
  {
    name: "Baked Potato",
    meal_type: "dinner", servings: 2,
    ingredients: [
      ["Potato",        2, "side",  1],
      ["Sour Cream",    1, "sauce", 2],
      ["Butter",        1, "sauce", 3],
      ["Shredded Cheese", 1, "sauce", 4]
    ]
  },
  {
    name: "Cheese Quesadilla",
    meal_type: "dinner", servings: 2,
    ingredients: [
      ["Tortilla",       2, "side",  1],
      ["Shredded Cheese", 1, "sauce", 2]
    ]
  },
  {
    name: "Everything Bagel Salad Kit + Chicken Patties",
    meal_type: "dinner", servings: 2,
    ingredients: [
      ["Everything Bagel Salad Kit", 1, "vegetable", 1],
      ["Chicken Patty (Frozen)",     2, "protein",   2]
    ]
  },
  {
    name: "Gorton's Fish Fillets + Tater Tots + Broccoli",
    meal_type: "dinner", servings: 2,
    ingredients: [
      ["Gorton's Frozen Fish Fillets", 1, "protein",   1],
      ["Tater Tots",                   1, "side",      2],
      ["Broccoli",                     1, "vegetable", 3]
    ]
  },
  {
    name: "Lil Smokies + Mashed Potatoes + Corn + Gravy",
    meal_type: "dinner", servings: 2,
    ingredients: [
      ["Lil Smokies",             1, "protein",   1],
      ["Mashed Potatoes (Instant)", 1, "side",      2],
      ["Canned Corn",              1, "vegetable", 3],
      ["Gravy",                   1, "sauce",     4]
    ]
  },
  {
    name: "Quesadilla Plate + Refried Beans + Queso",
    meal_type: "dinner", servings: 2,
    ingredients: [
      ["Tortilla",       2, "side",  1],
      ["Shredded Cheese", 1, "sauce", 2],
      ["Refried Beans",  1, "side",  3],
      ["Sour Cream",     1, "sauce", 4],
      ["Queso",          1, "sauce", 5]
    ]
  },
  {
    name: "Spam Fried Rice",
    meal_type: "dinner", servings: 2,
    ingredients: [
      ["Spam",             1, "protein", 1],
      ["Rice",             1, "side",    2],
      ["Egg",              2, "protein", 3],
      ["Colby Jack Cheese", 1, "sauce",   4]
    ]
  },
  {
    name: "Mac & Cheese",
    meal_type: "dinner", servings: 2,
    ingredients: [
      ["Mac & Cheese", 2, "side", 1]
    ]
  }
].freeze

puts "Seeding recipes..."
RECIPE_DATA.each.with_index(1) do |data, pos|
  recipe = Recipe.find_or_initialize_by(name: data[:name])
  recipe.assign_attributes(
    meal_type_suggestion: data[:meal_type],
    servings:             data[:servings],
    position:             pos,
    active:               true
  )
  recipe.save!

  data[:ingredients].each do |name, qty, slot, ing_pos|
    food_item = fi(name)
    ri = RecipeIngredient.find_or_initialize_by(recipe: recipe, food_item: food_item)
    ri.assign_attributes(quantity: qty, slot_type: slot, position: ing_pos)
    ri.save!
  end
end
puts "  #{Recipe.count} recipes, #{RecipeIngredient.count} ingredients"

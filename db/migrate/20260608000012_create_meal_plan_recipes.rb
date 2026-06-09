class CreateMealPlanRecipes < ActiveRecord::Migration[8.0]
  def up
    create_table :meal_plan_recipes do |t|
      t.references :meal_plan, null: false, foreign_key: true
      t.references :recipe,    null: false, foreign_key: true
      t.timestamps
    end

    execute <<~SQL
      INSERT INTO meal_plan_recipes (meal_plan_id, recipe_id, created_at, updated_at)
      SELECT id, recipe_id, NOW(), NOW()
      FROM meal_plans
      WHERE recipe_id IS NOT NULL
    SQL

    remove_foreign_key :meal_plans, :recipes
    remove_index :meal_plans, :recipe_id
    remove_column :meal_plans, :recipe_id
  end

  def down
    add_column :meal_plans, :recipe_id, :bigint
    add_index :meal_plans, :recipe_id
    add_foreign_key :meal_plans, :recipes

    execute <<~SQL
      UPDATE meal_plans mp
      SET recipe_id = (
        SELECT recipe_id FROM meal_plan_recipes mpr
        WHERE mpr.meal_plan_id = mp.id
        ORDER BY mpr.created_at
        LIMIT 1
      )
    SQL

    drop_table :meal_plan_recipes
  end
end

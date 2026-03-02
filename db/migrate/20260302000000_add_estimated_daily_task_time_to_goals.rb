class AddEstimatedDailyTaskTimeToGoals < ActiveRecord::Migration[8.1]
  def up
    add_column :goals, :estimated_daily_task_time, :integer

    execute <<~SQL
      UPDATE goals
      SET estimated_daily_task_time = CASE
        WHEN LOWER(title) LIKE '%med%' THEN 5
        WHEN LOWER(title) LIKE '%feed dog%' THEN 5
        WHEN LOWER(title) LIKE '%walk dog%' THEN 30
        WHEN LOWER(title) LIKE '%chore%' THEN 15
        WHEN LOWER(title) LIKE '%strength%' THEN 5
        WHEN LOWER(title) LIKE '%meal%' THEN 30
        WHEN LOWER(title) LIKE '%career%' THEN 30
        WHEN LOWER(title) LIKE '%hydration%' THEN 10
        WHEN LOWER(title) LIKE '%shower%' THEN 15
        WHEN LOWER(title) LIKE '%household%' THEN 30
        ELSE 30
      END
      WHERE estimated_daily_task_time IS NULL;
    SQL
  end

  def down
    remove_column :goals, :estimated_daily_task_time
  end
end

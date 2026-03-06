class CreateRecurringTasks < ActiveRecord::Migration[8.1]
  def change
    unless table_exists?(:recurring_tasks)
      create_table :recurring_tasks do |t|
        t.string :task_name
        t.text :description
        t.integer :priority
        t.date :start_date
        t.date :due_date
        t.integer :estimated_time, null: false, default: 30
        t.integer :actual_time, null: false, default: 0
        t.integer :status
        t.datetime :hold_until
        t.date :completion_date
        t.string :assigned_to
        t.string :eligible_reward
        t.jsonb :smart, default: {}, null: false
        t.boolean :active, null: false, default: true
        t.references :goal, foreign_key: true
        t.timestamps
      end
    end

    add_column :recurring_tasks, :task_name, :string unless column_exists?(:recurring_tasks, :task_name)
    add_column :recurring_tasks, :description, :text unless column_exists?(:recurring_tasks, :description)
    add_column :recurring_tasks, :priority, :integer unless column_exists?(:recurring_tasks, :priority)
    add_column :recurring_tasks, :start_date, :date unless column_exists?(:recurring_tasks, :start_date)
    add_column :recurring_tasks, :due_date, :date unless column_exists?(:recurring_tasks, :due_date)
    add_column :recurring_tasks, :estimated_time, :integer, default: 30 unless column_exists?(:recurring_tasks, :estimated_time)
    add_column :recurring_tasks, :actual_time, :integer, default: 0 unless column_exists?(:recurring_tasks, :actual_time)
    add_column :recurring_tasks, :status, :integer unless column_exists?(:recurring_tasks, :status)
    add_column :recurring_tasks, :hold_until, :datetime unless column_exists?(:recurring_tasks, :hold_until)
    add_column :recurring_tasks, :completion_date, :date unless column_exists?(:recurring_tasks, :completion_date)
    add_column :recurring_tasks, :assigned_to, :string unless column_exists?(:recurring_tasks, :assigned_to)
    add_column :recurring_tasks, :eligible_reward, :string unless column_exists?(:recurring_tasks, :eligible_reward)
    add_column :recurring_tasks, :smart, :jsonb, default: {} unless column_exists?(:recurring_tasks, :smart)
    add_column :recurring_tasks, :active, :boolean, default: true unless column_exists?(:recurring_tasks, :active)
    unless column_exists?(:recurring_tasks, :goal_id)
      add_reference :recurring_tasks, :goal, foreign_key: true
    end

    add_index :recurring_tasks, :goal_id unless index_exists?(:recurring_tasks, :goal_id)
  end
end

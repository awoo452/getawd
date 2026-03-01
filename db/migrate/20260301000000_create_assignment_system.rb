class CreateAssignmentSystem < ActiveRecord::Migration[8.1]
  def change
    ensure_assignment_pools!
    ensure_assignment_items!
    ensure_assignment_logs!
  end

  private

  def ensure_assignment_pools!
    unless table_exists?(:assignment_pools)
      create_table :assignment_pools do |t|
        t.string :name, null: false
        t.references :goal, null: false, foreign_key: true
        t.boolean :active, null: false, default: true
        t.timestamps
      end
    end

    return unless table_exists?(:assignment_pools)

    unless index_exists?(:assignment_pools, :goal_id, unique: true)
      add_index :assignment_pools,
        :goal_id,
        unique: true,
        name: "index_assignment_pools_on_goal_id_unique"
    end

    unless foreign_key_exists?(:assignment_pools, :goals)
      add_foreign_key :assignment_pools, :goals
    end
  end

  def ensure_assignment_items!
    unless table_exists?(:assignment_items)
      create_table :assignment_items do |t|
        t.references :assignment_pool, null: false, foreign_key: true
        t.string :label, null: false
        t.string :frequency, null: false, default: "weekly"
        t.integer :weight, null: false, default: 1
        t.boolean :active, null: false, default: true
        t.integer :estimated_time
        t.string :source_type
        t.bigint :source_id
        t.timestamps
      end
    end

    return unless table_exists?(:assignment_items)

    unless index_exists?(:assignment_items, [:source_type, :source_id])
      add_index :assignment_items,
        [:source_type, :source_id],
        name: "index_assignment_items_on_source"
    end

    unless foreign_key_exists?(:assignment_items, :assignment_pools)
      add_foreign_key :assignment_items, :assignment_pools
    end
  end

  def ensure_assignment_logs!
    unless table_exists?(:assignment_logs)
      create_table :assignment_logs do |t|
        t.references :assignment_item, null: false, foreign_key: true
        t.references :task, null: false, foreign_key: true
        t.date :assigned_on, null: false
        t.date :week_start, null: false
        t.timestamps
      end
    end

    return unless table_exists?(:assignment_logs)

    unless index_exists?(:assignment_logs, :assigned_on)
      add_index :assignment_logs, :assigned_on
    end

    unless index_exists?(:assignment_logs, :week_start)
      add_index :assignment_logs, :week_start
    end

    unless foreign_key_exists?(:assignment_logs, :assignment_items)
      add_foreign_key :assignment_logs, :assignment_items
    end

    unless foreign_key_exists?(:assignment_logs, :tasks)
      add_foreign_key :assignment_logs, :tasks
    end
  end
end

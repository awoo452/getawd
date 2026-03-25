class StandardizeBugs < ActiveRecord::Migration[8.1]
  class BugRecord < ApplicationRecord
    self.table_name = "bugs"
  end

  def up
    rename_column :bugs, :title, :summary
    rename_column :bugs, :body, :details

    add_column :bugs, :reporter_name, :string
    add_column :bugs, :reporter_email, :string
    add_column :bugs, :steps_to_reproduce, :text
    add_column :bugs, :expected_behavior, :text
    add_column :bugs, :actual_behavior, :text
    add_column :bugs, :severity, :string, default: "medium", null: false
    add_column :bugs, :status, :string, default: "new", null: false
    add_column :bugs, :environment, :string
    add_column :bugs, :ip_address, :string

    BugRecord.reset_column_information

    BugRecord.find_each do |bug|
      section = bug.read_attribute(:section)
      commit_ref = bug.read_attribute(:commit_ref)

      details = bug.details.to_s
      details = "No details provided." if details.strip.empty?
      details = [details, commit_ref.present? ? "Commit: #{commit_ref}" : nil].compact.join("\n\n")

      status = bug.read_attribute(:completed) ? "resolved" : "new"

      bug.update_columns(
        reporter_name: "Unknown",
        reporter_email: "unknown@example.com",
        status: status,
        severity: "medium",
        environment: section,
        details: details
      )
    end

    change_column_null :bugs, :reporter_name, false
    change_column_null :bugs, :reporter_email, false
    change_column_null :bugs, :details, false

    remove_column :bugs, :completed, :boolean
    remove_column :bugs, :commit_ref, :string
    remove_column :bugs, :section, :string
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Bugs were standardized"
  end
end

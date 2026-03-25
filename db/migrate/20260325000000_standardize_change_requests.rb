class StandardizeChangeRequests < ActiveRecord::Migration[8.1]
  class ChangeRequestRecord < ApplicationRecord
    self.table_name = "change_requests"
  end

  def up
    rename_table :feedbacks, :change_requests

    rename_column :change_requests, :title, :summary
    rename_column :change_requests, :body, :details

    add_column :change_requests, :requester_name, :string
    add_column :change_requests, :requester_email, :string
    add_column :change_requests, :benefit, :text
    add_column :change_requests, :acceptance_criteria, :text
    add_column :change_requests, :priority, :string, default: "medium", null: false
    add_column :change_requests, :status, :string, default: "new", null: false
    add_column :change_requests, :target_release, :string
    add_column :change_requests, :ip_address, :string

    ChangeRequestRecord.reset_column_information

    ChangeRequestRecord.find_each do |request|
      section = request.read_attribute(:section)
      commit_ref = request.read_attribute(:commit_ref)

      extras = []
      extras << "Section: #{section}" if section.present?
      extras << "Commit: #{commit_ref}" if commit_ref.present?

      details = request.details.to_s
      details = "No details provided." if details.strip.empty?
      details = [details, extras.join("\n")].reject(&:blank?).join("\n\n")

      status = request.read_attribute(:completed) ? "completed" : "new"

      request.update_columns(
        requester_name: "Unknown",
        requester_email: "unknown@example.com",
        status: status,
        details: details
      )
    end

    change_column_null :change_requests, :requester_name, false
    change_column_null :change_requests, :requester_email, false
    change_column_null :change_requests, :details, false

    remove_column :change_requests, :completed, :boolean
    remove_column :change_requests, :commit_ref, :string
    remove_column :change_requests, :section, :string
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Change requests were standardized from feedbacks"
  end
end

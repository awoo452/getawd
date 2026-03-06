# app/models/recurring_task_instance.rb
class RecurringTaskInstance < ApplicationRecord
  self.table_name = "recurring_task_instances"

  belongs_to :task
  belongs_to :recurring_task
end

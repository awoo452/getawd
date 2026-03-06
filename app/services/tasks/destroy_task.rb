# app/services/tasks/destroy_task.rb
module Tasks
  class DestroyTask
    def self.call(task_id:)
      new(task_id: task_id).call
    end

    def initialize(task_id:)
      @task_id = task_id
    end

    def call
      task = Task.find(@task_id)

      Task.transaction do
        delete_recurring_task_instances(task.id)
        task.destroy
      end

      task
    end

    private

    def delete_recurring_task_instances(task_id)
      return unless ActiveRecord::Base.connection.data_source_exists?("recurring_task_instances")

      ActiveRecord::Base.connection.exec_delete(
        "DELETE FROM recurring_task_instances WHERE task_id = $1",
        "SQL",
        [[nil, task_id]]
      )
    end
  end
end

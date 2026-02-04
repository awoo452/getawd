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
      task.destroy
      task
    end
  end
end

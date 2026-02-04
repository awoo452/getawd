# app/services/tasks/complete_on_time.rb
module Tasks
  class CompleteOnTime
    def self.call(task_id:)
      new(task_id: task_id).call
    end

    def initialize(task_id:)
      @task_id = task_id
    end

    def call
      task = Task.find(@task_id)
      task.update!(
        status: :completed,
        completion_date: Time.zone.today,
        actual_time: task.estimated_time
      )
      task
    end
  end
end

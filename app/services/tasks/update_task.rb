# app/services/tasks/update_task.rb
module Tasks
  class UpdateTask
    Result = Struct.new(:success?, :task, keyword_init: true)

    def self.call(task_id:, params:)
      new(task_id: task_id, params: params).call
    end

    def initialize(task_id:, params:)
      @task_id = task_id
      @params = params
    end

    def call
      task = Task.find(@task_id)

      if task.update(@params)
        Result.new(success?: true, task: task)
      else
        Result.new(success?: false, task: task)
      end
    end
  end
end

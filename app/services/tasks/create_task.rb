# app/services/tasks/create_task.rb
module Tasks
  class CreateTask
    Result = Struct.new(:success?, :task, keyword_init: true)

    def self.call(params:)
      new(params: params).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      base_task = Task.new(@params.except(:repeat_until))
      repeat_until = @params[:repeat_until].presence

      end_date = validate_repeat_until(base_task, repeat_until)
      return Result.new(success?: false, task: base_task) if base_task.errors.any?

      if base_task.save
        create_repeated_tasks(base_task, end_date) if repeat_until.present?
        Result.new(success?: true, task: base_task)
      else
        Result.new(success?: false, task: base_task)
      end
    end

    private

    def validate_repeat_until(base_task, repeat_until)
      return nil if repeat_until.blank?

      begin
        end_date = Date.parse(repeat_until)
      rescue ArgumentError
        base_task.errors.add(:repeat_until, "is not a valid date")
        return nil
      end

      if base_task.due_date.blank?
        base_task.errors.add(:due_date, "is required when repeating tasks")
        return nil
      end

      if end_date < base_task.due_date
        base_task.errors.add(:repeat_until, "must be after due date")
        return nil
      end

      end_date
    end

    def create_repeated_tasks(base_task, end_date)
      (1..(end_date - base_task.due_date).to_i).each do |i|
        Task.create(
          base_task.attributes.except("id", "created_at", "updated_at").merge(
            "due_date" => base_task.due_date + i.days,
            "start_date" => base_task.start_date ? base_task.start_date + i.days : nil
          )
        )
      end
    end
  end
end

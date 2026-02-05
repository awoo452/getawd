module Calendar
  class ShowData
    Result = Struct.new(:tasks, :this_months_tasks, keyword_init: true)

    def self.call
      new.call
    end

    def call
      range = Time.zone.today.beginning_of_month..Time.zone.today.end_of_month
      tasks = Task.includes(:goal).where(due_date: range)

      Result.new(tasks: tasks, this_months_tasks: tasks)
    end
  end
end

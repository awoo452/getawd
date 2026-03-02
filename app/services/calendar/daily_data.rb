module Calendar
  class DailyData
    Result = Struct.new(:tasks, :start_date, keyword_init: true)

    def self.call(start_date: nil)
      new(start_date: start_date).call
    end

    def initialize(start_date: nil)
      @start_date = parse_start_date(start_date)
    end

    def call
      tasks = Task.includes(:goal).where(due_date: @start_date.to_date)
      Result.new(tasks: tasks, start_date: @start_date)
    end

    private

    def parse_start_date(value)
      return Time.zone.today if value.blank?

      Date.parse(value).in_time_zone
    rescue ArgumentError
      Time.zone.today
    end
  end
end

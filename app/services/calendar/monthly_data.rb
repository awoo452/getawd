module Calendar
  class MonthlyData
    Result = Struct.new(:tasks, :start_date, keyword_init: true)

    def self.call(start_date: nil)
      new(start_date: start_date).call
    end

    def initialize(start_date: nil)
      @start_date = parse_start_date(start_date)
    end

    def call
      month_range = @start_date.beginning_of_month..@start_date.end_of_month
      tasks = Task.includes(:goal).where(due_date: month_range)

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

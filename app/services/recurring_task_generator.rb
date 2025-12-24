class RecurringTaskGenerator
  def self.run_for(date = Date.today)
    Goal.where(recurring: true, priority: 1).find_each do |goal|
      next if Task.exists?(goal: goal, due_date: date)

      Task.create!(
        task_name: goal.title,
        description: goal.description,
        goal: goal,
        priority: 1,
        start_date: date,
        due_date: date,
        estimated_time: default_estimated_time(goal),
        actual_time: 0,
        status: :not_started
      )
    end
  end

  def self.default_estimated_time(goal)
    case goal.title
    when /med/i then 5
    when /dog/i then 5
    when /meal/i then 30
    else 15
    end
  end
end
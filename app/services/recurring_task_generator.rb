class RecurringTaskGenerator
  def self.run_for(date = Time.zone.today)
    Goal.where(recurring: true).find_each do |goal|
      next if Task.exists?(goal: goal, due_date: date)

      Task.create!(
        task_name: goal.title,
        description: goal.description,
        goal: goal,
        priority: goal.priority,
        start_date: date,
        due_date: date,
        estimated_time: default_estimated_time(goal),
        actual_time: 0,
        status: :not_started
      )
    end
  end

  def self.default_estimated_time(goal)
    title = goal.title.downcase

    case title
    when /med/
      5
    when /feed dog/
      5
    when /walk dog/
      30
    when /chore/
      30
    when /strength/
      5
    when /meal/
      30
    when /career/
      30
    when /hydration/
      15
    when /shower/
      15
    when /household/
      30
    else
      60
    end
  end

end
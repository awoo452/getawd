class RecurringTaskGenerator
  def self.run_for(date = Time.zone.today)
    Goal.where(recurring: true).find_each do |goal|
      if goal.assignment_pool&.active?
        create_assignment_tasks(goal, goal.assignment_pool, date)
        next
      end

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
        status: :not_started,
        eligible_reward: goal.eligible_reward
      )
    end
  end

  def self.create_assignment_tasks(goal, pool, date)
    week_start = date.beginning_of_week

    pool.assignment_items.active.daily.find_each do |item|
      next if assignment_logged?(item, date, week_start)

      create_assignment_task(goal, item, date, week_start)
    end

    weekly_item = select_weekly_item(pool, week_start)
    return unless weekly_item
    return if assignment_logged?(weekly_item, date, week_start)

    create_assignment_task(goal, weekly_item, date, week_start)
  end

  def self.select_weekly_item(pool, week_start)
    existing_weekly = pool.assignment_logs
      .joins(:assignment_item)
      .where(week_start: week_start, assignment_items: { frequency: "weekly" })
      .exists?
    return nil if existing_weekly

    candidates = pool.assignment_items.active.weekly
    return nil if candidates.empty?

    candidates.order(Arel.sql("RANDOM()")).first
  end

  def self.assignment_logged?(item, date, week_start)
    if item.daily?
      AssignmentLog.exists?(assignment_item: item, assigned_on: date)
    elsif item.weekly?
      AssignmentLog.exists?(assignment_item: item, week_start: week_start)
    else
      AssignmentLog.exists?(assignment_item: item, assigned_on: date)
    end
  end

  def self.create_assignment_task(goal, item, date, week_start)
    task = Task.create!(
      task_name: assignment_task_name(goal, item),
      description: goal.description,
      goal: goal,
      priority: goal.priority,
      start_date: date,
      due_date: date,
      estimated_time: item.estimated_time || default_estimated_time(goal),
      actual_time: 0,
      status: :not_started,
      eligible_reward: goal.eligible_reward
    )

    AssignmentLog.create!(
      assignment_item: item,
      task: task,
      assigned_on: date,
      week_start: week_start
    )
  end

  def self.assignment_task_name(goal, item)
    return goal.title if item.label.blank?

    "#{goal.title} — #{item.label}"
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
      15
    when /strength/
      5
    when /meal/
      30
    when /career/
      30
    when /hydration/
      10
    when /shower/
      15
    when /household/
      30
    else
      30
    end
  end

end

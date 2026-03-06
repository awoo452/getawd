class RecurringTaskGenerator
  def self.run_for(date = Time.zone.today)
    date = date.to_date

    Goal.joins(:assignment_pool).merge(AssignmentPool.active).find_each do |goal|
      create_assignment_tasks(goal, goal.assignment_pool, date)
    end

    RecurringTask.active.find_each do |recurring_task|
      start_on = recurring_task.start_date || recurring_task.due_date
      next if start_on.present? && date < start_on
      next if Task.exists?(recurring_task: recurring_task, due_date: date)

      Task.create!(
        task_name: recurring_task.task_name,
        description: recurring_task.description,
        goal: recurring_task.goal,
        priority: recurring_task.priority,
        start_date: date,
        due_date: date,
        estimated_time: recurring_task.estimated_time || recurring_task.goal&.estimated_daily_task_time || 30,
        actual_time: recurring_task.actual_time || 0,
        status: recurring_task.status || :not_started,
        hold_until: recurring_task.hold_until,
        assigned_to: recurring_task.assigned_to,
        completion_date: recurring_task.completion_date,
        eligible_reward: recurring_task.eligible_reward,
        smart: recurring_task.smart,
        recurring_task: recurring_task
      )
    end
  end

  def self.create_assignment_tasks(goal, pool, date)
    week_start = date.beginning_of_week(:sunday)
    reset_weekly_items_if_needed(pool, date, week_start)

    pool.assignment_items.active.daily.find_each do |item|
      next if assignment_logged?(item, date, week_start)

      create_assignment_task(goal, item, date, week_start)
    end

    return if weekly_assigned_for_date?(pool, date)

    weekly_item = select_weekly_item(pool)
    return unless weekly_item
    return if assignment_logged?(weekly_item, date, week_start)

    create_assignment_task(goal, weekly_item, date, week_start)
  end

  def self.select_weekly_item(pool)
    candidates = pool.assignment_items.active.weekly
    return nil if candidates.empty?

    candidates.order(Arel.sql("RANDOM()")).first
  end

  def self.weekly_assigned_for_date?(pool, date)
    pool.assignment_logs
      .joins(:assignment_item)
      .where(assigned_on: date, assignment_items: { frequency: "weekly" })
      .exists?
  end

  def self.assignment_logged?(item, date, week_start)
    if item.daily?
      AssignmentLog.exists?(assignment_item: item, assigned_on: date)
    elsif item.weekly?
      AssignmentLog.exists?(assignment_item: item, assigned_on: date)
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
      estimated_time: item.estimated_time || goal.estimated_daily_task_time || 30,
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

    item.update!(active: false) if item.weekly?
  end

  def self.reset_weekly_items_if_needed(pool, date, week_start)
    return unless date == week_start

    pool.assignment_items.weekly.update_all(active: true)
  end

  def self.assignment_task_name(goal, item)
    return goal.title if item.label.blank?

    "#{goal.title} — #{item.label}"
  end

end

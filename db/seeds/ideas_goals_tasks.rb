# db/seeds/ideas_goals_tasks.rb

today = Date.current
yesterday = today - 1.day

statuses = %w[not_started in_progress on_hold completed]
categories = %w[health career household learning fitness social]

idea_titles = [
  "Web Development",
  "Health & Fitness",
  "Career Growth",
  "Household",
  "Learning",
  "Social"
]

ideas = idea_titles.map do |title|
  Idea.create!(title: "#{title} Idea")
end

goals_by_level = { 1 => [], 2 => [], 3 => [] }

ideas.each_with_index do |idea, idx|
  (1..3).each do |level|
    goal = Goal.create!(
      title: "#{idea.title} Goal L#{level}-#{idx + 1}",
      description: "Goal for #{idea.title} at level #{level}",
      priority: level,
      status: Goal.statuses[statuses.sample],
      idea: idea,
      recurring: [true, false].sample,
      eligible_reward: "Reward L#{level} Item #{idx + 1}",
      category: categories.sample
    )
    goals_by_level[level] << goal
  end
end

# Create 5 tasks per level for today and yesterday
[today, yesterday].each do |date|
  (1..3).each do |level|
    5.times do |i|
      goal = goals_by_level[level].sample
      status = statuses.sample

      Task.create!(
        task_name: "Level #{level} Task #{i + 1} (#{date})",
        description: "Task for level #{level} on #{date}",
        status: Task.statuses[status],
        priority: level,
        start_date: date,
        due_date: date,
        estimated_time: [5, 10, 15, 30].sample,
        actual_time: [0, 5, 10, 15].sample,
        goal: goal,
        eligible_reward: "Level #{level} reward item"
      )
    end
  end
end

# Extra task volume for pagination testing
50.times do |i|
  goal = goals_by_level.values.flatten.sample
  status = statuses.sample
  date = today - rand(0..14).days

  Task.create!(
    task_name: "Extra Task #{i + 1}",
    description: "Extra seeded task #{i + 1}",
    status: Task.statuses[status],
    priority: [1, 2, 3].sample,
    start_date: date,
    due_date: date,
    estimated_time: [5, 10, 15, 30, 60].sample,
    actual_time: [0, 5, 10, 15, 30].sample,
    goal: goal
  )
end

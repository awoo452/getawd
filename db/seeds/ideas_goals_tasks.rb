# db/seeds/ideas_goals_tasks.rb

today = Date.current

# -------------------------
# Level 1
# -------------------------
idea1 = Idea.create!(
  title: "Web Development Idea - Level 1"
)

goal1 = Goal.create!(
  title: "Web Development Goal - Level 1",
  description: "Web Development Goal - Level 1",
  priority: 1,
  status: 0,
  idea: idea1,
  recurring: true,
  eligible_reward: "Buy DDR5 Ram"
)

Task.create!(
  task_name: "Web Development Task - Level 1",
  description: "Web Development Task - Level 1",
  status: 0,
  priority: 1,
  start_date: today,
  due_date: today,
  estimated_time: 5,
  actual_time: 0,
  goal: goal1,
  eligible_reward: "Buy DDR5 Ram"
)

# -------------------------
# Level 2
# -------------------------
idea2 = Idea.create!(
  title: "Web Development Idea - Level 2"
)

goal2 = Goal.create!(
  title: "Web Development Goal - Level 2",
  description: "Web Development Goal - Level 2",
  priority: 2,
  status: 0,
  idea: idea2,
  recurring: true,
  eligible_reward: "Buy GPU"
)

Task.create!(
  task_name: "Web Development Task - Level 2",
  description: "Web Development Task - Level 2",
  status: 0,
  priority: 2,
  start_date: today,
  due_date: today,
  estimated_time: 5,
  actual_time: 0,
  goal: goal2,
  eligible_reward: "Buy GPU"
)

# -------------------------
# Level 3
# -------------------------
idea3 = Idea.create!(
  title: "Web Development Idea - Level 3"
)

goal3 = Goal.create!(
  title: "Web Development Goal - Level 3",
  description: "Web Development Goal - Level 3",
  priority: 3,
  status: 0,
  idea: idea3,
  recurring: true,
  eligible_reward: "Buy Processor"
)

Task.create!(
  task_name: "Web Development Task - Level 3",
  description: "Web Development Task - Level 3",
  status: 0,
  priority: 3,
  start_date: today,
  due_date: today,
  estimated_time: 5,
  actual_time: 0,
  goal: goal3,
  eligible_reward: "Buy Processor"
)

# -------------------------
# Hydration (Level 1)
# -------------------------
idea4 = Idea.create!(
  title: "Hydration - Level 1"
)

goal4 = Goal.create!(
  title: "Daily Hydration",
  description: "Drink enough water today",
  priority: 1,
  status: 0,
  idea: idea4,
  recurring: true,
  eligible_reward: "Sparkling Water"
)

Task.create!(
  task_name: "Hydration",
  description: "Drink water throughout the day",
  status: 0,
  priority: 1,
  start_date: today,
  due_date: today,
  estimated_time: 1,
  actual_time: 0,
  goal: goal4,
  eligible_reward: "Sparkling Water"
)
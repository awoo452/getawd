Idea.create!(
  id: 1,
  title: "Web Development Idea - Level 1",
  created_at: Time.current,
  updated_at: Time.current
)

Goal.create!(
  id: 1,
  title: "Web Development Goal - Level 1",
  description: "Web Development Goal - Level 1",
  priority: 1,
  status: 0,
  idea_id: 1,
  smart: {},
  recurring: true,
  eligible_reward: 'Buy DDR5 Ram',
  created_at: Time.current,
  updated_at: Time.current
)

Task.create!(
  id: 1,
  task_name: "Web Development Task - Level 1",
  description: "Web Development Task - Level 1",
  status: 0,
  priority: 1,
  start_date: Date.current,
  due_date: Date.current,
  completion_date: nil,
  assigned_to: "",
  estimated_time: 5,
  actual_time: 0,
  goal_id: 1,
  smart: {
    relevant: "",
    specific: "",
    attainable: "",
    measurable: "",
    time_bound: ""
  },
  eligible_reward: 'Buy DDR5 Ram',
  created_at: Time.current,
  updated_at: Time.current
)

Idea.create!(
  id: 2,
  title: "Web Development Idea - Level 2",
  created_at: Time.current,
  updated_at: Time.current
)

Goal.create!(
  id: 2,
  title: "Web Development Goal - Level 2",
  description: "Web Development Goal - Level 2",
  priority: 2,
  status: 0,
  idea_id: 2,
  smart: {},
  recurring: true,
  eligible_reward: 'Buy GPU',
  created_at: Time.current,
  updated_at: Time.current
)

Task.create!(
  id: 2,
  task_name: "Web Development Task - Level 2",
  description: "Web Development Task - Level 2",
  status: 0,
  priority: 2,
  start_date: Date.current,
  due_date: Date.current,
  completion_date: nil,
  assigned_to: "",
  estimated_time: 5,
  actual_time: 0,
  goal_id: 2,
  smart: {
    relevant: "",
    specific: "",
    attainable: "",
    measurable: "",
    time_bound: ""
  },
  eligible_reward: 'Buy GPU',
  created_at: Time.current,
  updated_at: Time.current
)

Idea.create!(
  id: 3,
  title: "Web Development Idea - Level 3",
  created_at: Time.current,
  updated_at: Time.current
)

Goal.create!(
  id: 3,
  title: "Web Development Goal - Level 3",
  description: "Web Development Goal - Level 3",
  priority: 3,
  status: 0,
  idea_id: 3,
  smart: {},
  recurring: true,
  eligible_reward: 'Buy Processor',
  created_at: Time.current,
  updated_at: Time.current
)

Task.create!(
  id: 3,
  task_name: "Web Development Task - Level 3",
  description: "Web Development Task - Level 3",
  status: 0,
  priority: 3,
  start_date: Date.current,
  due_date: Date.current,
  completion_date: nil,
  assigned_to: "",
  estimated_time: 5,
  actual_time: 0,
  goal_id: 3,
  smart: {
    relevant: "",
    specific: "",
    attainable: "",
    measurable: "",
    time_bound: ""
  },
  eligible_reward: 'Buy Processor',
  created_at: Time.current,
  updated_at: Time.current
)

Idea.create!(
  id: 4,
  title: "Hydration - Level 1",
  created_at: Time.current,
  updated_at: Time.current
)

Goal.create!(
  id: 4,
  title: "Daily Hydration",
  description: "Drink enough water today",
  priority: 1,
  status: 0,
  idea_id: 4,
  smart: {},
  recurring: true,
  eligible_reward: 'Sparkling Water',
  created_at: Time.current,
  updated_at: Time.current
)

Task.create!(
  id: 4,
  task_name: "Hydration",
  description: "Drink water throughout the day",
  status: 0,
  priority: 1,
  start_date: Date.current,
  due_date: Date.current,
  completion_date: nil,
  assigned_to: "",
  estimated_time: 1,
  actual_time: 0,
  goal_id: 4,
  smart: {},
  eligible_reward: 'Sparkling Water',
  created_at: Time.current,
  updated_at: Time.current
)

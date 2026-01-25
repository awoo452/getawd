today = Date.current

# Level rewards for recent days
[today, today - 1.day, today - 2.days].each do |date|
  (1..3).each do |level|
    Reward.create!(
      name: "Level #{level} Earned",
      kind: "earned",
      scope: "level",
      reward_payload: {
        level: level,
        earned_date: date.to_s
      }
    )
  end
end

# Some redeemed and completed level rewards
Reward.where(kind: "earned", scope: "level").limit(3).each do |reward|
  reward.update!(
    kind: "redeemed",
    reward_payload: reward.reward_payload.merge(
      redeemed_at: Time.zone.now
    )
  )
end

Reward.where(kind: "redeemed", scope: "level").limit(2).each do |reward|
  reward.update!(
    kind: "completed",
    completed_reward_url: "s3://raw/gameplay/#{reward.id}",
    completed_reward_notes: "Seeded completion notes"
  )
end

# Task rewards (earned) for recent tasks
Task.order(created_at: :desc).limit(10).each do |task|
  reward = Reward.create!(
    scope: "task",
    kind: "earned",
    reward_payload: {
      task_id: task.id,
      goal_id: task.goal_id,
      level: task.priority,
      item: "Seeded task reward",
      earned_date: (task.completion_date || task.due_date || today).to_s
    }
  )
  RewardTask.create!(reward: reward, task: task)
end

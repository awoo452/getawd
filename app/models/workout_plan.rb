class WorkoutPlan < ApplicationRecord
  TYPES = %w[run body_combat pushups rest].freeze

  LABELS = {
    "run"          => "Run",
    "body_combat"  => "Body Combat",
    "pushups"      => "100 Pushups",
    "rest"         => "Rest Day"
  }.freeze

  EMOJIS = {
    "run"          => "🏃",
    "body_combat"  => "🥊",
    "pushups"      => "💪",
    "rest"         => "😴"
  }.freeze

  GOAL_TITLES = {
    "run"         => "Tacoma City Half Marathon",
    "body_combat" => "Tacoma City Half Marathon",
    "pushups"     => "Strength Training",
    "rest"        => nil
  }.freeze

  ESTIMATED_TIMES = {
    "run"         => 30,
    "body_combat" => 45,
    "pushups"     => 10,
    "rest"        => 0
  }.freeze

  belongs_to :task, optional: true

  enum :workout_type, { run: 0, body_combat: 1, pushups: 2, rest: 3 }

  validates :planned_on,   presence: true
  validates :workout_type, presence: true
  validates :planned_on,   uniqueness: true

  after_create  :generate_task
  before_update :sync_task_name, if: :workout_type_changed?
  before_destroy :remove_task

  def label = LABELS[workout_type]
  def emoji = EMOJIS[workout_type]

  private

  def generate_task
    title = GOAL_TITLES[workout_type]
    t = Task.create!(
      task_name:      task_label,
      goal:           title ? Goal.find_by(title: title) : nil,
      due_date:       planned_on,
      start_date:     planned_on,
      priority:       2,
      estimated_time: ESTIMATED_TIMES[workout_type],
      actual_time:    0,
      status:         :not_started
    )
    update_column(:task_id, t.id)
  end

  def sync_task_name
    task&.update!(task_name: task_label)
  end

  def remove_task
    task&.destroy
    self.task_id = nil
  end

  def task_label
    case workout_type
    when "run"         then "Cardio — Run"
    when "body_combat" then "Cardio — Body Combat"
    when "pushups"     then "Strength — 100 Pushups"
    when "rest"        then "Rest Day"
    end
  end
end

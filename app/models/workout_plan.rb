class WorkoutPlan < ApplicationRecord
  TYPES = %w[walk vr board_push board_pull rest].freeze

  LABELS = {
    "walk"       => "Dog Walk",
    "vr"         => "VR Workout",
    "board_push" => "Board: Chest & Triceps",
    "board_pull" => "Board: Shoulders & Back",
    "rest"       => "Rest Day"
  }.freeze

  EMOJIS = {
    "walk"       => "🦮",
    "vr"         => "🥊",
    "board_push" => "💪",
    "board_pull" => "🏋️",
    "rest"       => "😴"
  }.freeze

  GOAL_TITLES = {
    "walk"       => "Cardio Fitness",
    "vr"         => "Cardio Fitness",
    "board_push" => "Strength Training",
    "board_pull" => "Strength Training",
    "rest"       => nil
  }.freeze

  TARGETS = {
    "walk"       => 2,
    "vr"         => 2,
    "board_push" => 1,
    "board_pull" => 1,
    "rest"       => 1
  }.freeze

  ESTIMATED_TIMES = {
    "walk"       => 45,
    "vr"         => 45,
    "board_push" => 30,
    "board_pull" => 30,
    "rest"       => 0
  }.freeze

  belongs_to :task, optional: true

  enum :workout_type, { walk: 0, vr: 1, board_push: 2, rest: 3, board_pull: 4 }

  validates :planned_on,   presence: true
  validates :workout_type, presence: true
  validates :planned_on,   uniqueness: true

  after_create  :generate_task
  before_update :sync_task_name, if: :workout_type_changed?
  after_update  :sync_completion_to_task, if: :saved_change_to_completed?
  after_update  :sync_notes_to_task, if: :saved_change_to_notes?
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

  def sync_completion_to_task
    if completed?
      task&.update!(status: :completed, completion_date: planned_on)
    else
      task&.update!(status: :not_started, completion_date: nil)
    end
  end

  def sync_notes_to_task
    task&.update!(description: notes)
  end

  def remove_task
    task&.destroy
    self.task_id = nil
  end

  def task_label
    case workout_type
    when "walk"       then "Cardio — Dog Walk"
    when "vr"         then "Cardio — VR Workout"
    when "board_push" then "Strength — Chest & Triceps"
    when "board_pull" then "Strength — Shoulders & Back"
    when "rest"       then "Rest Day"
    end
  end
end

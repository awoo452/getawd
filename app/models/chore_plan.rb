class ChorePlan < ApplicationRecord
  TYPES = %w[sweep_mop bathroom kitchen vacuum laundry garbage organization].freeze

  LABELS = {
    "sweep_mop"    => "Sweep & Mop",
    "bathroom"     => "Bathroom",
    "kitchen"      => "Kitchen",
    "vacuum"       => "Vacuum",
    "laundry"      => "Laundry",
    "garbage"      => "Garbage",
    "organization" => "Organization"
  }.freeze

  EMOJIS = {
    "sweep_mop"    => "🧹",
    "bathroom"     => "🚿",
    "kitchen"      => "🧽",
    "vacuum"       => "🌀",
    "laundry"      => "👕",
    "garbage"      => "🗑️",
    "organization" => "📦"
  }.freeze

  belongs_to :task, optional: true

  enum :chore_type, {
    sweep_mop:    1,
    bathroom:     2,
    kitchen:      3,
    vacuum:       4,
    laundry:      5,
    garbage:      6,
    organization: 7
  }

  validates :planned_on,  presence: true
  validates :chore_type,  presence: true
  validates :planned_on,  uniqueness: { scope: :chore_type }

  after_create :generate_task
  before_destroy :remove_task

  def label = LABELS[chore_type]
  def emoji = EMOJIS[chore_type]

  private

  def generate_task
    t = Task.create!(
      task_name:      "Chores — #{label}",
      goal:           Goal.find_by(title: "Chores"),
      due_date:       planned_on,
      start_date:     planned_on,
      priority:       2,
      estimated_time: 30,
      actual_time:    0,
      status:         :not_started
    )
    update_column(:task_id, t.id)
  end

  def remove_task
    task&.destroy
    self.task_id = nil
  end
end

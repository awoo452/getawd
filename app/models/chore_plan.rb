class ChorePlan < ApplicationRecord
  TYPES        = %w[dishes sweep_mop bathroom kitchen vacuum laundry rooms organization].freeze
  DAILY_TYPES  = %w[dishes].freeze
  WEEKLY_TYPES = (TYPES - DAILY_TYPES).freeze

  LABELS = {
    "dishes"       => "Dishes",
    "sweep_mop"    => "Sweep & Mop",
    "bathroom"     => "Bathroom",
    "kitchen"      => "Kitchen",
    "vacuum"       => "Vacuum",
    "laundry"      => "Laundry",
    "rooms"        => "Rooms",
    "organization" => "Organization"
  }.freeze

  EMOJIS = {
    "dishes"       => "🍽️",
    "sweep_mop"    => "🧹",
    "bathroom"     => "🚿",
    "kitchen"      => "🧽",
    "vacuum"       => "🌀",
    "laundry"      => "👕",
    "rooms"        => "🛏️",
    "organization" => "📦"
  }.freeze

  belongs_to :task, optional: true

  enum :chore_type, {
    dishes:       0,
    sweep_mop:    1,
    bathroom:     2,
    kitchen:      3,
    vacuum:       4,
    laundry:      5,
    rooms:        6,
    organization: 7
  }

  validates :planned_on,  presence: true
  validates :chore_type,  presence: true
  validates :planned_on,  uniqueness: { scope: :chore_type }

  after_create :generate_task, if: -> { planned_on <= Time.zone.today }
  before_destroy :remove_task

  def label = LABELS[chore_type]
  def emoji = EMOJIS[chore_type]

  def self.generate_todays_tasks(date = Time.zone.today)
    where(planned_on: date, task_id: nil).find_each { |p| p.send(:generate_task) }
  end

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

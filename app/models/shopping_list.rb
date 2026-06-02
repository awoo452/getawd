class ShoppingList < ApplicationRecord
  STATUSES = %w[active archived].freeze

  has_many :shopping_list_items, dependent: :destroy
  has_many :food_items, through: :shopping_list_items

  scope :active,   -> { where(status: "active") }
  scope :archived, -> { where(status: "archived") }
  scope :recent,   -> { order(generated_on: :desc) }

  validates :status,       inclusion: { in: STATUSES }
  validates :generated_on, presence: true

  def active?   = status == "active"
  def archive!  = update!(status: "archived")

  def checked_count = shopping_list_items.where(checked_off: true).count
  def total_count   = shopping_list_items.count
  def complete?     = total_count > 0 && checked_count == total_count
end

class Idea < ApplicationRecord
  has_many :goals, dependent: :destroy
end

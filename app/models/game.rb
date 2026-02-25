class Game < ApplicationRecord
  validates :game_name, presence: true
end

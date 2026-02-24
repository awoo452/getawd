class Video < ApplicationRecord
  belongs_to :project, optional: true
end

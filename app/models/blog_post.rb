class BlogPost < ApplicationRecord
  belongs_to :project, optional: true
end

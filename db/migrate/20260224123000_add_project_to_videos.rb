class AddProjectToVideos < ActiveRecord::Migration[8.1]
  def change
    add_reference :videos, :project, foreign_key: true, index: true
  end
end

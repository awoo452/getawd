class AddProjectToBlogPosts < ActiveRecord::Migration[8.1]
  def change
    add_reference :blog_posts, :project, foreign_key: true, index: true
  end
end

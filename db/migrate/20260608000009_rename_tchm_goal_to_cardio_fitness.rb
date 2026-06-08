class RenameTchmGoalToCardioFitness < ActiveRecord::Migration[8.1]
  def up
    execute "UPDATE goals SET title = 'Cardio Fitness' WHERE title = 'Tacoma City Half Marathon'"
  end

  def down
    execute "UPDATE goals SET title = 'Tacoma City Half Marathon' WHERE title = 'Cardio Fitness'"
  end
end

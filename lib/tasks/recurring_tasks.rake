namespace :tasks do
  desc "Generate recurring tasks for today"
  task generate_recurring: :environment do
    RecurringTaskGenerator.run_for(Date.today)
  end
end
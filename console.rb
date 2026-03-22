def add_task_every_day(task_name, description)
  start_date = Date.today.beginning_of_month
  end_date = Date.today.end_of_month
  tasks = Array(task_name)

  (start_date..end_date).each do |date|
    tasks.each do |task|
      Task.find_or_create_by!(
        task_name: task,
        due_date: date
      ) do |t|
        t.description = description # Manually provided description
        t.status = 0
        t.priority = 1
        t.start_date = date
        t.estimated_time = 30
        t.created_at = Time.current
        t.updated_at = Time.current
      end
    end
  end
end

def add_task_once_weekly(weekday, task_name, description = "No description provided")
    valid_weekdays = Date::DAYNAMES.map(&:downcase)
    weekday = weekday.downcase

    unless valid_weekdays.include?(weekday)
      raise ArgumentError, "Invalid weekday. Please provide a valid weekday name (e.g., 'Monday', 'Tuesday', etc.)"
    end

    start_date = Date.today.beginning_of_month
    end_date = Date.today.end_of_month

    (start_date..end_date).each do |date|
      next unless date.strftime("%A").downcase == weekday

      Task.find_or_create_by!(
        task_name: task_name,
        due_date: date
      ) do |t|
        t.description = description # Manually provided description
        t.status = 0
        t.priority = 1
        t.start_date = date
        t.due_date = date
        t.estimated_time = 30
        t.created_at = Time.current
        t.updated_at = Time.current
      end
    end
  end

  # Task List

  add_task_once_weekly('Sunday', 'Planning', 'General SMART goals added for all daily tasks for the upcoming week. For example, 30 minutes of cardio(running) and 100 pushups is a SMART exercise goal.')
  add_task_once_weekly('Friday', 'Web Development', '1 hour of development')
  add_task_once_weekly('Thursday', 'Fabrication', '1 hour on 55 rollcage')
  add_task_once_weekly('Thursday', 'School', '30 minutes of school')

##### New blog post
BlogPost.create!(
  title: "Using the Rails Console to Quickly Populate Data",
  description: "The Rails console is a powerful tool for quickly adding and managing data without needing a full UI. Whether you're creating blog posts, adding recurring tasks, or testing new features, the console can save time and streamline development.",
  body: "<p>The Rails console is a fast and efficient way to add and update data without using the UI. Whether you're creating tasks, adding blog posts, or setting up recurring events, the console allows you to work directly with the database, saving time and reducing manual input.</p><p>Using simple commands, you can quickly populate information that would otherwise require multiple clicks in the app. This is especially useful for testing, debugging, or automating repeatable tasks like scheduled events or default records.</p>",
  image: "blog1.png",
  created_at: Time.current,
  updated_at: Time.current,
  featured: true
)

LandscapingJob.create!(
  title: "General Cleanup",
  description: "Removed weeds, trimmed hedges, and refreshed the gravel parking strip with a clean new layer.",
  image: "landscaping1.png"
)

LandscapingJob.create!(
  title: "Backyard Refresh",
  description: "Mowed, edged, and sharpened the border along the walkway. Also discovered a firepit.",
  image: "landscaping2.png"
)

LandscapingJob.create!(
  title: "Flowerbed Tidy-Up",
  description: "Cleared debris and pulled weeds from the parking strip flowerbed.",
  image: "landscaping3.png"
)

LandscapingJob.create!(
  title: "Flower Beds & More",
  description: "Cleaned out the flowerbeds and prepped for planting season. Knocked down overgrown weeds from the gravel parking strip and mowed the yard.",
  image: "landscaping4.png"
)

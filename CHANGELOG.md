# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.19.5] - 2025-11-28

### Changed
- games/show now links to the associated achievements URL (if it exists in db)
  - Within the progress_data column
  - Stored as key value pairs - { "text": "some text", "url": "https://example.com/url" }

## [1.19.4] - 2025-11-24

### Changed
- Made the corporate buzzword as discussed in push 1.19.3 actually display on the front end, which is probably important

## [1.19.3] - 2025-11-24

### Changed
- Added another corporate buzzword to the featured about text

## [1.19.2] - 2025-11-23

### Added
- Migration to add youtube playlist ID to the videos section
- Display that playlist on the games/show if it exists

## [1.19.1] – 2025-11-19

### Added
- `game_image_url` helper to resolve S3-hosted game images  
  (stored at `games/{game_id}/game{x}.png`)
- Game image display added to **Games index**
- YouTube embed, image gallery, and full progress data sections added to **Games show**
- Show page now includes three structured sections:
  - Recent Videos
  - Quick Info / Achievements / Stats
  - Image Gallery

### Updated
- Games show page now correctly parses `progress_data` when stored as a JSONB string
- Games index updated to render game cards only when `show_to_public` is true
- Reorganized show page markup for consistent layout and cleaner structure

## [1.19.0] – 2025-11-17

### Added
- `game_title` column added to `games` table, to reference actual title of game
-  `game_name` field can now be utilized for the actual title of the series or stream, etc
- `progress_data` (`jsonb`) column introduced to store achievements, stats, and quick info for each game, with ability to expand these columns.
- View logic implemented to display:
  - Achievements
  - Quick info
  - Stats from `progress_data` with humanized keys
- `show_to_public` boolean field added with default `false`, with front end support to only display games with `true` value

### Changed
- Seeds updated:
  - `game_name` now used for actual game titles
  - `game_title` now used for series titles
  - `progress_data` populated for all seeded games
- Games index updated to only list games where `show_to_public?` is `true`

## [1.18.11] 2025-11-15

### Changed
- About section
  - about `index.html.erb` added another about tile and a header
  - updated some info in `about_info.yml` to display on that page

## [1.18.10] 2025-11-15

### Added
- Lightning background added to `featured-about` section using S3-hosted image
- Created new `branding_image_url` helper for branding-related assets
- Implemented rotating text animation sequence: “Designing → Creating → Building → Developing → Deploying”
- Added translucent background for `featured-about` text container
- Introduced dedicated SCSS partial for `featured-about` styling

### Changed
- Adjusted layout to:
  - Center rotating text block over background image
  - Prevent clipping of rotating words with fixed width
  - Improve flexbox centering and overall text alignment
  - Increase text size for rotating words for better visibility

### Cleaned
- Removed unused or redundant animation attempts from previous iterations


## [1.18.9] 2025-10-26

### Changed
- Contact Info (contact_info.yml) for Twitch

## [1.18.8] 2025-10-26

### Changed
- Logo

## [1.18.7] - 2025-10-07

### Added
- Contact info - Twitch

## [1.18.6] - 2025-10-03

### Added
- Support for repeating tasks daily until a user-specified date (`repeat_until` field).
- Validation in controller to prevent `repeat_until` date from being before the initial `due_date`.

### Changed
- Simplified task creation logic by removing `repeat_type` options ("week", "month").
- Controller `create` action cleaned up with proper nesting and single redirect/render paths.
- Task form updated to only show a `repeat_until` date field for new tasks.

## [1.18.5] - 2025-09-28

### Changed
- Tasks are now sorted by priority: `nil` values appear first, followed by ascending numbers (lowest at the top, highest at the bottom).
- Some other updates made to goal / task views to center content.

## [1.18.4] - 2025-09-28

### Changed
- Consolidated duplicate `.dashboard-panel` definitions into a single block
- Split out `.status-legend` (color-coded recency) and `.time-legend` (emoji-based time stats) into separate, non-conflicting sections
- Made `.time-legend` display as a vertical stack with left-aligned items for improved readability
- Simplified `.idea-box` styles by moving `.idea-stats` handling inside each tile instead of relying on `.idea-stats-panel`
- Removed unused `.idea-stats-panel` and `.idea-stat-box` styles, as stats now live inside individual idea tiles

## [1.18.3] – 2025-09-27

### Changed
- Completing a goal toady should actually make it complete today, even if we're not in UTC. :|

## [1.18.2] – 2025-09-27

### Changed
- Added dashboard nav in ideas section of dashboard to quickly add a goal or task.

## [1.18.1] – 2025-09-27

### Added
- New `complete_on_time` member route for tasks
- `TasksController#complete_on_time` action to mark a task as completed with:
  - `completion_date = Time.zone.today`
  - `actual_time = estimated_time`
- "Complete On Time Today" button on task show page to trigger the action
- `.actions-list` class for styling action links/buttons on task and goal show pages
- New SCSS rules for `.actions-list` with centered column layout, consistent spacing, and styled dividers

### Changed
- Task show view updated to only display the "Complete On Time Today" button if the task is not already completed
- Task show page updated to render inside `.task-card` for consistency with index views
- Goal show page updated to render inside `.goal-card` for consistency with index views
- Replaced raw `<hr>` separators in show page action lists with `.divider` list items styled via SCSS

## [1.18.0] – 2025-09-17

### Added
- `paginate` helper in `ApplicationController`, reusable across controllers
- Pagination for **Goals index** and **Tasks index**, with shared partial `_pagination.html.erb`
- Shared partials `_goal_card.html.erb` and `_task_card.html.erb` to standardize goal/task card rendering
- New SCSS partials: `_dashboard.scss`, `_goals.scss`, `_tasks.scss`, `_ideas.scss`, `_colors.scss`
- `goals-list` and `tasks-list` containers with centered layout on index pages

### Changed
- `DashboardController` and views now render goals/tasks using shared partials instead of inline markup
- `GoalsController#index` and `TasksController#index` refactored to use `paginate` instead of custom pagination
- Updated SCSS structure:
  - Moved goals, tasks, ideas, and dashboard styles into their own files
  - Removed duplication
- `application.scss` slimmed down:
  - Removed legacy `.goals`, `.tasks`, `#goal`, `#task` table styles
  - Kept only global variables and shared layout rules
- Unified design:
  - Consistent centering, width, and status coloring between dashboard cards and index pages

### Fixed
- Goals on index page are now centered (previously left-aligned)
- Removed conflicting/duplicate SCSS selectors that caused inconsistent sizing for goals and tasks

## [1.17.2] - 2025-09-16

### Added
- Dashboard updates:
  - Linked each goal on the dashboard to its associated idea show page
  - Linked each task on the dashboard to its associated idea show page for context

### Changed
- Improved navigation flow between dashboard, ideas, goals, and tasks by ensuring relationships are explicitly linked
- Additional clarity added to ideas in relation to how the colors are coordinating to the ideas
- SCSS cleaned up for dashboard

## [1.17.1] -2025-09-11

### Changed
- contact follow us section needed flex wrap to avoid blowout on small screens

## [1.17.0] - 2025-09-11

### Added
- home_controller, videos_controller
  - Order of featured videos to display in decending order based on 'created_at' timestamp
  - Videos will display in order they were created, with newest record in db showing first

## [1.16.5] - 2025-08-09

### Added
- DashboardController#index now calculates `goals_count` and `tasks_count` for each idea by counting associated goals and tasks.
- Ideas section tooltip updated to display `"{goals_count} goals, {tasks_count} tasks"` instead of the idea title.
- Optional `.idea-stats` element in dashboard ideas for inline display of goals/tasks counts.

### Changed
- Updated dashboard ideas loop to pass new counts into the tooltip via `title` attribute.
- `dashboard.scss`
  - `.goal-summary` and `.task-card` updated to span 100% of their container width.

## [1.16.4] - 2025-08-08

### Changed
- Some updates to dashboard/index.html.erb
  - Showing color coded legend to understand why goals and tasks are colored the way they're colored
  - Moved new goal and new task to the summary section
  - Added some more info about info section.

## [1.16.3] - 2025-08-04

### Ideas
- Created `ideas` table and model with `title` and `emoji` attributes
- Established `has_many :goals` relationship for ideas; `goals` now `belongs_to :idea`
- Added full UI support for creating, viewing, and deleting ideas
- `Ideas#show` view lists all associated goals and their tasks

### Changed
- Goal form now supports selecting an associated idea
- Dashboard layout updated to align idea sections with consistent design
- Goals on idea show page styled with color-coding based on task recency
- Tasks under each goal are collapsed by default with a toggle to expand
- Fixed dashboard layout alignment and re-centered main content
- Updated SCSS to include `.idea-status-legend` styles for visual consistency across status indicators

### Fixed
- Prevented duplicate goal titles under the same idea

### Added
- Color-coded status legend to the top of the `ideas#show` page
- Legend displays status meaning for `.not_started`, `.in_progress`, `.on_hold`, and `.completed` with matching background/border styles

## [1.16.2] - 2025-08-04
### Ideas

### Added
- Emoji tiles on dashboard now wrap to multiple lines using `flex-wrap: wrap`
- Hovering over each emoji now shows the `Idea` title as a tooltip via the `title` attribute

### Changed
- Dashboard controller now includes `title:` in each emoji tile hash for hover display

## [1.16.1] - 2025-08-04
### Ideas

### Added
- `IdeasController#show` displays emoji from `idea_icons.yml` and lists associated goals and tasks
- New route for `ideas#show` to enable drilldown per idea
- Dashboard view: each emoji now links to its corresponding idea show page
- Dashboard controller: includes `id:` in emoji data to support linking
- `app/views/ideas/show.html.erb` renders:
  - Icon for the idea (from YAML config)
  - All goals under that idea
  - All tasks under each goal

## [1.16.0] - 2025-08-04
### Ideas

### Added
- **Idea model** with `has_many :goals` association
- `idea_id:references` added to **goals** table via migration
- `config/idea_icons.yml` created to define emoji icons per idea title
- `IDEAS` constant initialized using `YAML.load_file(...).with_indifferent_access`

### Linked
- `Goal` model now `belongs_to :idea`
- Dashboard controller updated to:
  - Load all ideas with associated goals and tasks
  - Compute latest task completion per idea
  - Assign background color based on recency
  - Display emoji icon per idea from YAML config

### UI/UX
- Dashboard view updated to show idea emojis in a horizontal bar with status-based background color
- `.ideas-indicator` and `.idea-icon` styled for alignment and responsive layout

### Seed Data
- Added `Idea` records for: Fitness, Career, Social, Travel, Learning
- Added corresponding `Goal` records linked to ideas
- Added sample `Task` records linked to goals

## [1.15.4] - 2025-08-02
### Verified
- Rails version `7.1.4.1` and Ruby version `3.2.2` confirmed consistent across macOS and WSL
- `.ruby-version` file matches system configuration

### Added
- `Procfile` with `web: bundle exec puma -C config/puma.rb` for Heroku deployment

### Changed
- `config/puma.rb`: cleaned up configuration to ensure proper boot behavior on Heroku
- `config/database.yml`:
  - Removed hardcoded production credentials
  - Switched to `ENV["DATABASE_URL"]` for Heroku compatibility
  - Removed unused `test` block

### Maintenance
- Backed up Heroku Postgres DB via `pg:backups:capture` and downloaded latest `.dump`
- Upgraded Heroku CLI on macOS via Homebrew


## [1.15.3] - 2025-08-02
### Adding fallbacks to display the logo in the event the image is broken

## [1.15.2] - 2025-08-02
### Changed
- **`app/views/layouts/_navbar.html.erb`**
  - Replaced local `logo.png` with S3-hosted version via `logo_url` helper.
  
- **`app/views/about/index.html.erb`**
  - Updated all about section images to use `about_image_url(num)` helper for S3-hosted images.
  
- **`app/views/blog_posts/index.html.erb`**, **`blog_posts/show.html.erb`**
  - Replaced local blog post images with S3-hosted versions via `blog_image_url(filename)`.
  
- **`app/views/projects/index.html.erb`**
  - Replaced all project images with S3 URLs using `project_image_url(filename)` helper.
  
- **`app/views/landscaping_jobs/index.html.erb`**
  - Updated landscaping job images to use S3-hosted URLs via `landscaping_image_url(filename)` helper.

### Added
- **`application_helper.rb`**
  - `logo_url`, `about_image_url(num)`, `blog_image_url(filename)`,  
    `project_image_url(filename)`, and `landscaping_image_url(filename)` helpers.

### Removed
- Local assets from `app/assets/images/` now hosted on S3:
  - `about1.png` to `about3.png`, `blogx.png`, `projectx.png`, `landscapingx.png`, etc.

## [1.15.1] - 2025/08/01
### Setting bucket to public altogether, will only be used for public facing images.

## [1.15.0] - 2025/08/01
### Added
- **`config/s3.yml`**
  - Environment-specific bucket, region, and access key config for AWS S3
- **`app/services/s3_service.rb`**
  - Service class to upload and access files from S3, supports public/private files
- **`Gemfile`**
  - Added `aws-sdk-s3` for S3 integration

## [1.14.5] - 2025/07/30
### Changed
- **`rewards/index.html.erb`**
  - Added link to create a new reward.  
  - Enhanced layout and presentation with new styles.

- **`_rewards.scss`**
  - Added styling for the new link and general layout improvements.

## [1.14.4] - 2025/07/30
### Changed
- **`rewards_controller.rb`**
  - Only shows tasks that are incomplete when associating a new reward

## [1.14.3] - 2025/07/30
### Thanks Rails for throwing a credential pity party

## [1.14.2] - 2025/07/30
### RePrecompile my balls
- https://stackoverflow.com/questions/19650621/heroku-upload-precompiling-assets-failed
- Removing this line, not necessary and the issue was actually related to SCSS, where I was calling variables that didn't exist.

## [1.14.1] - 2025/07/29
### Precompile my balls
- https://stackoverflow.com/questions/19650621/heroku-upload-precompiling-assets-failed

## [1.14.0] - 2025/07/29
### Rewards System Integration

### Added
- **Models**
  - `Reward`: Belongs to a goal; may require specific tasks for eligibility.
  - `RewardRule`: Supports rule-based criteria (e.g., task streaks, calories) associated with a reward.
  - `RewardTask`: Joins specific tasks to rewards when needed.

- **Controllers / Actions**
  - `rewards#index`: Displays all rewards, their status, associated tasks, and available actions.
  - `rewards#new`, `rewards#create`: Enables frontend creation of rewards.
  - `rewards#redeem`: Allows users to redeem eligible rewards.
  - `rewards#evaluate`: Manually re-evaluate rule-based availability.
  - `rewards#destroy`: Supports frontend deletion of rewards.

- **Rule Logic**
  - Implemented flexible rule parsing from `task_name` and `description`.
    - Supports custom conditions like `run_streak`, `calorie_limit`, etc.
  - `eligible?` logic determines if a reward can be redeemed.

### Changed
- **Views / Layout**
  - Applied `.rewards`, `.reward-card`, `.btn` styles for consistent UI.
  - Forms use a two-column layout with full-width fields for readability.
  - Tasks listed under each reward include `link_to` helpers for quick editing access.
  - Synced buttons with backend routes (redeem, evaluate, delete).

### Notes
- Initial integration focuses on task-based reward criteria.
- System is structured for future expansion of rule types and reward logic.
- Displays on dashboard, with link to rewards.

## [1.13.12] - 2025/07/012
### Time Zone Consistency Fixes (Continued...)

### Changed
- **`dashboard_controller.rb`**
  - Replaced all instances of `Date.today` with `Time.zone.today` to ensure date filtering aligns with the app's configured time zone (Pacific).

- **`dashboard/index.html.erb`**
  - Updated all date-based filter links (`tasks_path`, `goals_path`) to use `Time.zone.today` instead of `Date.today`.

- **`tasks_controller.rb`**, **`goals_controller.rb`**
  - Replaced `Date.parse(params[:due])` with `Time.zone.parse(params[:due]).to_date` to prevent UTC-related offset bugs when filtering by due date.

### Notes
- Fully resolves discrepancies between user-visible dates and system time behavior.
- Improves accuracy and consistency of all date-based filtering.


## [1.13.11] - 2025/07/11
### Time Zone Fixes & Contact/About Updates

### Changed
- **`calendar_controller.rb`**, **`dashboard_controller.rb`**
  - Replaced `Date.today` with `Time.zone.today` to fix time zone bug causing tasks to appear a day early (due to UTC vs. Pacific mismatch).

- **`contact_info.yml`**, **`contact/index.html.erb`**
  - Added YouTube info to contact section.

### Added
- **About Section**
  - Added two new images of me.

## [1.13.10] - 2025/07/07
### Time Tracking Scoped to Today

### Added
- **`dashboard_controller.rb`**
  - Introduced `@total_estimated_minutes_today`, `@total_actual_minutes_today`, and `@time_remaining_minutes_today` to calculate workload metrics for tasks due **today** (excluding completed).

### Changed
- **`dashboard/index.html.erb`**
  - Updated summary section to display time remaining for today:
    - Total estimated vs. actual time
    - Remaining time shown clearly for focused daily planning

### Notes
- Improves visibility into today's effort without noise from future/past tasks.

## [1.13.9] - 2025/07/07
### Dashboard Summary Expansion & Filtering Fixes

### Added
- **`dashboard_controller.rb`**
  - Introduced `@due_today_tasks_*` and `@due_today_goals_*` for each status (`not_started`, `in_progress`, `on_hold`, `completed`).
  - Calculated `@total_estimated_minutes`, `@total_actual_minutes`, and `@time_remaining_minutes` to track overall time performance.

### Changed
- **`goals_controller.rb`**
  - Removed legacy `completed_at` logic that was interfering with `status=completed` filtering.

- **`dashboard/index.html.erb`**
  - Expanded summary section to show:
    - “Due Today” counts for each goal/task status, linked to filtered views.
    - Total time remaining, calculated from estimated minus actual task time.

### Notes
- Further refines the dashboard into a high-level performance view.
- Filtering logic now behaves as expected for completed goals.

## [1.13.8] - 2025/07/07
### Filtering Overhaul & Dashboard Summary

### Added
- **`dashboard_controller.rb`**
  - Introduced `@goal_counts` and `@task_counts` hashes to count goals and tasks by status.
  - Added `@due_today_goals` and `@due_today_tasks` for tracking items due today with "not started" status.

- **`dashboard/index.html.erb`**
  - New summary section showing:
    - Goal/task counts by status (linked to filtered index views).
    - Due-today goal/task counts (also linked).

### Changed
- **`tasks_controller.rb`**
  - Replaced legacy filtering with `params[:status]` and `params[:due]`.
  - Default behavior hides `on_hold` and `completed` unless specified via params.
  - Added support for filtering by due date.

- **`goals_controller.rb`**
  - Implemented identical filtering system using `params[:status]` and `params[:due]`.

- **`tasks/index.html.erb`**
  - Replaced broken checkboxes with a functional status dropdown (auto-submits).
  - Search form and pagination updated to preserve `status` and `search` filters.
  - Sort links now retain all current filters using `params.to_unsafe_h.merge(...)`.

- **`goals/index.html.erb`**
  - Same improvements as `tasks/index`:
    - Status dropdown
    - Filter-preserving pagination and sort links

### Notes
- Significantly improves filtering UX across dashboard, tasks, and goals.
- Adds visibility into due-today items for better daily planning.

## [1.13.7] - 2025/07/06  
### Seed File Fixes & Repeatable Tasks

### Changed
- **`seeds/goals.rb`**
  - Updated to reflect the correct `status` values after enum changes in [1.12.30].
- **`repeatable_tasks.rb`**, **`.gitignore`**
  - Added repeatable task commands for convenience; file ignored from version control.

## [1.13.6] - 2025/07/01
### Bug Fixes & Clarity Improvements

### Changed
- **`tasks/show.html.erb`**
  - Fixed mislabeled button that incorrectly said "Delete goal" instead of "Delete task".
- **`calendar/show.html.erb`**
  - Daily calendar now displays the task name for better clarity.

## [1.13.5] - 2025/06/17
### Gaming Version Control Implementation, Necessary to Improve Goal Tracking, Checkpoints, Calculation of Related Metrics, and Ultimately an Increase of Productivity Across the Entirety of the Gaming Platform this Section Supports. The Numbers Mason.

### Changed
- **Database**:
  - Developed insert statement to add information to DB for first series
- **`games/index.html.erb`**: 
  - Removed game_notes from games/index
- **`stylesheets/application.html.erb`**, **`games/show.html.erb`**: 
- Updating to apply style to each individual game section on the show (was referencing game class, needed to reference game id)

## [1.13.4] - 2025/06/17
### Navigation Clean-Up

### Added
- **`dashboard/index.html.erb`**  
  - Added links to create new tasks and goals directly from the dashboard.

### Changed
- **`goals/show.html.erb`**, **`tasks/show.html.erb`**
  - Reorganized sub-navigation layout to reduce clutter and improve usability.  
  - Moved delete buttons to avoid accidental clicks.
  - Converted sub-nav to unordered list with inline styles (temporary solution; further styling needed and there's nothing more permanent than a temporary solution :D).


## [1.13.3] - 2025/06/10
### Form Styling Updates

### Changed
- **`goal_icons.yml`**
  - Added additional emojis for goal categories.
- **`goals/_form.html.erb`**, **`tasks/_form.html.erb`**, **`_form.scss`**
  - Updated the description field to use a larger `<textarea>` for better usability.

## [1.13.2] - 2025/06/10
### Form Styling Updates

### Changed
- **`tasks/_form.html.erb`**, **`goals/_form.html.erb`**, **`_form.scss`**
  - Applied unified styling inspired by the "Not Started" card layout for input sections.
- **`tasks/new.html.erb`**, **`tasks/edit.html.erb`**, **`goals/new.html.erb`**, **`goals/edit.html.erb`**
  - Centered `<h1>` headers for improved visual hierarchy.

## [1.13.1] - 2025/06/09 (Nice)
### Dashboard Upgrades

### Changed
- **`dashboard/index.html.erb`**
  - Added emojis for visual clarity.
  - Switched progress calculation from task count to estimated time for improved accuracy.
  - Displayed actual time spent to reflect effort invested.
  - Introduced burn rate warning when actual time exceeds estimate.
  - Removed duplicate logic for a cleaner codebase.

- **`dashboard/_goal_card.html.erb`**
  - Added emojis for visual clarity.

## [1.13.0] - 2025/06/07
### Dashboard Initial Release

### Added
- **`dashboard/_goal_card.html.erb`**
  - Partial created to display individual goals in a reusable format.

### Changed
- **`dashboard_controller.rb`**
  - Separated goals and tasks by status for clearer organization.
- **`dashboard/index.html.erb`**
  - Displayed goals and tasks within status-specific containers.
- **`assets/stylesheets/dashboard.scss`**
  - Color-coded tasks by status for better visual distinction.

## [1.12.30] - 2025/06/07
### Goal Migration for Status
### Dashboard Completed Goal Separation

### Changed
- **`_dashboard.scss`**
  - Styled completed goals for visual separation.
- **`dashboard/index.html.erb`**
  - Displays completed goals separately from active ones.
- **`models/goal.rb`**
  - Converted status to an enum and added humanized status labels.
- **`goals/_form.html.erb`**
  - Updated to allow status selection via dropdown.

### Added
- **Migration**:
  - Removed `status:string` from `goals`.
  - Added `status:integer` to `goals`.


## [1.12.29] - 2025/06/06
### Dashboard Layout & Task Sorting Upgrade

### Added
- **`dashboard/index.html.erb`**
  - Split tasks into separate **Tasks** and **Completed Tasks** sections
  - Sorted active tasks by `due_date` (soonest first)
  - Displayed completed tasks in their own visually distinct block

### Changed
- **`dashboard.scss`**
  - Added `.completed-tasks-container` for a third column in the dashboard
  - Shared styling refinements for `.goal-summary`, `.task-card`, and scrollable containers
  - Improved responsive layout with `flex-wrap` and consistent dimensions across containers

### Backend
- **`dashboard_controller.rb`**  
  - Split `@tasks` into `@active_tasks` and `@completed_tasks`
  - Applied ordering by `due_date` on both collections

## [1.12.28] - 2025/05/11  
### Landscaping Expansion  

### Changed  
- **`landscaping/index.html.erb`**  
  - Added more clarity around target market and job types  
- **`_landscaping.scss`**  
  - Styled the list of services and contact information  

## [1.12.27] - 2025/05/10
### Landscaping, About Updates

### Added
- **`landscaping_controller.rb`**
- **Route**: `/landscaping` now points to `landscaping#index`
- **`LandscapingJob` model**
- **`landscaping/index.html.erb`**: Basic view setup
- **`_landscaping.scss`**: Basic styling
- **`about1.png`**: Added to images for the About section

### Changed
- **`about/index.html.erb`**
  - Rearranged content to align with new image layout

## [1.12.26] - 2025/05/10
### Readme updates

## [1.12.26] - 2025/05/10
### Readme updates

## [1.12.25] - 2025/05/10
### Dashboard Upgrades

### Added
- **`dashboard_controller.rb`**:
  - Added authentication with `before_action :authenticate_user!`.
- **`dashboard/index.html.erb`**:
  - Linked each task’s goal for quick reference.
- **`layouts/_nav.html.erb`**:
  - Added Dashboard link visible only when `user_signed_in?`.

## [1.12.24] - 2025/05/07  
### Dashboard  

### Added  
- **`dashboard/index.html.erb`**:  
  - Displays all key models with basic info and edit links.  
- **`dashboard_controller.rb`**:  
  - Initial controller setup for centralized admin view.  
- **`assets/stylesheets/dashboard.scss`**:  
  - New SCSS file for custom dashboard styling.  

### Changed  
- **`dashboard_controller.rb`**:  
  - Displays associated tasks and completion status.  
- **`dashboard.scss`**:  
  - Stylized dashboard layout for better readability.  
- **`dashboard/index.html.erb`**:  
  - Shows progress bar for each model's task completion.

## [1.12.23] - 2025/05/06
### Hey have a README

### Changed
- **`README.MD`**:  
  - Put stuff in it, just read it if you've made it this far.


## [1.12.22] - 2025/04/06  
### Goal Section Cleanup  

### Changed  
- **`goals_controller.rb`**:  
  - Updated logic to exclude completed goals by default.  
- **`goals/index.html.erb`**:  
  - Added checkbox toggle to show/hide completed goals.  

### Notes  
- Helps focus on active goals while retaining access to completed ones when needed.

## [1.12.21] - 2025/03/14  
### Task Name Tooltip  

### Changed  
- **`calendar/show.html.erb`**:  
  - Added tooltip to display `task_name` when hovering over tasks on the calendar.

## [1.12.20] - 2025/02/24
### Completed tasks now show as such

### Changed
- **`calendar/show.html.erb`**:
  - Completed tasks now display a checkmark instead of time remaining and a progress bar.

## [1.12.19] - 2025/02/24
### General Debugging & Clean-Up

### Changed
- **`_calendar.scss`**:
  - Removed redundant status dot styling.
- **`layouts/application.html.erb`**:
  - Integrated Google Font.
- **`calendar/show.html.erb`**:
  - Applied Google Font.
  - General layout and style improvements.

## [1.12.18] - 2025/02/24
### General Debugging & Clean-Up

### Changed
- project4.png

## [1.12.17] - 2025/02/24
### General Debugging & Clean-Up

### Changed
- **`tasks/index.html.erb`**, **`goals/index.html.erb`**:
  - Adjusted emoji placement for better alignment.
- **`calendar/show.html.erb`**:
  - Updated labeling for improved clarity.
  - Status dot now displays an actual pie chart.
- **`_calendar.scss`**:
  - Ensured colors display correctly.

## [1.12.16] - 2025/02/22  
### General Debugging & Clean-Up  

### Changed
- **`seeds/tasks.rb`**:
  - **`actual_time`** can no longer be **NaN**
- **`models/goal.rb`**:
  - **Destroying a goal now removes its related tasks**
- **`goals/show.html.erb`**:
  - Aligned styling with **tasks/show** for consistency.
  - Added **emoji-powered** sub-nav.
- **`tasks/show.html.erb`**:
  - Now has same **sub-nav styling** as goals.
- **`tasks/index.html.erb`, `goals/index.html.erb`**:
  - **Icons added** for each heading.

### Removed
- **`goals/_goal.html.erb`**:

### Added  
- **Task Manager project image** 

### Notes  
- **Consistency upgrades** for better UI flow.  
- **Stronger data integrity** (no more NaN).  
- **Visual improvements** across the board.  

## [1.12.15] - 2025/02/22
### General Debugging & Clean-Up

### Changed
- **`_calendar.scss`**:
  - **Removed the scrollbar** from the calendar—because it looked bad.
  - Requested **ChatGPT** for a **5% style upgrade**… verdict is still out. Might fire for another AI. (I made chatGPT format this changelog appropriately, I sure hope the robots never take over :D)

### Notes
- Improves **visual appeal** of the calendar by removing unnecessary UI clutter.
- Style tweaks are **under evaluation** decisions pending future AI performance reviews.

## [1.12.14] - 2025/02/22
### General Debugging & Clean-Up

### Changed
- **`calendar_controller.rb`**:
  - **All tasks** now **display by default** on the calendar again.
  - Refined **progress wheel logic** to handle anything thrown at it.

### Notes  
- Ensures **complete task visibility** on the calendar.
- Progress wheel is now **more resilient** to unexpected data inputs.

### [1.12.13] - 2025/02/22
### General Debugging & Clean-Up

### Changed
- **`goal_icons.yml`**:
  - Expanded with **more categories**, brother.  
- **`task.rb`**:
  - **Validation enforced**: Tasks now **require** `estimated_time` and `actual_time`.
  - No more funny business—**NaN values are not welcome**.

### Notes
- Strengthens **task data integrity** by enforcing time-related fields.
- Expands **goal categorization** for better organization.


## [1.12.12] - 2025/02/22  
### Calendar Upgrades  

### Changed  
- **`calendar/show.html.erb`**:  
  - Displays **estimated time remaining** for tasks on both **daily** and **monthly** calendars.  
  - Updated **status-dot colors** to indicate task timing:  
    - **Black** → Estimated time.  
    - **Green** → Completed on time.  
    - **Red** → Completed time exceeded estimate.  
- **`stylesheets/_calendar.scss`**:  
  - Adjusted styling for **status-dot** display and visibility.  

### Notes  
- Improves **time tracking** directly on the calendar for better task management.  
- **Visual cues** make it easier to see task progress at a glance.  

## [1.12.11] - 2025/02/22  
### Search Implementation for Goals  

### Changed  
- **`goals/index.html.erb`**, **`goals_controller.rb`**, **`tasks/index.html.erb`**:  
  - Added **search functionality** for goals, similar to tasks but **without filtering**.  

### Notes  
- Enables **basic goal searching** for easier navigation.  
- Matches existing **task search behavior**, maintaining UI consistency. 

## [1.12.10] - 2025/02/22
### SCSS Consistency & Pagination Update

### Changed
- **`files.scss`**:
  - Standardized **SCSS variables** for consistency, specifically related to **hover colors**.
- **`tasks_controller.rb`**:
  - Temporarily increased **pagination limit** to **100 tasks per page** until further refinement.

### Notes
- Ensures **consistent styling** across the app by properly setting SCSS variables.
- Adjusts **pagination for better usability** while future optimizations are considered.

## [1.12.9] - 2025/02/22
### Task Icons, Task Icons Everywhere

### Changed
- **`calendar/show.html.erb`**:
  - Added **task icons** to calendar view for better visualization.
- **`goals/index.html.erb`**: 
  - Added **edit link** for each goal to improve navigation.
- **`application.scss` & `tasks/index.html.erb`**:
  - Centered tables for **Tasks** and **Goals** for a more polished layout.
- **`tasks/index.html.erb`**:
  - Now displays the **related goal** for each task.

### Notes  
- Enhances UI with **icons on the calendar** for quick task identification.
- Improves **goal management** with direct edit links.
- Layout improvements make **task/goal tables easier to read**.

## [1.12.8] - 2025/02/22
### Task Icons

### Changed
- **`tasks/_form.html.erb`**:
  - Updated to select from **existing goals** instead of using a static YAML list, ensuring correct associations.
- **`seeds/tasks.rb`**:
  - Added **more sample tasks** for development.

### Notes
- Improves data integrity by properly linking tasks to **actual goals**.
- Enhances development environment with additional **seed data**.

## [1.12.7] - 2025/02/21  
### Task Icons  

### Added  
- **`goal_icons.yml`**: Stores icon mappings for different goal categories.  
- **`goal_icons.rb`**: Handles logic for retrieving goal-related icons.  

### Changed  
- **`_goal.html.erb`**:  
  - Updated to reference **goal_icons** for displaying relevant icons.  
- **`goal_icons`**:  
  - Added initial set of icons for goal categories.  
- **`goals/index.html.erb`**:  
  - Now displays icons next to goal titles instead of a separate **Icon** column.  
  - Renamed **Title** column to **Goal** for better clarity.  
- **`goals_controller.rb`**:  
  - Integrated **GOAL_ICONS** for managing goal-related icons.  
- **`goals/_form.html.erb` & `tasks/_form.html.erb`**:  
  - Updated dropdown menus to include **related categories/icons**.  

### Notes  
- Introduces **visual indicators** for goal categories, improving UI clarity.  
- Streamlines table layout by embedding icons within the **Goal** column.  
- Dropdown menus now provide **better category selection** with icons.  

## [1.12.6] - 2025/02/21
### Tasks Section Upgrades, descriptions for tasks / goals

### Changed
- **`tasks/show.html.erb`**:
  - Added links to related sections (**Goals**, **Calendar**) for better navigation.
- **`tasks/_form.html.erb`**:
  - Clarified that the input represents **minutes** to avoid confusion.
- **`tasks/index.html.erb`**:
  - Added a description to define **what tasks are** for better context.
- **`goals/index.html.erb`**:
  - Added a description to define **what goals are** for clarity.
- **`application.scss`**:
  - Aligning <p> sherman 42 wallaby way Sydney tag

### Notes  
- Improves navigation by linking related sections.  
- Enhances user understanding of **tasks and goals** with better descriptions.  
- Prevents confusion around time-tracking units.  

## [1.12.5] - 2025/02/20
### Goals Section Upgrades & Frontend Improvements

### Changed
- **`goals/index.html.erb`**:
  - Added **Actual Time** as a new metric for tracking progress.
- **`application.scss`**:
  - Consolidated **Goals** and **Tasks** styles for consistency and maintainability.

### Removed
- **`tasks.scss`** and **`goals.scss`**:  
  - Merged into `application.scss` to standardize styles.

### Notes
- Improved frontend consistency between Goals and Tasks.
- New metric helps with better tracking of time spent on goals.

## [1.12.4] - 2025/02/20  
### Goals Section Upgrades  

### Changed  
- **`goals_controller.rb`**:  
  - Goals are now sorted by **due date (ascending)**—closer due dates appear first.  
- **`goals/index.html.erb`**:  
  - Implemented `goals_by_due_date_asc` for proper sorting.  
  - Added links to related tasks for better navigation.  
- **`tasks_controller.rb`**:  
  - Updated filtering logic to retrieve tasks when a `goal_id` is present.  

### Notes  
- Improves organization of Goals by prioritizing urgent ones.  
- Enhances navigation by linking tasks directly to their respective goals.  

## [1.12.3] - 2025/02/20
### Goals Section Upgrades

### Added
- **`_goals.scss`**: New SCSS partial for Goal-related styles.

### Changed
- **`goals/index.html.erb`**:
  - Displays additional goal-related info to track progress more effectively.
- **`models/goal.rb`**:
  - Established a **one-to-many** relationship between Goals and Tasks.

### Removed
- **Default scaffold 'notice' tags**:  
  - Removed due to inconsistent behavior and unnecessary clutter.

### Notes
- Goals now display progress-related info for better tracking.
- Tasks can now be associated with Goals, improving structure.

## [1.12.2] - 2025/02/19  
### Goals Section Upgrades & Seed File Enhancements  

### Added  
- **Migration** to associate tasks with goals.  
- **`seeds/goals.rb`**: Seed file for generating dummy goal data.  

### Changed  
- **`task.rb`**: Tasks now belong to a goal.  
- **`tasks/_form.html.erb`**: Added a dropdown to associate tasks with a goal.  
- **`tasks/show.html.erb`**: Displays the corresponding goal for each task.  
- **`tasks_controller.rb`**: Requires `goal_id` when creating tasks.  
- **`seeds/tasks.rb`**: Now includes `goal_id` for seeded tasks.  
- **`seeds/goals.rb`**: Populated with dummy data for testing.  

### Notes  
- Strengthens task-goal relationships for better organization.  
- Improves seeding process for easier testing and development.  


## [1.12.1] - 2025/02/19
### Goals Section

### Added
- **Generated Goal scaffold** for managing goals.

### Changed
- **`goals_controller.rb`**:
  - Requires user authentication for goal-related actions.
- **`_navbar.html.erb`**:
  - Added navigation link to Goals section (visible when signed in).

### Removed
- **Unused scaffold files** related to files that won’t be used in the near future.

### Notes
- Introduces a dedicated Goals section for tracking progress.
- Streamlines authentication to ensure goal-related actions are secure.


## [1.12.0] - 2025/02/18
## Front end changes for greater consistency

### Changes
- Various changes to scss and html.erb files for a more organized front end.

## [1.11.6] - 2025/02/17  
### SCSS Cleanup & Project Refactoring  

### Added  
- **`_about.scss`**: New SCSS partial for About page styles.  
- **`_contact.scss`**: New SCSS partial for Contact page styles.  

### Changed  
- **`application.scss`**: Moved About and Contact styles to dedicated SCSS files for better organization.  
- **`projects_controller.rb`**: Removed `show` action since projects link to external URLs.  

### Removed  
- **`projects/show.html.erb`**: Removed unnecessary view file (not ever needed).  

### Notes  
- Improved SCSS structure for easier maintenance.  
- Simplified project handling by removing an unnecessary controller action and view.  


## [1.11.5] - 2025/02/17
### Footer Implementation

### Added
- **`layouts/_footer.html.erb`**: New footer partial for consistent site-wide use.

### Changed
- **`layouts/application.html.erb`**: Integrated the new footer into the layout.
- **`blog_posts/show.html.erb`**: Fixed a missing closing `<div>` to ensure proper structure.

### Notes
- The new footer improves site consistency and navigation.
- Fixed structural issue in blog posts to prevent layout breaks.

## [1.11.4] - 2025/02/17
### Blog Cleanup

### Changed
- **`home/index.html.erb`**: Updated the **About** subheading name for clarity.
- **`application.scss`**: Added styling improvements for blog post formatting.
- **`blog_posts/show.html.erb`**: Removed unnecessary elements for a cleaner layout.

### Notes
- Improves readability and structure of the blog section.
- Simplifies blog post presentation by removing unnecessary bloat.

## [1.11.3] - 2025/02/16
### Homepage Updates

### Changed
- **`index.html.erb`**: Moved **About** and **Contact** sections to the top for better visibility.
- **`application_controller.rb`**: Updated homepage content display logic.
- **`application.scss`**: Added styling for `<h3>` elements.

### Notes
- Improves homepage organization for a better user experience.
- Enhanced styling consistency for section headers.

## [1.11.2] - 2025/02/11  
### Status Indicators and App Name Fix  

### Changed  
- **`_calendar.scss`**: Added `.status-dot` class for task status indicators.  
- **`calendar/show.html.erb`**: Implemented status dots in both calendar views.  
- **`layouts/application.html.erb`**: Fixed app name display from **"AwD"** to **"AWD"**.  

### Notes  
- Status indicators improve task visibility in the calendar.  
- Minor UI correction for consistent branding.  

## [1.11.1] - 2025/02/08
### Improved Pagination and SCSS Organization

### Added
- **`_videos.scss`**: New SCSS partial for video-related styles.
- **`_tasks.scss`**: New SCSS partial for task-specific styles.

### Changed
- **`tasks_controller.rb`**:
  - Implemented pagination, now displaying **10 tasks per page** for better performance.

### Notes
- SCSS files are now more modular, improving maintainability.
- Pagination logic enhances task list usability and prevents long page loads.

## [1.11.0] 2025/02/08
### Calendar Moved to Its Own Section

### Added
- **`views/calendar/show.html.erb`**: New standalone calendar view
- **`calendar_controller.rb`**: Handles displaying tasks in the calendar
- **`_navbar.html.erb`**: Added link to the calendar (visible when logged in)

### Changed
- **`tasks/index.html.erb`**: Removed embedded calendar
- **`calendar/show.html.erb`**: Moved calendar here from task index
- **`calendar_controller.rb`**:
  - Now displays tasks for the selected month only  
  - Requires authentication before access  
- **`application.scss`, `_calendar.scss`**: Cleaned up and organized styles  
- **`_navbar.scss`**: Fixed text size issue that caused nav to break

### Notes
- This change prevents the task list pagination from affecting the calendar.

## [1.10.14] 2025/02/07
### Recurring tasks, backup db

### Added
- database dump file
- console.rb

### Changed
- gitignore 
    - ignoring that database dump file
- console.rb
    - logic for recurring tasks
- assets/_calendar.scss
    - Updated to add scrollable calendar days for monthly calendar
    - Added daily calendar for greater visibility & tracking
    - Other general layout changes including search relocation
- tasks_controller.rb
    - pagination logic added

## [1.10.13] 2024/12/29
### Bug Fix (validate start_date presence)

### Changed
- models/task.rb
    - ensure due_date is provided before allowing a task to be created (it needs that to display on the calendar)
    
## [1.10.12] 2024/12/2
### Updating how the buttons display

### Changed
- home/index.html.erb, projects, blog_posts, application.scss
    - Button was landing on same line as image in some resolutions, causing display issues.

## [1.10.11] 2024/12/2
### Adding new blog post image

### Added
- blog7.png

## [1.10.10] 2024/12/2
### Contact info fixes

### Changed
- index.heml.erb, application.scss, contact_info.yml
    - Related to what content displays, and where.

## [1.10.9] 2024/11/23
### Gaming Section Updates
#### Been doing changelogs wrong this whole time lol whoops

### Added
- Migration files
    - Related to converting game_notes to json

### Changed
- seeds/games.rb
    - updated gaming info for existing, and upcoming
- games/index.html, show.html
    - Front end stuff, mostly related to displaying json
- Migration
    - Related to converting game_notes to json
- games_controller.rb
    - Auth for any action for now


## [1.9.9] 2024/11/12
### Documentation section

### Added
- Document scaffold
    - Removed most of it lol
- document{#i}-{#i}.png
    - Supporting images for documentation

### Changed
- application.scss
    - for gaming section, front end
    - for documents, front end
- games/index.html.erb
    - updating what displays
- document_controller.rb
    - auth user before access
- nav.html.erb
    - referencing documentation section when authenticated
- seeds/documents.rb
    - dummy data
- documents/index.html.erb, show.html.erb, _document.html.erb
    - Seeing what we want when we want 

## [1.9.8] 2024/11/12
### Gaming section

### Added
- Migration related files For gaming section
- controllers/games_controller.rb
    - With index and show actions
- views/games/index.html.erb, show.html.erb
    - With related info displaying
- models/games.rb
- seeds/games.rb
    - With dummy data
- assets/images/game1-3.png
    - Starter stock images

### Changed
- schema.rb
    - related to migration run
- routes.rb
    - games related routes, alphabetized file
- navbar
    - gaming section added (if logged in for now)


## [1.9.7] 2024/11/11
### Simple Calendar for Task Tracking

### Added 
- _calendar.scss
    - Any custom calendar styling goes here
    - Also referenced this file on application.scss

### Changed
- Gemfile.rb
    - simple_calendar gem added
- application.rb
    - Calendar starts on Sunday
- tasks/index.html.erb
    - Electing to put calendar directly on this page for now

## [1.9.6] 2024/10/27
### Refining Task Manager | Front end fixes

### Changed
-tasks/index.html.erb
    - Removed chatGPT generated front end styling directly on the html.erb file :facepalm:
    - Moved search box and filtering to it's own section altogether

## [1.9.5] 2024/10/27
### Refining Task Manager | Hidden Tasks | Checkboxes for filtering

### Changed
- tasks_controller.rb
    - Added logic to show all tasks, on_hold, completed hidden by default
    - The %w[...] syntax is shorthand in Ruby to create an array of strings, so %w[completed on_hold] is the same as writing ['completed', 'on_hold'].
-tasks/index.html.erb
    - Added checkbox to show all tasks, on hold, completed

## [1.9.4] 2024/10/22
### Refining Task Manager with search, sorting
#### Updating Public Facing Contact Info

### Created
- tasks_helper.rb

### Changed
- contact_info.yml
    - Removed phone number, added linkedin
- tasks_controller.rb
    - Sorting if params are present
- application.scss
    - overdue tasks highlight in red
- task.rb
    - Added support for 'on-hold'
- tasks/index.html.erb
    - Front end support necessary to sort these tasks
    - Basic search form
- tasks_helper.rb

## [1.9.3] 2024/10/22
### Cleanup

### Fixed
- tasks_controller.rb, task.rb, _form.html.erb
    - Updated logic to ensure tasks display
    - Make it such that status displays through the use of mapping.


## [1.9.2] 2024/10/22
### New Featured Project

### Added
- blog6.png
    - To correspond with the update statement made to blog.
    
### Changed
- images/project5.png
    - Updated for the actual project moxicloud-ui
- COMMANDS.md
    - Tracking specific update statements made


## [1.9.1] 2024/10/21
### Launch Time

### Changed
- README.md
    - TMPFI
- .gitignore
    - Guess where all that README info went. It's still public info thanks to this repository :D

## [1.9.0] 2024/10/21
### Sweeping the floor

### Changed
- This file.
    - It looks better when you're looking at it from a 'user' perspective.
- tasks/index.html.erb
    - Insert redneck - **Thems be some fancy new 'new / create' routes boihhhhh, it'd be a shame if the user couldn't.. use 'em**

## [1.8.9] 2024/10/21
### Removing, and then re-adding task_params because chat GPT

### Changed
- Put back task_params method

## [1.8.8] 2024/10/21
### Basically chatGPT told me to remove task_params

### Changed
- Removed task params so that stuff would display on the front end
- As it turns out, those params had nothing to do with it, and chatGPT and I did not quite see eye to eye. We both understand the importance of strict params, especially when it comes to user input. This rubber ducky sucks sometimes.

## [1.8.7] 2024/10/21
### 187 on a motherCRUDDin (lap)TOP

### Added
- new, edit, _form.html.erb

### Changed 
- _navbar.scss, application.scss
    - Updates to color and how stuff displays
- new, edit, _form.html.erb
    - Basic CRUD actions applied
- tasks_controller.rb, index.html.erb, show.html.erb
    - Basic CRUD actions applied
- routes.rb
    - converted to full beans resources for tasks. That's a Jeff Arcuri reference, look him up.

## [1.8.6] 2024/10/20
### Devise Gem | Tasks cannot be accessed at all unless signed in

### Changed
- tasks_controller.rb
    - before_action :authenticate_user!
    - Does not allow access to any action within this controller
- application.scss
    - blog-post didn't have image sizing set appropriately

## [1.8.5] 2024/10/20
### Devise Gem | Tasks hidden unless signed in

### Changed
- _navbar.html.erb
    - <% if user_signed_in? %> for tasks

## [1.8.4] 2024/10/20
### Devise Gem Implemented

### Added
- devise gem - https://github.com/heartcombo/devise
- approve user - https://github.com/heartcombo/devise/wiki/How-To:-Require-admin-to-activate-account-before-sign_in
    - migrations related to both of these, for the user, and to add approved to user

### Changed
- README.md
    - Some documentation
- gemfile, related to devise implementation
- routes.rb, related to devise implementation and user model
- schema.rb, related to devise implementation and user model

## [1.7.4] 2024/10/20
### Refactoring application.scss

### Changed
- application.scss
    - Those can be the same (blog_posts, projects)
    - Updated to make stuff centered in the cards
    - Make videos more taller too

## [1.7.3] 2024/10/20
### Standard 1:1 image sizing for most content

### Changed
- README.md
    - Standard image sizing

## [1.7.2] 2024/10/19
### Front end implementation including new images, API font

### Changed
- README.md
    - Call it what it is

## [1.7.1] 2024/10/19
### Front end implementation including new images, API font

### Changed
- images/{#image}.png
    - Reflecting actual images, not stock photo
- application.scss
    - Referenced 'Roboto' google API font as added to application.html.erb file
- application.html.erb
    - Calling Google API for Roboto font to display

### Fixed
- blog_posts/show.html.erb
    - Updated how the image displays, so that it displays

## [1.6.1] 2024/10/19
### Front end cleanup and organization

### Changed
- application.scss
    - Organized alphabetically
    - Added section info that wasn't previously there. Entire site now stylized enough.
    - Updated some sizing related to flex.
- about/index.html.erb
    - wrapped that biotch in a section that identifies what it is
- contact/index.html.erb
    - wrapped in section tag with appropriate id 'contact'
- tasks/index.html.erb
    - wrapped in section tag with appropriate id 'tasks'


## [1.6.0] 2024/10/19
### Chat GPTify the front end

### Added
- _navbar.scss

### Changed
- application.scss
    - Added stylization generated from chatGPT for each section
- home/index.html.erb
    - Moved sstuff around to make more display better
- about_info.yml
    - removed a typo
- navbar.scss
    - stylization specific to the navbar

## [1.5.0] 2024/10/19
### Implementing Sass (npm install -g sass)

### Added
- application.scss

### Changed
- CHANGELOG.md
    - Had some display issues due to heading tags being incorrectly marked
- application.scss
    - Added very basic styling that was applied originally in css file

### Removed
- application.css

## [1.4.0] 2024/10/19
### Other 'featured' migrations

### Added
- Corresponding schema and migration files related migrations run

### Changed
- home_controller.rb
    - Featured logic was actually here for the home page related to featured projects and videos. Updated that.
- seeds.rb
    - Updated to add 'featured' data

## [1.3.0] 2024/10/19
### Migration for better featured blog post control, database correction

### Added
- Corresponding schema and migration file related to AddFeaturedToBlogPosts migration generated.

### Changed
- blog_posts_controller.rb
    - Removed featured from this controller, shouldn't have been there.
- home_controller.rb
    - Added logic to check if featured = true for featured blog posts.
- seeds.rb
    - Updated to add 'featured' data
- database.yml
    - was referencing aw_development db. Corrected that.

## [1.2.0] 2024/10/18
### Seed refactoring, files contain actual information

### Added
- /db/seeds/{#db_model}
- images/blog{#1-5}
- images/project{#1-5}

### Changed
- seeds.rb
    - Updated to separate out into individual files based on db model
    - Added portfolio and related information to each individual file
- about_info.yml
    - Removed unnecessary info, changed other info
- contact_info.yml
    - Removed unnecessary info, changed other info
- about/index.html.erb
    - Updated to accurately reflect the yml info
- contact/index.html.erb
    - Updated to accurately reflect the yml info
- appliacation_controller.rb
    - Updated to accurately reflect application info
- home/index.html.erb
    - contact to bottom

### Removed
- n/a

## [1.1.0] 2024/10/18
### Addressing some initial concerns, seed file upgrade (continued)

### Added
- n/a

### Changed
- application_controller.rb
    - Added set_app_content
        - This is considered 'hardcoded' content, and should be altered with great care. This content pertains to a section, but can display everywhere and will be referenced multiple times throughout the app.
- about_controller.rb
    - Removed @about_info
- about/index.html.erb
    - Added more clarity as to how to edit info
- seeds.rb
    - Added starter content for each model in the DB, with references to this file as necessary.
- blog_posts/index.html.erb
    - Displaying all blog posts now. 
    - Featured blog_posts remain on the index
- blog_posts_controller.rb
    - @blog_posts = all blog posts
- contact_info.yml
    - Added more clarity as to how to edit info
- projects_controller.rb
    - @projects = all projects
- videos_controller = all videos
    - @videos = all videos

### Removed
- n/a

## [1.0.0] 2024/10/17

### Added
- n/a

### Changed
- README.md
    - Added some basic documentation to remove a section of the site if necessary
- routes.rb
    - Updated routes to alphabetize

### Removed
- n/a

### Fixed
- n/a

### Security 
- n/a

---

## [Unreleased] 2024/10/17
### Task index and show, seed file to populate data

### Added
- 

### Changed
- tasks_controller.rb
    - Added @tasks to index and show actions
- tasks/index.html.erb
    - Populating each task in the DB
- tasks/show.html.erb
    - Populating the task with the associated id in the DB tasks/[id]
- seeds.rb
    - Some dummy data to populate the database with rails db:seed

### Removed
- 

## [Unreleased] 2024/10/17
### Creating an About Section

### Added
- about_info.yml

### Changed
- about_info.yml
    - Added some paragraphs and links.
- about_controller.rb
    - Added @about info to index action (This displays hardcoded about content)

### Removed
- home_controller.rb
    - @about = action to add on it's own controller

## [Unreleased] 2024/10/16
### Displaying content appropriately, timezone update, YAML File

### Added
- contact_info.yml

### Changed
- HomeController
    - Added featured projects, blogposts, videos, and an about section.
- index.html.erb
    - Displays the featured content set in the home controller, and some basic about info.
- some_route/index.html.erb, show.html.erb
    - Displays content as appropriate based on the route (tasks, projects, videos, etc)
- application.css
    - State of the art image sizing applied
- application.rb
    - Set default timezone to Pacific
- contact_controller.rb
    - contact_info.yml referenced
- README.md
    - Referenced this file

## [Unreleased] 2024/10/16
### Initial Site Framework and Navbar

### Added
- BlogPosts, Projects, Tasks, Videos
    - Models
    - Controllers
        - Views
- About, Contact, Home
    - Controller
        - View
- Gemfile
    - bootstrap
    - sassc-rails
- _navbar.html.erb (see changes below)

### Changed
- application.html.erb
    - navbar is rendered here 
- routes.rb
    - Index established (home#index)
    - Other routes set to page#index
- _navbar.html.erb
    - Contains links to each index action, as set in routes
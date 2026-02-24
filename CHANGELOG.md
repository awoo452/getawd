# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.24.2] 2026/02/24

### Changed
- Services list now renders card images when provided.

## [1.24.1] 2026/02/24

### Changed
- Me: Let's just do some really basic filtering on the projects page
- ChatGPT: Hold my beer
- Me: Ok can u fix it tho with this commit? Stay tuned to find out.
- Projects index now groups by service types from the database, with an "Other Projects" fallback for nil or unmapped types.
- Service project anchors now derive from the stored `service_type` without hardcoded mappings.

## [1.24.0] 2026/02/24

### Added
- Services table to describe available offerings.
- Services index page linked from the main nav.
- Projects `service_type` column for mapping offerings to services.
- Services cards link to Projects anchors by `service_type`.
- Project seed data updated with service mappings.

### Changed
- Projects index grouped by service type with anchors for Services card links.

## [1.23.49] 2026/02/22

### Added
- Meta description for the home page to improve search previews.

## [1.23.48] 2026/02/22

### Added
- Terms of Use and Privacy Policy pages.
- LICENSE file.

### Changed
- Footer now links to Terms and Privacy.

## [1.23.47] 2026/02/22

### Changed
- Dumb clanker can't even get the branding right
- Dumb human can't even proofread

## [1.23.46] 2026/02/21

### Changed
- Projects index now links to internal project detail pages, with external links moved to show.
- Split projects index into featured and more sections.
- Videos index now links to detail pages with thumbnails instead of embedded players.
- Video show page now includes a dedicated embed layout and navigation back to the index.

## [1.23.45] 2026/02/20

### Changed
- Documents section is organized unlike ur desk lol

## [1.23.44] 2026/02/20

### Changed
- Mirrored Ryder's World image proxy with signed resize URLs and S3 presign fallback.
- Routed all UI images through the proxy with WebP sizing and updated media/system docs.
- Added an image proxy setup doc with CloudFormation + secret + env var checklist.

## [1.23.43] 2026/02/15

### Changed
- Forced Devise remember-me on sign-in; set a 2-year remember window with sliding renewal
- Added basic PWA metadata and a web manifest to support iOS "Add to Home Screen"

## [1.23.42] 2026/02/07

### Changed
- Normalized reward redemption params and surfaced invalid reward/game selections.

## [1.23.41] 2026/02/07

### Fixed
- Guarded date normalization when parsing fails to avoid nil to_date errors.

## [1.23.40] 2026/02/07

### Changed
- Surface invalid filter params for goals/tasks instead of silently skipping them.

## [1.23.39] 2026/02/07

### Changed
- Normalized query params for goals/tasks filters and sorting to keep inputs predictable.

## [1.23.38] 2026/02/07

### Changed
- Defaulted all controllers to require authentication, with an explicit public allowlist.

## [1.23.37] 2026/02/06

### Changed
- Aligned DB constraints with model expectations (non-null requirements, case-insensitive goal uniqueness).
- Backfilled missing task/document fields before enforcing constraints.
- Enforced unique reward-task joins and added matching model validations.

## [1.23.36] 2026/02/06

### Changed
- setting ruby-version file because pinning it to 4.0.1 isn't enough or whatever

## [1.23.35] 2026/02/06

### Changed
- Shitposting in the 403 message for the love of the game.

## [1.23.34] 2026/02/06

### Changed
- Locked production host allowlist to `APP_HOST`/`APP_HOSTS` (defaults to getawd.com, www.getawd.com)
- Set explicit session cookie key and SameSite/secure settings

## [1.23.33] 2026/02/06

### Changed
- Standardized priority levels to 1–5 across the app.
- Calendar daily view now shows Levels 1–5.
- Rewards level panel now includes Levels 1–5.
- Daily reward earning now runs for Levels 1–5 only.
- Redeem flow rejects invalid reward levels.

### Fixed
- Prevented goals/tasks from accepting priority values outside 1–5.

## [1.23.32] 2026/02/06

### Changed
- Removed pagination from docs section because ChatGPT can do the thing where they tell you they implement pagination but what actually happens is they paginate most of the shit and hope you won't notice the 2 or 3 missing articles that aren't called because you let a robot do a man's job.

## [1.23.31] 2026/02/06

### Changed
- Grouped documents index by `metadata["category"]`, with uncategorized fallback.

## [1.23.30] 2026/02/06

### Changed
- Document helper now maps `logo-classic.png` to `branding/logo-classic.png` for docs placeholders.

## [1.23.29] 2026/02/06

### Changed
- Standardized landing and index card truncation rules for titles and descriptions.
- Unified list card imagery into square, centered 500px frames across featured and index views.
- Aligned document card markup with the standardized card typography.

## [1.23.28] 2026/02/04

### Added
- Auth page styling and custom Devise views for sign in, sign up, and password reset flows.

## [1.23.27] 2026/02/04

### Changed
- Landscaping job images now render inside a square, overflow-hidden frame.
- Blackjack visuals updated to classic green felt styling with card-like elements.

## [1.23.26] 2026/02/04

### Changed
- Standardized landscaping/blackjack styling with shared theme variables and square image sizing.

## [1.23.25] 2026/02/04

### Fixed
- Restored `landscaping_image_url` helper for landscaping image rendering.
- Linked landscaping page to contact page instead of inline contact details.

## [1.23.24] 2026/02/04

### Changed
- Split blackjack and landscaping views into focused partials.

## [1.23.23] 2026/02/04

### Changed
- Split feedbacks, navbar, and reward history/level sections into focused partials.

## [1.23.22] 2026/02/04

### Changed
- Split documents show, games index, blog posts show, and goals show into focused partials.

## [1.23.21] 2026/02/04

### Changed
- Split ideas show, projects index, and blog posts index into focused partials.
- Shared pagination partial for blog posts and projects.

## [1.23.20] 2026/02/04

### Changed
- Prevented duplicate level rewards from re-earning after redemption on the same day.

## [1.23.19] 2026/02/04

### Changed
- Split reports, contact, and task show views into focused partials.

## [1.23.18] 2026/02/04

### Changed
- Split rewards show view into focused partials.
- Split game show view into focused partials.
- Split home featured sections into focused partials.

## [1.23.17] 2026/02/04

### Changed
- Split task and goal forms into focused partials and shared error rendering.

## [1.23.16] 2026/02/04

### Changed
- Split calendar views into focused partials and centralized time status display.

## [1.23.15] 2026/02/04

### Changed
- Split dashboard index into focused partials.

## [1.23.14] 2026/02/04

### Changed
- Split rewards index into focused partials and removed view-level queries.

## [1.23.13] 2026/02/04

### Changed
- Removed stray controller-style `index` method from `LandscapingJob`.
- Extracted hold/resume timing logic into `Holdable::NormalizeHoldUntil` and `Holdable::ResumeIfReady`.

## [1.23.12] 2026/02/04

### Changed
- Extracted reward eligibility checks into `Rewards::Eligibility`.

## [1.23.11] 2026/02/04

### Changed
- Moved task completion reward logic into `Tasks::HandleCompletion`.

## [1.23.10] 2026/02/04

### Changed
- Extracted calendar loading into `Calendar::ShowData`.
- Extracted games pagination into `Games::IndexData`.
- Extracted idea show loading into `Ideas::ShowData`.
- Extracted landscaping index loading into `Landscaping::IndexData`.
- Extracted S3 proxy resolution into `S3Proxy::ShowData`.
- Extracted videos pagination into `Videos::IndexData`.

## [1.23.9] 2026/02/04

### Changed
- Extracted about page loading into `About::IndexData`.
- Extracted contact page loading into `Contact::IndexData`.
- Extracted contact message delivery into `Contact::SendMessage`.
- Extracted home page featured content into `Home::IndexData`.
- Extracted blog posts pagination into `BlogPosts::IndexData`.
- Extracted projects pagination into `Projects::IndexData`.
- Extracted feedback listing/creation/update into `Feedbacks::IndexData`, `Feedbacks::CreateFeedback`, and `Feedbacks::UpdateFeedback`.

## [1.23.8] 2026/02/04

### Changed
- Extracted document index pagination into `Documents::IndexData`.
- Extracted document deletion into `Documents::DestroyDocument`.

## [1.23.7] 2026/02/04

### Changed
- Extracted blackjack game logic into `Blackjack::Game`.

## [1.23.6] 2026/02/04

### Changed
- Extracted dashboard aggregation into `Dashboard::IndexData`.
- Extracted reports aggregation into `Reports::IndexData`.

## [1.23.5] 2026/02/04

### Changed
- Extracted goal index filtering/sorting into `Goals::IndexData`.
- Extracted goal creation into `Goals::CreateGoal`.
- Extracted goal updates into `Goals::UpdateGoal`.
- Extracted goal deletion into `Goals::DestroyGoal`.

## [1.23.4] 2026/02/04

### Changed
- Made reward redemption require an explicit level (or reward_id) to avoid silent fallback to Level 1.
- Extracted task creation/repeat logic into `Tasks::CreateTask`.
- Extracted task update and complete-on-time flows into `Tasks::UpdateTask` and `Tasks::CompleteOnTime`.
- Extracted task index filtering/sorting into `Tasks::IndexData`.
- Extracted task deletion into `Tasks::DestroyTask` for consistent controller flow.

## [1.23.3] 2026/02/03

### Changed
- Extracted reward level redemption logic into `Rewards::RedeemLevel`.
- Extracted `redeem_any` logic into `Rewards::RedeemAny`.
- Extracted `redeem_task` logic into `Rewards::RedeemTask`.
- Extracted rewards index aggregation into `Rewards::IndexData`.

## [1.23.2] 2026/02/03

### Changed
- Removed inline view styles/scripts and aligned CSP for Turbo/importmap to keep console clean.

## [1.23.1] 2026/02/01

### Changed
- Slight logo adjustment. New year new me or whatever.

## [1.23.0] 2026/02/01

### Changed
- Migrated About section content from static YAML to database-backed `about_sections`
- Rewrote About content to better reflect real-world experience, technical focus, and problem-solving approach
- Improved structure and ordering of About sections using explicit positioning
- Simplified view logic to render About content dynamically from the database
- Standardized public-facing section styling to share consistent colors, spacing, and card treatments
- Refreshed About/Contact/Video section styling to align with the shared theme tokens
- Aligned public page headings and section wrappers to match SCSS selectors consistently

### Fixed
- Avoided asset pipeline errors when About image fallbacks are missing

### Added
- `about_sections` table with ordered, extensible content blocks
- Seed data for About section to support consistent local and production setup
- Shared SCSS theme tokens for site-wide colors, typography, spacing, and shadows

## [1.22.18] 2026/01/31

### Added
- Added Feedback model for tracking site feedback and TODOs
- Added feedback fields:
  - title
  - body
  - section (area of the site)
  - completed flag
  - commit reference for changelog correlation
- Added FeedbacksController with index, new, create, edit, and update actions
- Added feedback creation form for quickly logging feedback items
- Added feedback index view with open vs completed separation
- Added ability to mark feedback as completed and associate a commit reference
- Added signed-in navigation link to feedback form
- Added `/feedback` route alias for human-readable URLs while preserving Rails conventions

### Architecture
- Isolated feedback functionality from dashboard and reports
- Designed feedback workflow to support batch processing and release-based cleanup

## [1.22.17] 2026/01/31

### Added
- Report card addition

## [1.22.16] 2026/01/31

### Added
- Completion chain expansion to include more context and an emoji based on success or failure

## [1.22.15] 2026/01/31

### Added
- Added ReportsController with dedicated `/reports` index for historical accountability reporting
- Added monthly task accountability reporting:
  - Completed on-time vs completed late task counts
  - Missed tasks (overdue, not completed, not on hold)
  - Estimated minutes lost due to missed tasks
  - Days since last task completion
- Added 6-week weekly task completion trend aggregation
- Added scoped `reports.scss` stylesheet for Reports page
- Imported reports stylesheet into application styles
- Isolated Reports layout and panels to prevent dashboard CSS bleed

## [1.22.14] 2026/01/26

### Changed
- Well would you look at that, ChatGPT can't even stick to formatting the changelog correctly and it took me 5+ commits to realize it.

## [1.22.13] 2026/01/26

### Changed
- Cached S3 presigned URLs with a TTL shorter than their actual expiration
- Switched per-request/thread caching to Rails cache to avoid serving expired URLs

## [1.22.12] 2026/01/25

### Added
- Routed image requests through a stable /media proxy to avoid expired S3 presigned URLs
- Added S3 proxy controller + route to mint fresh presigned URLs per request

## [1.22.11] 2026/01/25

### Fixed
- Guarded dashboard constants to avoid crashes if icon/idea maps are missing
- Hardened calendar rendering against missing GOAL_ICONS and nil task dates/times
- Hardened contact/about YAML loading and guarded missing social/about data
- Guarded home featured links, blog images, and video embeds when data is missing

## [1.22.10] 2026/01/25

### Added
- Added pagination and ordering for projects index, and guarded empty project URLs
- Added pagination for videos index and fixed videos show to use the requested video

## [1.22.9] 2026/01/25

### Changed
- Hardened document rendering against nil/mismatched JSON arrays
- Required document title and slug
- Guarded document index thumbnails against missing image data
- Hardened document show against malformed images/youtube_id/metadata
- Added pagination and ordering for blog posts index
- Slug migration for blog_posts

## [1.22.8] 2026/01/25

### Added
- Expanded seed data for tasks, games, documents, and rewards

## [1.22.7] 2026/01/25

### Fixed
- Fixed task list filters, N+1 goals, and repeat-until validation
- Applied goal filters to rendered lists and eager loaded ideas
- Removed unused Reward#redeem! and hardened game progress_data parsing

## [1.22.6] 2026/01/25

### Added
- Made completion footage URL requirement apply only to level (gaming) rewards
- Added level 3 auto-funding payload on redemption
- Display reward update errors on the reward show page

## [1.22.5] 2026/01/25

### Changed
- Eager loaded goals on dashboard/calendar task lists to reduce N+1 queries
- Guarded calendar view against tasks without goals
- Reduced reward availability counting N+1 queries on dashboard

## [1.22.4] 2026/01/25

### Changed
- Removed S3 presign debug logging and tightened production asset/ActiveStorage settings
- Removed Rails 8.1 new framework defaults initializer after adopting defaults
- Added pagination for documents, games, and rewards indexes
- Enforced safe handling of path-relative redirects
- Optimized reward completion helpers to avoid N+1 scans
- Cached S3 presigned URLs per request
- Added report-only Content Security Policy
- Updated Devise routes to avoid upcoming keyword deprecation warnings

## [1.22.3] 2026/01/25

### Changed
- Prepared database.yml for primary/cable/queue/cache connections and bumped Rails to 8.1.x
- Updated Gemfile and Gemfile.lock for Rails 8.1.2
- Restored app-specific Rails config after app:update (timezone, dev cache toggles, prod mailer/SSL/logging)
- Updated enum declarations to Rails 8-compatible syntax
- Removed Ruby version pin from Gemfile
- Pinned Ruby to 4.0.1

## [1.22.2] 2026/01/25

### Changed
- Removed duplicated `handle_completion` and `earned_on_date` definitions in `Task`
- Removed redundant plural `about` and `contacts` resource routes
- Removed unused `rewards` routes for `new`, `create`, and `destroy`
- Enforced unique slugs on documents
- Hardened reward redemption validation for level rewards and invalid game selections
- Aligned reward helper calculations with level-only earned rewards and on-hold task exclusions

## [1.22.1] 2026/01/24

### Changed
- games show was borked because I don't use rspec or whatever

## [1.22.0] 2026/01/19

### Added
- Blackjack lol

## [1.21.32] 2026/01/19

### Changed
- Serving images for the remaining app sections without ability to expand

## [1.21.31] 2026/01/19

### Changed
- Updated Documents index page to load images via `S3Helper` instead of public S3 URLs
- Updated document partial to use presigned URLs for private images
- Standardized document image access to `documents/{document_id}/{filename}`
- Removed remaining hardcoded S3 URLs from Documents views
- Aligned Documents image loading behavior with Games S3 implementation

## [1.21.30] 2026/01/18

### Changed
- Added app-specific IAM credentials for S3 access
- Standardized S3 object structure for games to `games/{game_id}/{filename}`
- Updated image handling to store only filenames in the database
- Implemented dynamic S3 key generation based on model ID
- Added presigned URL generation for private game images at render time
- Replaced hardcoded S3 URLs with helper-based resolution
- Centralized S3 access logic in `S3Service`
- Introduced `S3Helper` for consistent frontend image loading
- Prepared infrastructure for mixed public and private S3 objects
- Improved separation between application storage and other projects


## [1.21.29] - 2026-01-17

### Fixed
- Fixed level reward redemption failing for previously earned rewards when redeemed from the rewards index
- Resolved "No reward earned for today" error when redeeming historical level rewards

### Changed
- All-rewards level redemption now passes `reward_id` instead of relying on `earned_date`
- Unified redemption flow so:
  - Level 1 rewards redeem by record ID
  - Level 2 rewards redeem by record ID + selected game
- Daily reward redemption logic remains date-based and unchanged

### Confirmed
- Old earned level rewards can be redeemed correctly from the index
- Game selection is enforced for level 2 rewards in both daily and historical flows
- Task reward redemption remains isolated and unaffected

## [1.21.28] - 2026-01-16

### Fixed
- Quit livin' in the past

## [1.21.27] - 2026-01-12

### Fixed
- `recurring_task_generator.rb` updated so that task's eligible rewards populate, that's pretty important... Also updated some times in the case statement for more accurate representations

## [1.21.26] - 2026-01-11

### Fixed
- Fixed level reward redemption incorrectly redeeming task-scoped rewards
- Enforced `scope = "level"` filtering in level reward redemption logic
- Prevented task rewards from being selected by level redemption queries
- Corrected guard clause ordering in `RewardsController#redeem` to avoid invalid reward selection
- Resolved missing control flow causing inconsistent redemption behavior

### Changed
- Level reward redemption now exclusively operates on:
  - `kind = "earned"`
  - `scope = "level"`
  - matching `earned_date` and `level`
- Removed redundant scope checks now enforced directly by query constraints
- Clarified redemption responsibility boundaries:
  - Task rewards are redeemable only via `redeem_task`
  - Level rewards are redeemable only via `redeem`

### Confirmed
- Task rewards and level rewards are fully isolated in both creation and redemption paths
- Multiple level rewards per day are supported and function independently
- Existing database uniqueness constraints remain valid and intentional


## [1.21.25] - 2026-01-11

### Added
- Added `eligible_reward` column to `goals` to define concrete, goal-owned task rewards
- Task rewards are now created explicitly when a task is completed on time
- Introduced `scope = "task"` rewards fully separate from level rewards
- Task rewards store explicit payload data:
  - `task_id`
  - `goal_id`
  - `level`
  - `item`
  - `earned_date`
- Dedicated task reward redemption endpoint (`redeem_task`)
- UI section for displaying and redeeming today’s task rewards

### Changed
- Reward creation logic removed entirely from SMART metadata
- Task completion flow now deterministically creates task rewards when eligible
- Rewards system now enforces a hard separation:
  - Task rewards are immediate and consumable
  - Level rewards are daily, gated, and non-stackable
- Rewards index logic now correctly filters by `scope`
- Confirmed all existing reward documentation remains valid after changes

## [1.21.24] - 2026-01-11

### Added
- Task-scoped rewards using existing `rewards` and `reward_tasks` tables
- `scope` field on rewards to distinguish `task` vs `level` rewards
- Automatic task reward earning on task completion
- UI support for redeeming task rewards independently of level rewards
- Dedicated task reward redemption endpoint (`redeem_task`)
- Display section for today’s task rewards on the rewards index page

### Changed
- Reward logic updated so only `scope: "level"` rewards consume a level
- Rewards index logic now filters earned and redeemed rewards by scope
- Task completion flow consolidated into a single deterministic callback
- Reward earning date normalized to use completion date when present
- `ideas_goals_tasks.rb` updated to not set completion date for tasks that are not completed
- `user.rb` seed logic updated to require manual approval for the test user instead of auto-approving with a hardcoded password
- Refactored `rewards/index.html.erb` to correctly separate task-scoped and level-scoped rewards

### Removed
- Legacy assumption that one redeemed reward consumes an entire level
- Implicit coupling between task rewards and level reward redemption
- Redundant `tasks.rb` seed file (logic now consolidated in `ideas_goals_tasks.rb`)

## [1.21.23] - 2026-01-03

### Changed
- `daily_reward_earner` removed duplicate `task.completed?` checks
- Reward redemption state is now scoped to the current day to prevent previously redeemed rewards from blocking new ones
- Rewards can be earned even when older earned or redeemed rewards exist in the database
- Reward redemption is now limited to the same day the reward is earned

### Updated
- `rewards/index.html.erb` removed date noise from the all-rewards listing

## [1.21.22] - 2026-01-02

### Changed & Added
- `seeds.rb` related files updated to work with db as it currently exists for all tables

## [1.21.21] - 2026-01-01

### Added
- Added `completed_reward_url` and `completed_reward_notes` fields to rewards to capture raw gameplay evidence on completion.
- Enforced completion validation requiring a raw footage path when a reward is marked as completed.
- Displayed raw footage path and session notes on the reward show page in copy friendly format.

### Changed
- Reward completion now gated on tangible output rather than time spent.
- Reward edit flow updated so redeemed rewards transition to completed only with evidence.

### Fixed
- Fixed reward show template syntax error caused by unclosed form block.
- Corrected reward form structure so completion fields submit and persist correctly.

## [1.21.20] - 2026-01-01

### Changed
- Removed global `.completed` CSS to stop cross-component styling bleed
- Replaced Sass `@extend` usage with explicit, component-scoped completed styles
- Cleaned up goal styling so completion state is owned by goals only

## [1.21.19] - 2026-01-01

### Changed
- Rewards index UI updated to visually group rewards by status (earned, redeemed, completed) with simple color coding
- Renamed `level-1-reward` and related CSS classes to `level-reward` to reflect multi-level usage
- Improved reward list clarity without altering reward logic or persistence

## [1.21.18] - 2026-01-01

### Changed
- `_calendar.scss` updated to improve daily task container layout using flex wrapping and constrained widths
- Daily task levels now size consistently across screen widths without affecting task density
- Visual separation added between daily and monthly calendar views via `<hr>` in `calendar/show.html.erb`

### Notes
- No functional changes to task logic or reward evaluation
- Calendar updates are strictly presentational and intentionally low impact

## [1.21.17] - 2026-01-01

### Changed
- Introduced third reward lifecycle state: `completed`
- Rewards now progress through `earned → redeemed → completed` instead of being destroyed
- Redeemed rewards can be manually marked as completed while remaining in the database
- Rewards index updated to support distinct handling of:
  - Earned rewards (actionable)
  - Redeemed rewards (in use)
  - Completed rewards (historical)

### Changed
- RewardsController updated to:
  - Support updating reward `kind` via show page
  - Allow marking rewards as `completed` without deleting records
- Reward show page updated to allow inline editing of reward description and lifecycle state

### Notes
- Completed rewards no longer appear as actionable items
- Historical reward data is preserved for auditing and reflection
- “Recently used rewards” groundwork laid without enforcing hard controller filtering yet

## [1.21.16] - 2025-12-31

### Changed
- `recurring_task_generator.rb` updated to accurately populate estimated time for newly added level 1 and 2 tasks
- `calendar/show.html.erb` modified to link to the edit page instead of the show page of the related task accessed


## [1.21.15] - 2025-12-30

### Changed
- Rewards index view updated to support per-level reward rendering (Levels 1–3) in a single loop
- Level 2 reward redemption updated to require explicit game selection via dropdown
- Reward redemption flow now blocks Level 2 redemption when no game is selected
- Reward payload assignment refined so:
  - Level 1 auto-assigns a random public game
  - Level 2 assigns a user-selected public game
  - Level 3 assigns no gaming metadata
- RewardsController redeem action updated to validate level-specific requirements before mutation

### Fixed
- Fixed rewards index crashes caused by nil `reward_payload` access
- Fixed missing Redeem button state after task completion
- Fixed silent Level 2 reward redemption when `game_id` was missing
- Fixed flash messaging not appearing due to missing layout handling
- Fixed reward index view assumptions after task table truncation/reset

### Removed
- Removed placeholder SVG usage from reward cards
- Removed global gaming assumptions from reward rendering logic

### Notes
- Task table was truncated and ID sequence reset to reestablish a clean reward state
- Current reward UI is intentionally minimal and scoped for future expansion without refactor

## [1.21.14] - 2025-12-30

### Changed
- Replaced `RewardEarner` with `DailyRewardEarner` as the single reward creation mechanism
- Task completion now triggers `DailyRewardEarner.run(due_date)` via `Task` model callback
- Daily rewards are now evaluated per level (1, 2, 3) instead of a single global reward
- RewardsController updated to:
  - Load earned rewards grouped by level for the current day
  - Track redeemed levels independently
  - Redeem rewards by explicit level parameter
- Reward redemption logic updated so:
  - Only Level 1 injects gaming related payload data
  - Level 2 and Level 3 rewards are generic and non-gaming
- Rewards index view updated to support multiple daily rewards (one per level)
- Existing Heroku scheduled rake task updated to run both recurring task generation and daily reward evaluation

### Removed
- Removed all remaining references to `RewardEarner`
- Removed assumptions of a single daily reward
- Removed gaming specific behavior from non-Level 1 rewards
- Removed reward creation side effects from controllers and views

### Fixed
- Fixed reward payload contamination across reward levels
- Fixed reward index view assumptions that caused undefined variables
- Fixed reward show page crash when reward record was missing
- Fixed reward redemption incorrectly applying game data to all reward levels

### Notes
- Daily rewards are now level scoped and date scoped
- Reward creation occurs in exactly one place via `DailyRewardEarner`

## [1.21.13] - 2025-12-24

### Changed
- `recurring_task_generator` updated to include 30 minutes associated with 'career' related goals that convert to tasks, or 60 minutes otherwise if no match to anything that already exists

## [1.21.12] - 2025-12-24

### Changed
- recurring task generator now creates daily tasks for all recurring goals regardless of level (assuming recurring = true)
- task priority is now derived directly from goal priority
- default estimated time logic refined to match specific Level 2 task types (walk dog, chores, push-ups)

## [1.21.11] - 2025-12-23

### Changed
- rewards_controller now derives explicit daily state for Level 1 rewards (earned, redeemed, unavailable)
- rewards index UI updated to reflect completed today vs check back tomorrow states
- reward eligibility no longer inferred solely from task presence

## [1.21.10] - 2025-12-23

### Changed
- recurring_task_generator now only selects goals with priority = 1 and recurring = true
- removed chore specific logic from recurring generation; chores are not level 1 tasks
- added slug column to documents for stable, human readable URLs
- introduced slug based documentation routing via /docs/:slug
- DocumentsController now supports slug lookup with show_by_slug and reuses the standard show view
- linked Level 1 daily task column directly to Level 1 rewards documentation

## [1.21.9] - 2025-12-22

### Added
- Added Rewards index listing all reward records with links to individual reward pages
- Introduced basic Rewards show page to inspect reward metadata and payload contents
- Exposed redeemed reward history as append only records for long term tracking

### Changed
- Rewards index now derives availability strictly from earned reward records
- Reward redemption now consumes the earned reward record after use
- Reward system clarified into two explicit record types:
  - Earned rewards (temporary, date scoped)
  - Redeemed rewards (permanent, historical)
- Reward creation and redemption responsibilities fully separated between service and controller

### Fixed
- Fixed infinite reward redemption by enforcing earned reward consumption
- Removed all reward creation side effects from page rendering and navigation
- Corrected reward routing to use collection based redemption endpoint
- Eliminated accidental reward record overwrites by enforcing append only behavior for redeemed rewards
- Resolved multiple JSON vs column query mismatches in reward logic

### Notes
- Earned rewards are intentionally ephemeral and safe to delete after redemption
- Redeemed rewards persist across days and form the authoritative reward history
- Reward lifecycle is now deterministic, traceable, and debuggable end to end

## [1.21.8] - 2025-12-22

### Added
- Implemented Level 1 daily reward system driven by completion of priority 1 tasks
- Added `RewardEarner` service to safely create one reward per day when eligibility is met
- Introduced banked rewards as individual records that persist across days
- Added reward redemption behavior that:
  - Consumes a single banked reward
  - Assigns a random public game
  - Preserves original earning metadata

### Changed
- Rewards index now displays a persistent Level 1 reward card with locked and unlocked states
- Reward state is now derived from task completion plus earned reward records, not UI state
- Reward payload handling updated to append redemption data without overwriting earning data
- Level 1 reward flow clarified as:
  - Automatic earn on task completion
  - Manual consume via explicit user action

### Fixed
- Prevented duplicate reward creation by enforcing date scoped earning guards
- Eliminated reward creation during navigation or page rendering
- Corrected reward redemption logic to consume existing rewards only
- Stabilized reward gallery rendering with flex layout and deterministic container height
- Resolved missing reward visibility caused by empty public game datasets

### Notes
- Level 1 rewards are now fully deterministic and side effect free
- Reward creation occurs in exactly one place and one lifecycle event
- Reward records are append only in meaning and safe for future extension


## [1.21.7] - 2025-12-22

### Added
- Implemented Level 1 reward gate on Rewards index
- Added visual Level 1 reward card with locked and unlocked states
- Linked Level 1 reward gate to system documentation
- Added Level 1 documentation defining purpose, rules, and expectations
- Introduced automatic daily task generation for Level 1 recurring goals
- Wired recurring task generation to scheduler execution

### Changed
- Simplified Rewards index to focus solely on Level 1 reward state
- Moved detailed reward information and actions to Rewards show page
- Standardized Level 1 goals as recurring, priority 1, non-manual tasks
- Reset development database structure to validate Level 1 flow end to end

### Fixed
- Prevented reward redemption routing errors when no reward record exists
- Corrected reward image rendering using existing S3 path conventions
- Scoped reward-specific UI styling to avoid global side effects
- Resolved layout issues with reward gallery and overlay stacking

## [1.21.6] - 2025-12-22

### Changed
- Updated goal form to allow marking goals as recurring
- Enabled UI control for automatic daily task generation via recurring goals
- Updated GoalsController strong params to support recurring goals

## [1.21.5] - 2025-12-22

### Added
- Introduced recurring goals with automatic daily task generation
- Added `RecurringTaskGenerator` service to materialize daily tasks
- Added rake task `tasks:generate_recurring` for scheduled execution
- Wired recurring task generation to Heroku Scheduler

### Changed
- Standardized timezone handling:
  - UTC at the database level
  - Pacific Time for presentation
- Adjusted scheduler execution time to align with local midnight (PST/PDT)
- Hardened recurring task creation to be idempotent and date-based only

### Fixed
- Prevented duplicate recurring tasks for the same goal and date
- Ensured recurring tasks are never created in advance or retroactively

## [1.21.4] - 2025-12-22

### Added
- `reward_payload` (`jsonb`) to store reward redemption data
- Random public game assignment on reward redemption
- Reward show page displaying assigned game and redemption details

### Changed
- Removed humanStatus from TasksHelper, was irrelevant after previous updates in 1.21.2
- Reward redemption flow now redirects to the reward show page
- Rewards index now surfaces assigned game when present
- Reward cooldown logic hardened to safely handle `nil` and zero values

### Fixed
- Prevented reward redemption when no public games are available

## [1.21.3] - 2025-12-17

### Added
- Displayed `hold_until` on Goal and Task show pages when status is `on_hold`

### Changed
- Normalized `hold_until` to end of day in application time zone
- Ensured resume logic compares against local time to avoid early reopen behavior

### Fixed
- Fixed off by one day resume issues caused by UTC vs app time zone mismatch

## [1.21.2] - 2025-12-17

### Added
- Added `hold_until` datetime field to Goals and Tasks to explicitly represent paused items
- Introduced shared hold and resume behavior for Goals and Tasks via a reusable concern
- Implemented automatic resumption of on-hold Goals and Tasks when `hold_until` has passed
- Added support for scheduled daily execution to resume eligible records

### Changed
- Clarified separation between `due_date` and pause semantics by introducing `hold_until`
- Updated Goal and Task forms to allow setting a resume date when status is on hold

### Fixed
- Prevented paused Goals and Tasks from remaining stuck in on-hold state past their resume date

### Notes
- This relies on a scheduler set in Heroku directly
 - rails runner "Task.ready_to_resume.find_each(&:resume_if_ready!); Goal.ready_to_resume.find_each(&:resume_if_ready!)"

## [1.21.1] - 2025-12-16

### Changed
- Reworked Goals index into a kanban style layout with vertical columns by status (Not Started, In Progress, On Hold, Completed)
- Reworked Tasks index to match Goals with the same kanban style status columns
- Removed pagination from Goals and Tasks index views in favor of status based grouping
- Ensured consistent ordering within each status column by due date

## [1.21.0] - 2025-12-14

### Added
- Implemented SMART framework for tasks and goals using a single `jsonb` field
- Added reusable `SmartFields` concern to expose SMART attributes as first class model accessors
- Added shared SMART form partial for consistent input across tasks and goals
- Added shared SMART display partial for conditional rendering on show pages

### Changed
- Simplified status display to rely on enum provided `status.humanize`
- Removed redundant and error prone `human_status` model methods
- Updated task and goal forms to support SMART inputs without schema duplication

### Fixed
- Resolved enum misuse causing `nil.humanize` errors in task and goal views
- Hardened SMART display partial against nil records and empty data

## [1.20.1] - 2025-12-12

### Added
- Honeypot field added to the contact form to block automated spam submissions

### Changed
- Contact email delivery switched to background mail delivery

## [1.20.0] - 2025-12-12

### Added
- Implemented functional contact form with server-side email delivery using AWS SES
- Added `ContactMailer` to handle inbound contact messages
- Wired contact form submission into existing `ContactController`
- Added mailer view `contact_email.text.erb`

### Changed
- Replaced static contact email display with a working contact form
- Configured `production.rb` ActionMailer settings to use SES SMTP (`us-west-1`)
- Updated `contact/index.html.erb` to support form submission flow
- Updated `contact.scss` for layout and styling consistency
- Verified and configured domain email authentication (SPF, DKIM, DMARC)

### Fixed
- Removed invalid or broken contact page markup
- Cleaned up form structure and field handling
- Corrected mailer syntax and ensured proper `reply-to` behavior

## [1.19.7] - 2025-11-29

### Added
- document specific scss file created, referenced on application.scss

### Changed
- helper added to reference the appropriate s3 bucket / folder for documentation related images, other related changes to ensure use of s3 storage for this section of the site

## [1.19.6] - 2025-11-29

### Changed
- games/show html and scss has been un-chatGPTifyed

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

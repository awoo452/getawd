# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.30.99] - 2026-06-16
### Fixed
- Shopping list now shows Serving Size Label instead of unit for each item (falls back to unit if no label set)

## [1.30.98] - 2026-06-16
### Added
- Merge Active Lists button on shopping lists index combines all active lists into one, taking the higher quantity for any overlapping items and archiving the source lists

## [1.30.97] - 2026-06-15
### Fixed
- Generating a meal plan list when one already exists now refreshes the existing "From Meal Plans" list instead of creating a duplicate alongside it

## [1.30.96] - 2026-06-15
### Fixed
- Resubmitting Ryder's grocery picks no longer creates a duplicate "Ryder's Picks" shopping list — the existing active one is found and its items are replaced with the latest submission

## [1.30.95] - 2026-06-15
### Changed
- Shopping list generator now uses planned meals exclusively — only adds items needed to cook upcoming uncooked meal plans that aren't already sufficiently stocked; pantry-minimum logic removed entirely
- Generated lists are now labeled "From Meal Plans" instead of "Auto-Generated"
- Alert message updated to reflect the new logic when nothing is needed

## [1.30.94] - 2026-06-15
### Added
- `label` column on `shopping_lists` — displays where each list came from ("Ryder's Picks", "Auto-Generated", or custom)
- Shopping list index now shows all active lists (plural), each with its label badge; no longer limited to one active list at a time
- Label badge also visible on the shopping list show page header
### Changed
- Ryder's picks submission no longer archives existing active lists — lists now coexist
- Auto-generate no longer blocks creation when an active list exists — always creates a new one

## [1.30.93] - 2026-06-15
### Added
- Shopping list show page now has an "Add Item" form (grouped food item select + quantity) for adding items to an active list
- Remove button (✕) on each shopping list item — Turbo Stream removes it instantly without a page reload

## [1.30.92] - 2026-06-15
### Added
- `POST /api/v1/shopping_lists/submit` API endpoint — receives an array of `{food_item_id, quantity}` items from rydersworld, archives any current active shopping list, and creates a new active list with the submitted picks
- `Api::V1::ShoppingListsControllerTest` — 10 tests covering auth, validation, list creation, item quantities, archiving existing lists, quantity clamping, and zero-id skipping

## [1.30.91] - 2026-06-14
### Added
- Real logic tests for `Dashboard::IndexData` covering idea color coding (gray/green/yellow/red/black), time calculations, and due-today task counts
- Real logic tests for `Reports::IndexData` covering letter grade formula, completion rate, on-time vs late counts, missed task minutes, completion chain accuracy, and last completion date

## [1.30.90] - 2026-06-14
### Added
- Unit tests for all `IndexData` service objects: `Tasks`, `Goals`, `Reports`, `Dashboard`, `About`, `BlogPosts`, `Bugs`, `ChangeRequests`, `Contact`, `Documents`, `Games`, `Home`, `Landscaping`, `Projects`, `Rewards`, `Services`, `Videos` — previously had zero coverage

## [1.30.89] - 2026-06-14
### Refactored
- `RecipesController#active_food_items_by_type` now loads all active food items in a single query and groups in Ruby, replacing 7 per-type queries
### Added
- `MealPlanRecipeTest` covering quantity validations and uniqueness constraint

## [1.30.88] - 2026-06-14
### Refactored
- `ShoppingListsController` and `ShoppingListItemsController` now include `KitchenHelpers` and call `grouped_food_items` instead of duplicating the query inline
- `MealPlanRecipe` now validates uniqueness of `recipe_id` scoped to `meal_plan_id`, matching the DB constraint added in 1.30.86
### Added
- Tests for `PantryItem.needs_restock` scope (out-of-stock, low-stock, and in-stock cases)
- Tests for `Kitchen::IndexData` covering date parsing, week boundary logic, slot grouping, and pantry counts
- Tests for `MealCellResponder` concern via `MealPlansController` turbo stream and HTML responses
- Tests for `KitchenHelpers` concern verifying grouped food item structure and active filtering

## [1.30.87] - 2026-06-14
### Fixed
- `DropMealsTable` migration now guards with `table_exists?(:meals)` to avoid failing on environments where the table was never present

## [1.30.86] - 2026-06-14
### Refactored
- Added `PantryItem.needs_restock` scope combining out-of-stock and low-stock conditions; `ShoppingListsController#create` now uses it instead of duplicating the SQL inline
### Added
- Unique index on `meal_plan_recipes(meal_plan_id, recipe_id)` to enforce at the DB level what `find_or_initialize_by` was only guarding at the app level
- DB check constraint on `food_items.food_type` enforcing the same values as `FoodItem::FOOD_TYPES`; fixed `bread` fixture which had an invalid `grain` type — changed to `side`
### Fixed
- `MealPlan#task_label` now uses `recipes.select(:name)` when the association isn't loaded, avoiding a full association load inside `sync_task_name` callbacks
### Security
- Removed open redirect in `TasksController#complete_on_time`; dropped `return_to` param entirely and replaced with `redirect_back fallback_location: tasks_path` — all callers were passing `request.fullpath` anyway

## [1.30.85] - 2026-06-14
### Refactored
- `Kitchen::IndexData` loads all active recipes in a single query and groups by `meal_type_suggestion` in Ruby, replacing 7 per-slot queries for `recipes_for_slot`

## [1.30.84] - 2026-06-14
### Refactored
- Extracted `respond_with_cell` and `respond_with_empty_cell` into a `MealCellResponder` concern; removed the duplicate private methods from `MealPlansController`, `MealPlanItemsController`, and `MealPlanRecipesController`
- `MealPlanItemsController#destroy` now explicitly routes to `respond_with_empty_cell` when the plan is destroyed, eliminating a redundant `MealPlan.exists?` query that always returned true on the success path
- Extracted `KitchenController#index` data loading into `Kitchen::IndexData` service object; controller now assigns from the result struct, matching the pattern used by `Tasks::IndexData`, `Goals::IndexData`, etc.

## [1.30.83] - 2026-06-14
### Fixed
- `KitchenController#index` now calls `grouped_food_items` from `KitchenHelpers` instead of inlining the query; trailing blank lines removed from `MealPlanItemsController`, `MealPlanRecipesController`, and `MealPlansController`

## [1.30.82] - 2026-06-14
### Refactored
- Extracted `grouped_food_items` into a `KitchenHelpers` controller concern included by `KitchenController`, `MealPlansController`, `MealPlanItemsController`, and `MealPlanRecipesController` — it was copy-pasted identically in three of them.

## [1.30.81] - 2026-06-14
### Changed
- Contact link moved from public nav to signed-in nav to match the new auth requirement on the contact form.

## [1.30.80] - 2026-06-14
### Fixed
- `Api::V1::PantryController` now inherits from `Api::V1::ApplicationController` instead of `ApplicationController` — it was accidentally using Devise session auth instead of the API token.
- `PantryItem#add_unit!` no longer crashes when `unit_servings` is nil — added the same nil guard used everywhere else in the codebase.
- Shopping list low-stock quantity defaulted to 1 unit per item instead of using the stale `quantity_on_hand` field (which was always 0).
- `Date.parse` in `MealPlanItemsController` and `MealPlanRecipesController` now rescues `ArgumentError` so a bad date string returns 422 instead of 500.
- `EatLog::SLOTS` now references `MealPlan::SLOTS` directly — the old hardcoded `%w[breakfast lunch dinner]` blocked logging snack and dessert meal slots.
- Contact form now requires authentication to stop spam submissions.
- `MealPlanItemsController#destroy` wraps item and meal plan deletion in a transaction so a failed meal plan destroy can't leave orphaned items.
### Removed
- Deleted `SmartFields` concern — was never included anywhere; `store_accessor` already provides the same methods.
- Removed dead `EatLogsController#respond_with_cell` method (never called; all actions use `respond_with_cell_and_fridge`).
- Dropped orphaned `meals` table (no model, no controller, no references).
- Dropped `quantity_on_hand` and `min_quantity` columns from `pantry_items` — app migrated to `servings_on_hand`/`min_servings`; these were initialized to 0/1 on create and never touched again.

## [1.30.79] - 2026-06-14
### Fixed
- `test_create_alerts_when_nothing_is_needed` was failing after adding the `bread_pantry` fixture (servings_on_hand: 0) which triggered the low-stock check. Test now explicitly stocks all pantry items above their minimums before asserting no list is generated.
### Added
- Model tests for `ShoppingList`, `ShoppingListItem`, `FoodItem`, `RecipeIngredient`, and `MealPlanItem`.
- Controller tests for `FoodItemsController`, `PantryItemsController`, `RecipesController`, and `Api::V1::RecipesController`.

## [1.30.78] - 2026-06-14
### Added
- Full test coverage for shopping lists and shopping list items: index, show, create, archive, destroy, toggle pantry increment/decrement, replace, and minimum quantity enforcement.

## [1.30.77] - 2026-06-14
### Fixed
- Shopping list show page was throwing 500 due to `f.grouped_select` not being a real Rails helper. Changed to `f.select` with `grouped_options_for_select`.

## [1.30.76] - 2026-06-14
### Added
- Checking off a shopping list item now increments its pantry stock; unchecking decrements it. Added substitute form on each item (tap "Sub" to swap for a different food item and quantity). Renamed "Archive" button to "Done Shopping."
- Quantity on each shopping list item is now an editable inline field — change the number and hit ✓ to update without generating a new list.

## [1.30.75] - 2026-06-14
### Fixed
- Shopping list on-hand count now handles null unit_servings safely and displays as "X unit on hand" for clarity.

## [1.30.74] - 2026-06-14
### Added
- Shopping list now shows how many units you currently have on hand next to each item so you can see the shortfall at a glance.

## [1.30.73] - 2026-06-14
### Fixed
- Shopping list generator now includes active out-of-stock pantry items, which the previous low-stock scope excluded.

## [1.30.72] - 2026-06-14
### Added
- Shopping list generator now includes ingredients for upcoming uncooked meal plans that aren't covered by current pantry stock, in addition to the existing low-stock pantry pass.

## [1.30.71] - 2026-06-14
### Added
- Meal planner now shows 7 slot rows: Breakfast, Morning Snack, Lunch, Afternoon Snack, Dinner, Dessert, Bedtime Snack. Snack/dessert slots do not generate tasks or goals.

## [1.30.70] - 2026-06-14
### Fixed
- Deleting a food item or recipe that's still referenced in a meal plan now returns a flash alert instead of a 500. Added `dependent: :restrict_with_error` on `FoodItem#meal_plan_items` and `Recipe#meal_plan_recipes`.

## [1.30.69] - 2026-06-14
### Fixed
- Hamburger menu had no horizontal margin after being moved outside its wrapper. Added margin and corrected width to match original inset appearance.
- Non-signed-in users on mobile had no visible nav links — the public link collapsing was not scoped to signed-in state. Added `.navbar-signed-in` class and scoped all hamburger collapse/expand CSS to it.
- Hamburger now sits below all links when expanded (moved label to end of DOM) so all content is consistently above it rather than split on both sides.

## [1.30.68] - 2026-06-14
### Fixed
- Restored hamburger to original full-width style below the logo. Moved the label after nav_public in the DOM so the single hamburger now controls all links (public + signed-in), without changing its appearance.

## [1.30.67] - 2026-06-14
### Changed
- Mobile nav now collapses ALL links (public + signed-in) into a single hamburger menu. Logo always stays visible. Hamburger is a small button positioned top-right next to the logo instead of a full-width bar.

## [1.30.66] - 2026-06-14
### Fixed
- Restored day navigation on mobile kitchen view. The previous mobile layout hid the week nav without a replacement. Now shows a Prev/Next day nav on mobile (hidden on desktop) via `/kitchen/day/:selected_date`. The meal planner and eat log both track the selected date's column rather than hardcoding today.

## [1.30.65] - 2026-06-14
### Fixed
- Logout button no longer has a visible border or background — matches the other nav icon links.

## [1.30.64] - 2026-06-14
### Changed
- On mobile (≤750px), nav icon tooltips are replaced with permanent labels rendered below each icon. CSS hover-based tooltips don't work on touch screens, so labels are always visible instead.
### Fixed
- Mobile nav icon labels now visible: added `order: 1` so the `::before` label renders below (not above) the SVG icon in the flex column layout, `!important` on `opacity: 1` and `animation: none` to win the cascade, and explicit `color` so the text is always white regardless of inherited styles.

## [1.30.63] - 2026-06-14
### Fixed
- Nav tooltips now also trigger on `:active` so they fire on touchstart in iOS Safari, which doesn't reliably apply `:focus` to anchor elements on tap.

## [1.30.62] - 2026-06-14
### Fixed
- Nav tooltips now trigger on `:focus` in addition to `:hover`, so tapping an icon on mobile briefly shows the label before navigating.

## [1.30.61] - 2026-06-14
### Fixed
- CSS tooltip now auto-hides after ~2s via `@keyframes` animation instead of a plain `transition`. Prevents the tooltip from sticking after Turbo Drive navigation (navbar persists across page changes so hover state doesn't clear). Moving the cursor off and back resets it.

## [1.30.60] - 2026-06-14
### Fixed
- Restored `border-top` on `.nav-signed-in` and added `position: relative; z-index: 1` to `.nav-signed-in-wrapper` so the icon row renders above the line instead of behind it
- Increased navbar `z-index` from 30 to 1000 so CSS tooltips appear above page content

## [1.30.59] - 2026-06-14
### Changed
- Replaced slow native browser title tooltips with CSS-only tooltips via `data-tooltip` + `::before` pseudo-element. Appear in ~150ms on hover instead of the browser's ~1s delay. No JavaScript.

## [1.30.58] - 2026-06-14
### Changed
- Replaced signed-in nav text links with hand-drawn inline SVG icons. Calendars use a calendar base with "1" and "31" to distinguish daily vs monthly. All other icons: dashboard=grid, docs=book, gaming=controller, goals=bullseye, chores=checklist, kitchen=fork+knife, workouts=dumbbell, reports=bar chart, rewards=star, tasks=checkbox, change requests=circular arrows, bugs=bug, logout=door+arrow. No external library.

## [1.30.57] - 2026-06-14
### Changed
- Replaced public nav text links with hand-drawn inline SVG icons (About=person, Blog=pencil, Contact=envelope, Docs=file, Projects=folder, Services=wrench, Videos=play). No external icon library. Each link has `aria-label` and `title` for accessibility/tooltips.

## [1.30.56] - 2026-06-14
### Fixed
- Mobile nav toggle: replaced cross-ancestor `~` sibling selector (unreliable when compiled by SCSS) with `:has(.nav-toggle-checkbox:checked)` on the wrapper. Hamburger and signed-in links now correctly show/hide on tap.

## [1.30.55] - 2026-06-14
### Security
- Updated `bootsnap` from 1.23.0 to 1.24.6
- Updated `aws-sdk-s3` from 1.219.0 to 1.225.1 (includes `aws-sdk-core` 3.252.0, `aws-sdk-kms` 1.129.0, `aws-partitions` 1.1260.0)
- Updated `jbuilder` from 2.14.1 to 2.15.1
- Updated `selenium-webdriver` from 4.43.0 to 4.44.0

## [1.30.54] - 2026-06-14
### Fixed
- Collapsible hamburger menu for logged-in nav on mobile (≤ 750 px). Uses a hidden checkbox + label toggle — no JavaScript. On desktop the signed-in links render normally. On mobile they collapse behind a three-bar button (animates to an X when open) that stays within the navbar width via `box-sizing: border-box` and wrapper padding. Logo scales from 150 px to 75 px on mobile.

## [1.30.53] - 2026-06-14
### Fixed
- rubocop -a

## [1.30.52] - 2026-06-14
### Security
- Updated `net-imap` from 0.6.4 to 0.6.4.1 to address CVE-2026-47240 (command injection via non-synchronizing literal), CVE-2026-47241 (DoS via incomplete raw argument validation), and CVE-2026-47242 (command injection via ID command argument).

### Added
- Mobile single-day calendar view. At ≤ 750 px the Meal Planner and Eating This Week tables collapse to show only today's column. The week nav is hidden. Implemented with pure CSS: the server stamps `today-col-N` (where N is `Date.wday`, 0 = Sunday) on the wrapper div; each day cell carries a matching `day-col-N` class; a `@for` loop in SCSS generates rules that hide all non-matching columns. No JavaScript involved.

## [1.30.51] - 2026-06-13
### Added
- **Shelf life** field (`shelf_life_days`, integer, optional) added to food items and recipes. Set it on the food item edit form ("Shelf Life (days)") or the recipe form. The pantry card shows `Xd shelf life` when set. When a meal is cooked, the shelf life from the recipe is copied to the prepared dish and the fridge card shows an expiry date ("exp Jun 17"), highlighted in red when 1 day or fewer remain or when expired.
- **Custom dish name** field in the meal planner. When a meal slot has custom food items (non-recipe items) and has not yet been cooked, a name input field now appears directly above the Cook button. Type a name before clicking Cook and the prepared dish in the fridge will use that name instead of the default "Slot — Custom Items" label.

## [1.30.50] - 2026-06-11
### Fixed
- Pantry item badge now shows `servings_on_hand` (actual quantity, e.g. "7 oz") instead of `derived_servings` (e.g. "1 oz"). The secondary raw line now shows the derived serving count "(1 srv)" when `servings_per_unit > 1`. Previously "1 oz" was shown for an item with 7 oz stored and 7-oz serving size, which looked like only 1 oz was available.

## [1.30.49] - 2026-06-11
### Fixed
- `EatLogsController#destroy` now restores the serving back to the `PreparedDish` when deleting an eaten log (the × button), and refreshes the fridge display. Previously only the `toggle_eaten` path (✓/○ button) restored servings — deleting a log permanently lost the serving.

## [1.30.48] - 2026-06-10
### Changed
- `Api::V1::DishesController#consume` now returns `dish_id` in the response body so callers can track exactly which dish was consumed.
- `Api::V1::DishesController#restore` now accepts an optional `dish_id` param to restore the exact consumed dish. Falls back to oldest-first by `recipe_id` when no `dish_id` is given.

## [1.30.47] - 2026-06-09
### Fixed
- All workout/chore plan tests that check task creation now use `Time.zone.today` so the `planned_on <= today` guard passes. Tests checking only validations keep future dates.
- `MealPlanRecipe#sync_meal_plan_task` now calls `meal_plan.recipes.reset` before computing `task_label`, clearing the stale cache left from `generate_task` running with no recipes. This fixes task names staying as "Custom Meal" after a recipe is added.
- Recipe ingredient Remove button: pure Rails solution, no JavaScript. Remove is a named submit button (`remove_ingredient[id]`) inside the recipe form — same pattern as `add_ingredient`. Controller catches it, calls `mark_for_destruction` on the target ingredient, re-renders without saving. On re-render, destroyed ingredients emit only hidden `id`+`_destroy=1` fields so they get cleaned up when the user clicks Save. New (unsaved) ingredient rows have no Remove button; blank rows are rejected by `reject_if`.
- Recipe ingredient Remove button now works. The CSP nonce policy blocks ALL inline `<script>` tags in views — every previous approach was silently killed before it ran. Moved the remove-button logic into `application.js` (loaded from a file, not inline, so CSP allows it), using `turbo:load` with a `data-bound` guard.

## [1.30.46] - 2026-06-09
### Fixed
- Recipe ingredient Remove button now actually fires: switched inline script to use `turbo:load` event so listeners are attached on every Turbo Drive navigation (not just the initial parse), with a `data-bound` guard to prevent double-binding. Removed the superfluous select reset that could throw if the element was missing.

## [1.30.45] - 2026-06-09
### Fixed
- Recipe ingredient Remove button now works for both saved and newly-added rows. Click hides the row client-side and marks `_destroy=1`; deletion only commits on Save. Cancel discards all pending changes.

## [1.30.44] - 2026-06-09
### Fixed
- Recipe ingredient remove is now client-side: clicking "Remove" hides the row and sets a hidden `_destroy` field to 1. The deletion only commits when "Save Changes" is clicked. Canceling discards all pending removes. Reverted the controller redirect back to show after save.

## [1.30.43] - 2026-06-09
### Fixed
- Recipe ingredient "Remove" button now works. Replaced the `link_to` with `data-turbo-method` (which fails inside a `form_with` because browsers strip nested forms) with a submit button that sends `_destroy: 1` for that ingredient through the existing recipe form. Also redirects back to edit after saving so the user stays in context.

## [1.30.42] - 2026-06-09
### Changed
- Pantry item serving badge now shows the food item's `serving_size` label (e.g. "3 oz") instead of the generic "srv". Falls back to "srv" when no label is set.

## [1.30.41] - 2026-06-09
### Changed
- Workout notes textarea default height increased from 56px to 224px (4×).

## [1.30.40] - 2026-06-09
### Fixed
- Workout and chore plans no longer create Tasks immediately when scheduled for a future date. Tasks are now created at `after_create` only when `planned_on` is today, and `RecurringTaskGenerator` picks up any task-less plans each midnight via the existing Heroku Scheduler rake job.

## [1.30.39] - 2026-06-09
### Fixed
- Updated all tests that built `MealPlan` with the old `recipe:` attribute to use `meal_plan_recipes.create!` instead. Fixed `meal_plan_items` test that called `.recipe` directly on the model.

## [1.30.38] - 2026-06-09
### Fixed
- Updated `meal_plans` fixture to remove the dropped `recipe` column; added `meal_plan_recipes` fixture to wire the join table for tests.

## [1.30.37] - 2026-06-09
### Fixed
- Adding a recipe for the first time was showing ×2 because the column default (1) was being incremented before save. New records now save at quantity 1; existing records increment.

## [1.30.36] - 2026-06-08
### Added
- Recipe quantity on meal plan cells: adding the same recipe again increments a quantity counter (shown as ×2, ×3, etc.). Inventory deduction and PreparedDish servings are multiplied accordingly.

## [1.30.35] - 2026-06-08
### Added
- Meal planner cells now support multiple recipes per slot. Recipes are stored in a new `meal_plan_recipes` join table; existing single-recipe data is migrated automatically. Each recipe gets its own PreparedDish when cooked. Add/remove recipes inline just like food items.

## [1.30.34] - 2026-06-08
### Fixed
- Recipe meal type filters were using query params (`?meal_type=`) which CloudFront strips. Switched to path-based routing (`/recipes/filter/:meal_type`) so filters survive in production.

## [1.30.33] - 2026-06-08
### Fixed
- `POST /api/v1/pantry/deduct` and `/restore` were calling `.uniq` on incoming IDs and using `where(id: ids)` which deduplicated naturally, so adding the same food item twice only counted as one deduction. Now uses `.tally` to count occurrences and multiplies the deduction/restore amount by the count.

## [1.30.32] - 2026-06-08
### Fixed
- `GET /api/v1/recipes` was raising a 500 because the controller called `r.meal_type` instead of `r.meal_type_suggestion`. Corrected the field name.

## [1.30.31] - 2026-06-08
### Added
- `POST /api/v1/pantry/restore` — re-increments pantry `servings_on_hand` by `servings_per_unit` for each provided `food_item_id`. Mirrors `deduct`; called when rydersworld un-marks a meal as eaten.
- `GET /api/v1/recipes` — returns active recipes with `id`, `name`, `meal_type`, and `servings` for rydersworld template linking.
- `POST /api/v1/dishes/consume` — finds the oldest active `PreparedDish` for the given `recipe_id` and decrements it by one serving. No-op if no active dish exists.
- `POST /api/v1/dishes/restore` — finds the most recent `PreparedDish` for the given `recipe_id` and increments it by one serving. Called when rydersworld un-marks a meal as eaten.

## [1.30.30] - 2026-06-08
### Added
- `PreparedDish` model — tracks cooked dishes with a `servings_remaining` count. Created automatically when a meal plan is marked cooked; destroyed if uncooked before any servings are consumed.
- `EatLog` model — tracks individual eating entries by date and meal slot, optionally linked to a `PreparedDish`. Marking an entry eaten decrements the dish's serving count via `consume_one!`.
- `PreparedDishesController#destroy` — removes a dish from the fridge with Turbo Stream response.
- `EatLogsController` — `create`, `destroy`, and `toggle_eaten` actions; `toggle_eaten` responds with two Turbo Stream updates (eat log cell + fridge section) so serving counts stay live on the page.
- Kitchen page now shows an "In the Fridge" section (active prepared dishes with serving badges) and an "Eating This Week" calendar directly below the Meal Planner using the same week navigation.

## [1.30.29] - 2026-06-08
### Added
- `GET /api/v1/pantry` — JSON API endpoint returning all active food items with pantry stock status and `servings_on_hand`. Protected by Bearer token (`GETAWD_API_TOKEN` env var).
- `POST /api/v1/pantry/deduct` — accepts `food_item_ids` array, deducts one unit (`servings_per_unit` raw servings) per item from pantry. Silently skips items with no pantry record; floors at zero.

## [1.30.28] - 2026-06-08
### Changed
- Marking a meal plan as cooked now completes the associated task (`status: completed`, `completion_date: planned_on`); uncooking reverts it to `not_started`.
- Marking a workout as done now completes the associated task; undoing reverts it to `not_started`.
- Saving workout notes now syncs them to the associated task's `description` field.
- Added model-layer `after_update` callbacks on `MealPlan` and `WorkoutPlan` — no controller changes required.

## [1.30.27] - 2026-06-08
### Changed
- Workout types replaced: `run/body_combat/pushups` → `walk/vr/board_push/board_pull`. Weekly targets: 2× walk, 2× VR, 1× board each, 1× rest.
- Board split: Chest & Triceps (push day) and Shoulders & Back — maps to the 4 color-coded positions on the push-up board.
- Cardio goal renamed from "Tacoma City Half Marathon" → "Cardio Fitness" in both DB (data migration) and fixtures.
- Converted `.workout-planner-grid` from CSS Grid to Flexbox.
### Added
- `notes` text field on each workout card — log sets, reps, duration, etc. Saves inline via Turbo Stream PATCH.
- `completed` boolean with "Mark Done" / "↩ Undo" Turbo Stream toggle. Summary bar count turns green when weekly target is hit.
- `WorkoutPlansController#toggle_complete`, `PATCH /workout_plans/:id/toggle_complete`.
- Extracted `_workout_day_card` partial with `id="workout_day_YYYY-MM-DD"` for Turbo targeting.

## [1.30.26] - 2026-06-08
### Changed
- Moved `deduct_inventory!` / `restore_inventory!` from `MealPlansController` private methods to public methods on `MealPlan` model where they belong.
- Extracted `ingredient_quantity_label` view logic from inline ERB in recipe show into `RecipesHelper`.
- Removed dead `cook` action and `POST /recipes/:id/cook` route — "I Cooked This" button was already removed from the show page.

## [1.30.25] - 2026-06-08
### Changed
- Moved `deduct_inventory!` / `restore_inventory!` from `MealPlansController` private methods to public methods on `MealPlan` model where they belong.
- Extracted `ingredient_quantity_label` view logic from inline ERB in recipe show into `RecipesHelper`.
- Removed dead `cook` action and `POST /recipes/:id/cook` route — "I Cooked This" button was already removed from the show page.
### Fixed
- Removed orphaned `.meal-planner-cell` CSS class from meal cell div (no rule exists for it).
- Removed unused `.meal-planner-remove-all` CSS rule (no template references it).
- Test: updated `KitchenControllerTest` to assert `.meal-planner-table` instead of `.meal-planner-grid` (renamed when rebuilding from CSS Grid to Flexbox).
### Tests
- Added fixtures: `food_items`, `pantry_items`, `recipe_ingredients`, `meal_plan_items`.
- Added `RecipeIngredientsControllerTest` (destroy HTML + Turbo Stream).
- Added `MealPlanItemsControllerTest` (create with quantity, blank guard, auto-create plan, destroy cleanup).
- Added `MealPlansControllerTest` toggle_cooked tests (cook deducts, uncook restores).
- Added `MealPlanTest` inventory deduction/restoration tests.
- Added `RecipeTest` (`can_cook?`, `missing_ingredients`).

## [1.30.24] - 2026-06-08
### Fixed
- Recipe edit save button broken: `button_to` for Remove inside `form_with` creates nested `<form>` tags, causing the browser to close the outer form early and orphan the Save button. Replaced with `link_to` + `data-turbo-method="delete"` — no nested form, same CSP-safe Turbo DELETE behavior.
- Recipe show ingredient quantity now multiplies `ri.quantity * servings_per_unit` before displaying the serving_size label (e.g. "0.5 cup" instead of "1 cup" for a 0.5-cup avocado serving). Falls back to `quantity unit` when no serving_size label is set.

## [1.30.23] - 2026-06-08
### Fixed
- Recipe show ingredient list now uses `serving_size` label (e.g. "2 slices") instead of the container `unit` (e.g. "2 pack") — falls back to `unit` when `serving_size` is blank.

## [1.30.22] - 2026-06-08
### Added
- Meal planner cells now show a "Cook" / "✓ Cooked" button that deducts (or restores) inventory for all recipe ingredients and added items via `MealPlansController#toggle_cooked`. Each ingredient deducts `quantity * servings_per_unit` raw units.
- Quantity field added to the add-item form in each meal cell so users can add more than 1 serving at a time.
- Quantity shown next to each MealPlanItem in the cell (e.g. "Eggs (2)").
- Migrations: `cooked` boolean on `meal_plans`, `quantity` integer on `meal_plan_items`.
### Removed
- "I Cooked This" button from recipe show page — replaced by the meal planner cooked toggle.

## [1.30.21] - 2026-06-07
### Fixed
- Recipe ingredient remove: added `RecipeIngredientsController#destroy`, wired Remove button as a `button_to` DELETE with Turbo Stream response that removes the row from the DOM. Removed dead `.recipe-ingredient-destroy-check` CSS.

## [1.30.20] - 2026-06-07
### Fixed
- Recipe show page: ingredient stock check was using `quantity_on_hand` (packs) instead of `derived_servings` — now shows correct "on hand" count and "need X more" in servings.

## [1.30.19] - 2026-06-07
### Fixed
- Cooking a recipe now deducts `quantity * servings_per_unit` raw units from `servings_on_hand` instead of just `quantity` — was taking whole packs instead of individual servings.
- `can_cook?` and `missing_ingredients` now compare `derived_servings` against `ri.quantity` instead of `quantity_on_hand`, so availability checks match the same units as the deduction.

## [1.30.18] - 2026-06-07
### Fixed
- Meal planner rebuilt with flexbox: outer table `flex-direction: column`, rows `flex-direction: row`, day cells `flex: 1`. Fixed overflow: `box-sizing: border-box` + `max-width: 100%` on `.kitchen-wrapper` and `.meal-planner-table` so padding doesn't push the container past the viewport.
- Forms always visible in cells — no hover-triggered layout shifts.

## [1.30.17] - 2026-06-07
### Fixed
- Meal planner "+" wiped cell on blank submission: guard blank `food_item_id` in controller (returns 422, no DOM change), added `required` on select, wrapped create in transaction so no orphaned MealPlan on failure.
- Meal planner CSS: `.meal-planner-form` was `flex-direction: column` with `width: 100%` submit — every empty cell showed a giant full-width blue button. Changed to row layout, auto-width submit, inline select+button.
- Empty cells now dim at 35% opacity until hovered/focused — reduces visual clutter across 21 empty cells.

## [1.30.16] - 2026-06-07
### Fixed
- `_meal_cell.html.erb`: replaced non-existent `f.grouped_select` with `f.select` + `grouped_options_for_select` — was crashing all meal planner cells in production.

## [1.30.15] - 2026-06-08
### Added
- Meal planner cells now support individual food items alongside recipes. Add sides independently via grouped dropdown in every cell.
- `meal_plan_items` table and model — each item links a meal plan to a food item.
- `MealPlanItemsController` — create/destroy with Turbo Stream cell replacement.
- `remove_recipe` action on meal plans — removes recipe from a slot without wiping added sides.
- All meal planner actions (create, destroy, add item, remove item) now respond with Turbo Streams.
- rubocop -a

## [1.30.14] - 2026-06-08
### Added
- `recipes.sql` — 15 themed recipes (Mon–Fri, breakfast/lunch/dinner). Deactivates all existing recipes. Adds Blue Cheese Crumbles, Craisins, and Parmesan as new food items.
- `grocery_list.md` — shopping list for the week.

## [1.30.13] - 2026-06-08
### Fixed
- `derived_servings` now always divides by `servings_per_unit` — the `<= 1` shortcut was skipping division for decimals under 1, breaking display and `+1` unit math.

## [1.30.12] - 2026-06-08
### Added
- Min Servings field moved to food item edit page via nested attributes.
- Pantry item names now link to the food item edit page.

## [1.30.11] - 2026-06-08
### Added
- Pantry card now has an inline "Set Min" form to update min_servings without console or DB access.
- `update` action now responds with Turbo Stream instead of full-page redirect.

## [1.30.10] - 2026-06-08
### Fixed
- Stock status now compares derived servings (not raw) against min_servings. Items with servings_per_unit > 1 were incorrectly showing green.

## [1.30.9] - 2026-06-08
### Fixed
- Pantry set form now accepts decimals: `to_i` → `to_f` in `set_servings`, input step set to `0.1`.

## [1.30.8] - 2026-06-08
### Fixed
- `servings_per_unit` now accepts decimals: removed `only_integer` validation, changed column to `decimal(8,2)`, updated form step to `0.1`.
- Food item form "Serving Size" label (was "Units per Serving").

## [1.30.7] - 2026-06-08
### Fixed
- `add_unit!` restored multiplication: adds `unit_servings × servings_per_unit` to `servings_on_hand`. Clicking "+ 1 can" on canned chicken (56 oz/serving, 3.5 srv/can) correctly adds 196 oz.

## [1.30.6] - 2026-06-08
### Fixed
- Removed `only_integer: true` validation on `servings_on_hand` — was blocking decimal values like 3.5 and causing 422 on `add_unit`.

## [1.30.5] - 2026-06-08
### Fixed
- `add_unit!` now adds `unit_servings` directly to `servings_on_hand` (was incorrectly multiplying by `servings_per_unit`). Clicking "+ 1 can" on canned chicken with `unit_servings = 3.5` now adds exactly 3.5 servings.
- `servings_on_hand` changed to decimal to support fractional servings (migration 20260608000003).
- Display formats whole numbers without decimals (7 not 7.0).

## [1.30.4] - 2026-06-08
### Added
- `unit_servings` (decimal) field on `FoodItem` — how many servings are in one purchased unit (e.g. 3.5 servings per can). Allows values like 3.5.
- `+ 1 can` (or bag/pack/etc.) button on pantry card — appears when `unit_servings` is set, adds `unit_servings × servings_per_unit` raw units to `servings_on_hand` in one click.
- `add_unit` action on `PantryItemsController`, Turbo Stream response.
- "Servings per Unit" field added to food item create/edit form with decimal step.

## [1.30.3] - 2026-06-08
### Fixed
- Food item form label corrected from "Servings per Unit" to "Units per Serving" — the field is the divisor (e.g. 7 oz per serving), not a multiplier.

## [1.30.1] - 2026-06-08
### Changed
- Pantry item card simplified to a single Set form — number input pre-filled with current value, submit to update. Removed +/−, Add, and bulk increment entirely.
- Pantry card now shows derived servings (`servings_on_hand / servings_per_unit`) as the primary number. Raw amount shown in parentheses below when a serving size label is set and servings_per_unit > 1. Steak example: "4 srv (28 oz)".

## [1.30.0] - 2026-06-08
### Added
- Serving-based pantry tracking. `FoodItem` gains `servings_per_unit` (how many servings in one purchased unit, e.g. 12 for a dozen eggs) and `serving_size` (display label, e.g. "egg", "oz", "slice"). `PantryItem` gains `servings_on_hand` and `min_servings` — ok/low/out status is now based on servings, not raw unit count.
- Existing quantity data migrated 1:1 to servings (migration 20260608000001). Run `rails db:migrate` to apply.
- Pantry card: **Set** form (enter exact count for inventory-taking) and **Add** form (adds N, defaulting to one unit's worth). +/− adjust by one unit (increment) or one serving (decrement).
- `set_servings` action on `PantryItemsController`, Turbo Stream response.
- `serving_size` and `servings_per_unit` fields on the food item create/edit form.

## [1.29.7] - 2026-06-07
### Added
- Bulk add to pantry: each pantry item card now has a number input + "Add" button that calls `bulk_increment` — type 40 and click Add instead of clicking + 40 times.
- Full food item CRUD (`FoodItemsController`, `/food_items`). Create, edit, and delete food items. New food items automatically get a pantry entry (qty 0, min 1).
- "Food Items" link in pantry action bar. Food items index groups by type with edit/delete per row.

## [1.29.6] - 2026-06-07
### Changed
- Replaced "Garbage" chore type with "Rooms" (🛏️) — deep clean of bedroom and Ryder's room.

## [1.29.5] - 2026-06-07
### Fixed
- Dishes is now a daily chore — it can be added to every day of the week. Weekly dedup logic only applies to the 7 weekly chore types. Added `DAILY_TYPES` and `WEEKLY_TYPES` constants to `ChorePlan` to make this distinction explicit.

## [1.29.4] - 2026-06-07
### Fixed
- Added Dishes back to `ChorePlan` as a manually plannable chore type. Removed the misleading "daily — auto-scheduled" banner that implied automation which didn't exist.

## [1.29.3] - 2026-06-07
### Changed
- Chore planner now shows a weekly legend bar (matching workout planner style) with a ✓/— indicator per chore type. Once a chore type is assigned anywhere in the week it is removed from all remaining day dropdowns, preventing accidental double-assignment.

## [1.29.2] - 2026-06-07
### Added
- Recipe create, edit, and delete. `RecipesController` now has full CRUD. Form uses `accepts_nested_attributes_for` with a grouped ingredient select (food items grouped by type), quantity input per row, remove checkbox for existing ingredients, and a no-JS "Add Ingredient" button that re-renders with a blank row — same pattern as rydersworld meals.
- `slot_type` on `RecipeIngredient` is now auto-set from the food item's `food_type` via `before_validation`.
- "+ New Recipe" button on recipes index. Edit and Delete buttons on recipe show page.

## [1.29.1] - 2026-06-07
- rubocop -a

## [1.29.0] - 2026-06-07
### Added
- `ChorePlan` model: maps a date + chore type to a calendar task. Multiple chore types can be assigned to the same day; unique constraint is on `[planned_on, chore_type]`. Auto-creates a task on save, removes it on destroy.
- Chore types: Dishes, Sweep & Mop, Bathroom, Kitchen, Vacuum, Laundry, Garbage, Organization.
- `ChoresController` with Sunday–Saturday week view and prev/next navigation.
- `ChorePlansController` with `create` and `destroy` actions.
- `/chores` route and "Chores" nav link for signed-in users.
- `_chores.scss` stylesheet.
### Tests
- `test/models/chore_plan_test.rb`: 12 tests covering validations, multi-chore-per-day, task generation, goal association, and destroy.
- `test/controllers/chore_plans_controller_test.rb`: 5 tests covering create and destroy.
- `test/controllers/chores_controller_test.rb`: 6 tests covering index, week navigation, and planned chore visibility.

## [1.28.2] - 2026-06-07
### Fixed
- `WorkoutPlan::GOAL_TITLES` mapped run and body_combat to `"Cardio"` which does not exist as a goal title. Corrected to `"Tacoma City Half Marathon"` (goal 544). Run and body combat tasks were being created with `goal: nil`.

## [1.28.1] - 2026-06-06
### Security
- Updated Puma from 8.0.0 to 8.0.2 to fix CVE-2026-47736 (PROXY Protocol v1 remote memory exhaustion, High) and CVE-2026-47737 (repeated protocol headers on persistent connections, High).

## [1.28.0] - 2026-06-06
### Added
- `WorkoutPlan` model: maps a date to a workout type (run, body_combat, pushups, rest) with a unique constraint per day. Auto-creates a calendar task on save; removes it on destroy; syncs task name on type change.
- `WorkoutsController` with Sunday–Saturday week view, prev/next navigation, and a weekly count summary (2x run / 2x Body Combat / 2x Pushups / 1x Rest targets shown).
- `WorkoutPlansController` with `create`, `update`, `destroy` actions.
- `/workouts` route and "Workouts" nav link for signed-in users.
- `_workouts.scss` stylesheet.
### Fixed
- Deactivated `recurring_tasks` records for Breakfast, Lunch, Dinner, Cardio, and Strength Training goals. Previously only assignment pools were deactivated, which inadvertently re-enabled these recurring tasks since the generator skips them only when the pool is active.
### Tests
- `test/models/workout_plan_test.rb`: 18 tests covering validations, task generation, correct task names per type, goal associations, type-change sync, and destroy.
- `test/controllers/workout_plans_controller_test.rb`: 7 tests covering create, update, and destroy actions.
- `test/controllers/workouts_controller_test.rb`: 7 tests covering index, week navigation, and planned workout visibility.
- Added `workout_plans.yml` fixture; added Tacoma City Half Marathon and Strength Training goal entries to `goals.yml`.

## [1.27.0] - 2026-06-06
### Added
- `MealPlan` model: links a recipe to a specific date and meal slot (breakfast/lunch/dinner) with a unique constraint per date+slot.
- Meal planner auto-creates a calendar task when a meal is planned; task name, date, and goal are derived from the assigned recipe and slot. Task is removed automatically when the meal plan is removed.
- `MealPlansController` with `create`, `update`, and `destroy` actions.
- Sunday–Saturday week view meal planner grid on the kitchen page, with prev/next week navigation via path-based routing (`/kitchen/week/:week_start`).
- Recipe dropdowns in empty planner cells are filtered by meal type (breakfast recipes for breakfast slot, etc.).
### Changed
- Deactivated the assignment pools for Breakfast, Lunch, and Dinner goals; pending tasks from those pools deleted. Meal source is now the MealPlan system exclusively.
### Tests
- `test/models/meal_plan_test.rb`: 16 tests covering validations, task generation on create, task name sync on recipe change, and task removal on destroy.
- `test/controllers/meal_plans_controller_test.rb`: 7 tests covering create, update, and destroy actions.
- `test/controllers/kitchen_controller_test.rb`: 6 tests covering the kitchen index and week navigation.
- Added `recipes.yml`, `meal_plans.yml` fixtures; added Breakfast/Lunch/Dinner goal entries to `goals.yml`.

## [1.26.0] - 2026-05-30
### Added
- Kitchen section (`/kitchen`) for pantry inventory and meal planning.
- `FoodItem` model: catalog of 80 food items with food_type, location, unit, and position.
- `PantryItem` model: tracks current on-hand quantity and reorder threshold per food item.
- `Recipe` model: 33 seed recipes (breakfast, lunch, dinner) with meal type suggestions and servings.
- `RecipeIngredient` model: links recipes to food items with per-ingredient quantities.
- `ShoppingList` and `ShoppingListItem` models: generate and check off shopping lists from low-stock items.
- `KitchenController`, `PantryItemsController`, `RecipesController`, `ShoppingListsController`, `ShoppingListItemsController`.
- Turbo-powered +/− quantity buttons on pantry index; check-off toggles on shopping list.
- "Cook This" action on recipe show page — decrements all ingredient pantry counts in one click.
- Kitchen nav link added for signed-in users.
- `_kitchen.scss` stylesheet.
- Seed data calibrated for 1 active adult male + 1 five-year-old child.

## [1.25.62] - 2026-04-04
### Fixed
- rubocop -a

## [1.25.62] - 2026-04-04
### Changed
- Moved recurring task edits to a dedicated recurring task show page linked from goals.
- Collapsed SMART goal details on task show into a toggle.

## [1.25.61] - 2026-03-30
### Changed
- Updated mcp to 0.10.0 to address CVE-2026-33946.

## [1.25.60] - 2026-03-30
### Changed
- Overhauled the landscaping page hero, highlights, and services layout with the "Touching Grass... Yours." messaging.

## [1.25.59] - 2026-03-27
### Changed
- Updated aws-sdk-s3 to 1.217.0.
- Updated bootstrap constraint to ~> 5.3.0 and bumped bootstrap to 5.3.8.
- Updated turbo-rails to 2.0.23.
- Updated selenium-webdriver to 4.41.0.
- Updated web-console to 4.3.0.
- Updated bootsnap to 1.23.0.

## [1.25.58] - 2026-03-27
### Changed
- Updated Rails to 8.1.3 to address CVE-2026-33658.

## [1.25.57] - 2026-03-27
### Changed
- Added Dependabot configuration.

## [1.25.56] - 2026-03-25
### Added
- Standardized bugs and change requests to the shared schema, including IP capture.
### Changed
- Replaced feedback flows with change requests using the standard fields and statuses.

## [1.25.55] - 2026-03-23
### Fixed
- Wrapped dashboard legends and long task/goal text to stop layout blowouts.

## [1.25.54] - 2026-03-23
### Removed
- Deleted `console.rb` (console data script).

## [1.25.53] - 2026-03-22
### Fixed
- Required the S3 SDK in helpers to prevent missing constant errors in dev/test.
- Fail fast in production when S3 configuration is missing, with a clear error message.
- Allow unconfigured S3 in dev/test by returning nil for presigned URLs/uploads.
- Removed default S3 bucket fallbacks so missing env vars surface immediately.

## [1.25.52] - 2026-03-22
### Fixed
- Prevented mobile form zoom by keeping input font sizes at 16px or larger.

## [1.25.51] - 2026-03-22
### Changed
- Removed trailing whitespace to satisfy RuboCop.

## [1.25.50] - 2026-03-22
### Changed
- Fixed console script syntax so RuboCop can parse it.

## [1.25.49] - 2026-03-22
### Changed
- Updated dependencies to address security advisories and generated RuboCop TODO config.

## [1.25.48] - 2026-03-22
### Added
- Added Brakeman, Bundler Audit, and RuboCop Omakase gems plus CI binstubs/config.

## [1.25.47] - 2026-03-22
### Added
- Added binstubs for Brakeman and RuboCop to support CI checks.

## [1.25.46] - 2026-03-21
### Changed
- Standardized CI checks to include security scans, linting, tests, and system tests.

## [1.25.45] - 2026-03-21
### Changed
- Standardized README sections and added legal controller tests.

## [1.25.44] - 2026-03-21
### Changed
- Standardized changelog dates to YYYY-MM-DD.

## [1.25.43] - 2026-03-21
### Added
- Added the /up health check route.

## [1.25.42] - 2026-03-21
### Changed
- Standardized legal pages on JSON-backed content and added the Accessibility page.

## [1.25.41] - 2026-03-21
### Fixed
- Aligned controller tests with current routes and required goal parameters.

## [1.25.40] - 2026-03-21
### Fixed
- Guarded S3Service initialization when bucket credentials are missing to prevent test-time errors.

## [1.25.39] - 2026-03-21
### Fixed
- Updated Devise route helpers to use keyword arguments and silence Rails 8.2 deprecation warnings.

## [1.25.38] - 2026-03-21
### Added
- Added GitHub Actions CI with Postgres-backed test and system test jobs.
### Fixed
- Filled user and goal fixtures to satisfy database constraints.
- Added document fixture slugs to satisfy document validations.
- Made goal action links fully clickable and eligible for system tests.
- Defaulted reward rule evaluation to satisfied when no rule type is defined.
- Allowed goals to be deleted without orphaned rewards blocking the action.
- Updated system tests to authenticate and align with the current goals/documents UI.
- Signed in a fixture user for integration tests to satisfy auth-protected routes.
- Fixed YAML fixture formatting for users to prevent test load errors.
### Changed
- Use the rack test driver for system tests when running in CI to avoid selenium requirements.
- Run system tests unconditionally in CI to avoid workflow file parsing issues.
- Switched system tests to the rack test driver for reliable runs without selenium.

## [1.25.37] - 2026-03-19
### Changed
- Disabled Active Storage variant processing across environments to avoid image_processing warnings.

## [1.25.36] - 2026-03-19
### Changed
- Refreshed Gemfile.lock via bundle update for Ruby 4.0.2.

## [1.25.35] - 2026-03-19
### Changed
- Pinned Ruby to 4.0.2 across runtime files and Gemfile.lock.

## [1.25.34] - 2026-03-15
### Fixed
- Documents now normalize JSON array/hash fields (subheadings, body, images, youtube_id, metadata) when stored as strings, preventing rendering failures.

## [1.25.33] - 2026-03-14
### Added
- Removing related logging to isolate production related issue that I could not repro in dev for calendar

## [1.25.32] - 2026-03-12
### Added
- Removing related logging to isolate production related issue that I could not repro in dev for calendar

## [1.25.31] - 2026-03-12
### Added
- AWS config for dev
- A calendar update that should fix the calendar's inability to filter by tasks correctly per month.

## [1.25.30] - 2026-03-08
### Added
- Public documentation index at /docs, with slug-based public doc pages.

### Changed
- Documents now honor a metadata public flag to control public visibility.
- Legal terms/privacy pages now allow public access.

## [1.25.29] - 2026-03-08
### Changed
- Forced remember-me on sign-in and made session cookies long-lived + shared across subdomains to reduce mobile logouts.
- Canonicalized host to getawd.com and removed cross-subdomain session cookies.

## [1.25.28] - 2026-03-08
### Changed
- Grayed completed task emojis in the monthly calendar.

## [1.25.27] - 2026-03-07
### Added
- Added a Bugs section mirroring Feedback with open/completed listings and commit references.

## [1.25.26] - 2026-03-06
### Changed
- Aligned services and about copy with the business plan and package positioning.
- Featured client projects to match the case study focus.
- Drafted real case studies for Beard Industries, Beard Bros Dumpsters, and Pickled Pirates Racing.
- Linked initial case study targets in the go-to-market plan.
- Go-to-market plan document for AWDevelopment.
- Case study template and placeholders for future write-ups.

## [1.25.25] - 2026-03-06
### Fixed
- Skip recurring task generation for goals with active assignment pools to prevent duplicate base chores.

## [1.25.24] - 2026-03-05
### Fixed
- Business plan (one page summary) refinement

## [1.25.23] - 2026-03-05

### Fixed
- Business plan refinement

## [1.25.22] - 2026-03-05

### Fixed
- Use `RecurringTaskInstance` delete_all to clear rows before destroying tasks.

## [1.25.21] - 2026-03-05

### Fixed
- Avoid `exec_delete` bind errors when cleaning up recurring task instances on task deletion.

## [1.25.20] - 2026-03-05

### Fixed
- Delete recurring task instances before destroying a task to avoid FK violations.

## [1.25.19] - 2026-03-05

### Removed
- Recurring tasks managed on the related goal show.

## [1.25.18] - 2026-03-05

### Removed
- Recurring task indicated on the show.

## [1.25.17] - 2026-03-05

### Removed
- Goals being recurring. It wasn't the right way to do it.

## [1.25.16] - 2026-03-05

### Added
- Recurring Tasks CRUD (separate from Tasks) with their own table and navigation entry.
- Tasks can be created as recurring via a checkbox that creates a recurring task definition.
- Tasks now link back to the recurring task definition via recurring_task_id.

### Changed
- Recurring task generation now uses recurring task definitions (not goals) and allows multiple tasks per goal per day.
- Removed the recurring checkbox from Goal form; goals are no longer the recurring task manager.
- Daily calendar now includes an "Other Tasks" section for tasks without priority 1-5.

## [1.25.15] - 2026-03-04

### Changed
- Quick complete is useless if it takes u to a random page when u click it.

## [1.25.14] - 2026-03-04

### Changed
- Normalized featured landing card action spacing and applied card-actions styling to blog, project, and video cards.

## [1.25.13] - 2026-03-03

### Added
- Mission and vision statements added to the business plan and one-page summary.
- Mission and vision section added to the About page.

## [1.25.12] - 2026-03-04

### Changed
- Featured videos on the landing page now link to their show pages.

## [1.25.11] - 2026-03-03

### Changed
- featured about small change

## [1.25.10] - 2026-03-03

### Changed
- Standardized logged-in page headings across authenticated pages (calendar, dashboard, tasks, goals, reports, rewards, documents, games, feedback, ideas).
- Daily calendar date now lives inside the shared heading.

## [1.25.9] - 2026-03-03

### Changed
- Daily calendar now includes a quick-complete button for open tasks.
- Monthly calendar now renders emoji-only task entries with wrapped layout to avoid scrolling.

## [1.25.8] - 2026-03-03

### Added
- Business plan expansion, mostly related to costs and billing.

## [1.25.7] - 2026-03-02

### Added
- Business plan.

## [1.25.6] - 2026-03-02

### Changed
- Projects on landing page should go to the more details page, not the actual project. Now they do that.

## [1.25.5] - 2026-03-02

### Changed
- Calendar had redundancies. Now it doesn't thanks to this here commit.

## [1.25.4] - 2026-03-02

### Changed
- Goal-level estimated_daily_task_time added; recurring task generation now uses goal defaults instead of hardcoded case logic.

### Fixed
- Assignment pools now select one weekly chore per day from active items, reset weekly items on Sunday, and avoid same-day duplicates.

## [1.25.3] - 2026-03-02

### Changed
- Split calendar into dedicated daily and monthly pages to isolate navigation and filtering.

### Fixed
- Daily calendar now respects the requested date and shows correct header/prev-next navigation.

## [1.25.2] - 2026-03-01

### Fixed
- Calendar month navigation now follows the requested month while keeping the daily view on today.

## [1.25.1] - 2026-03-01

### Removed
- Maybe if we get rid of the seed files altogether Chat will stop trying to give me random seed files instead of insert / update statements.
- Telling it not to update the seed file is worthless, that's for sure.

## [1.25.0] - 2026-03-01

### Added
- Assignment pools, items, and logs to support auto-assigned recurring work.

### Changed
- Recurring task generator now supports daily and weekly assignment pools.

## [1.24.34] - 2026-02-28

### Changed
- Took all the best parts and pieces of all the front end and made it all standardized across all the public facing pages.
- This commit brought to you by ChatGPT.
  - There aren't any bugs except for all the ones I'll find later.

## [1.24.33] - 2026-02-28

### Changed
- Blog stuff, don't worry ChatGPT I'll go ahead and figure this part out where we put it in the changelog.
- Bonus points for fixing the about view that we decided needed to be blown out.

## [1.24.32] - 2026-02-28

### Changed
- Console cleanup.

## [1.24.31] - 2026-02-28

### Changed
- Final cleanup for projects overhaul.

## [1.24.30] - 2026-02-28

### Changed
- Final cleanup for about overhaul, with css flex implemented where chat produced grid that looked like garbage.

## [1.24.29] - 2026-02-28

### Changed
- Refreshed the About page layout with a centered hero, expectation panel, and highlight cards.
- Added projects section kickers/summaries sourced from `config/project_sections.yml`.
- Added alternating project section backgrounds to separate service groups visually.
- Stimulus fallback image controller + immediate swap on broken images.
- S3Service/S3Proxy changes to ignore blank ENV values.
- s3.yml now treats blank region vars as unset.
- Navbar logo now uses fallback_image_tag.

### Fixed
- Added fallback image handling to swap broken S3/proxy images to `branding/logo.png`.
- Made S3 config region-aware via env defaults and ensured `.env` includes AWS region settings.

## [1.24.28] - 2026-02-28

### Fixed
- Added scroll offset for project section anchors to align with the sticky navbar.
- Finalizing Landing Card material

## [1.24.27] - 2026-02-27

### Changed
- Link to learn more about the service

## [1.24.26] - 2026-02-27

### Changed
- Front eond stoyling brot to ou boy chotGPT

## [1.24.25] - 2026-02-27

### Changed
- Split services index into Featured Services and an "Also Ask About" section.
- Hid the "View Projects" button for non-featured services.

## [1.24.24] - 2026-02-26

### Changed
- Reworked the landing hero copy and CTAs to clearly call out web development and IT consulting services.
- Added Rails-side fallback handling for missing landing hero and logo images in development.

## [1.24.23] - 2026-02-25

### Changed
- Restricted S3 proxy redirects to an allowlist of S3 hosts (plus optional `S3_PROXY_ALLOWED_HOSTS`).

## [1.24.22] - 2026-02-25

### Changed
- Added database check constraints to keep task/goal status values within enum bounds.
- Validated document metadata to ensure it is a hash or valid JSON before save.

## [1.24.21] - 2026-02-25

### Changed
- Added error summary display to the feedback form and clarified the shared form error header.

## [1.24.20] - 2026-02-25

### Changed
- Replaced the `AboutSection` default scope with an explicit `ordered` scope.
- Added basic validations for core content models (games, landscaping jobs, services, projects, videos, blog posts).

## [1.24.19] - 2026-02-25

### Changed
- Normalized indentation in the User model.
- Deleting an Idea now cascades to its Goals via `dependent: :destroy`.

## [1.24.18] - 2026-02-25

### Changed
- Extracted task lookup into a shared before_action for show/edit.

### Removed
- Dropped redundant CSRF protection override in the blackjack controller.

## [1.24.17] - 2026-02-24

### Changed
- Moved reward redemption actions into a dedicated controller while keeping routes intact.

## [1.24.16] - 2026-02-24

### Changed
- Moved document category parsing into `Document#category`.

### Removed
- Dropped the unused `document_params` and controller-only category helper.

## [1.24.15] - 2026-02-24

### Removed
- Dropped the unused `idea_stats` route that had no controller.

### Changed
- Centralized authentication in `ApplicationController` and explicitly skipped it for public controllers.

## [1.24.14] - 2026-02-24

### Added
- Project/blog_post association plus project show page rendering for related blog posts.

## [1.24.13] - 2026-02-24

### Added
- Project/video association plus project show page rendering for related videos.

## [1.24.12] - 2026-02-24

### Changed
- ChatGPT is actually incapable of following anything other than shitty directions.

## [1.24.11] - 2026-02-24

### Changed
- Added layout tokens and shared mixins/placeholders in _theme.scss for containers, breakpoints, images, and primary actions.
- Replaced hard-coded sizes with tokens and deduped panel, action button, and image-frame styles across the SCSS files.
- Converted calendar layout sizing to use theme tokens.

## [1.24.10] - 2026-02-24

### Changed
- Simplified radius/shadow tokens and normalized usages across SCSS partials.

## [1.24.9] - 2026-02-24

### Changed
- Reduced spacing and font tokens to a smaller scale.

## [1.24.8] - 2026-02-24

### Changed
- Refactored shared styling into `_shared.scss` and replaced hardcoded values with theme tokens across SCSS partials.

## [1.24.7] - 2026-02-24

### Fixed
- Playing with the front end, nothing that matters enough for ChatGPT to give me a changelog about

## [1.24.6] - 2026-02-24

### Fixed
- Footer fixed since ChatGPT can't figure out branding and human can't proofread.

## [1.24.5] - 2026-02-24

### Fixed
- Normalized project URLs so missing schemes no longer resolve as relative `getawd.com` paths.

## [1.24.4] - 2026-02-24

### Added
- Featured services section on the landing page.

## [1.24.3] - 2026-02-24

### Changed
- Services titles no longer truncate in the index list.
- Services styles extracted to a dedicated stylesheet.
- Removed Services from the global card title clamp rule to prevent ellipses.

## [1.24.2] - 2026-02-24

### Changed
- Services list now renders card images when provided.

## [1.24.1] - 2026-02-24

### Changed
- Me: Let's just do some really basic filtering on the projects page
- ChatGPT: Hold my beer
- Me: Ok can u fix it tho with this commit? Stay tuned to find out.
- Projects index now groups by service types from the database, with an "Other Projects" fallback for nil or unmapped types.
- Service project anchors now derive from the stored `service_type` without hardcoded mappings.

## [1.24.0] - 2026-02-24

### Added
- Services table to describe available offerings.
- Services index page linked from the main nav.
- Projects `service_type` column for mapping offerings to services.
- Services cards link to Projects anchors by `service_type`.
- Project seed data updated with service mappings.

### Changed
- Projects index grouped by service type with anchors for Services card links.

## [1.23.49] - 2026-02-22

### Added
- Meta description for the home page to improve search previews.

## [1.23.48] - 2026-02-22

### Added
- Terms of Use and Privacy Policy pages.
- LICENSE file.

### Changed
- Footer now links to Terms and Privacy.

## [1.23.47] - 2026-02-22

### Changed
- Dumb clanker can't even get the branding right
- Dumb human can't even proofread

## [1.23.46] - 2026-02-21

### Changed
- Projects index now links to internal project detail pages, with external links moved to show.
- Split projects index into featured and more sections.
- Videos index now links to detail pages with thumbnails instead of embedded players.
- Video show page now includes a dedicated embed layout and navigation back to the index.

## [1.23.45] - 2026-02-20

### Changed
- Documents section is organized unlike ur desk lol

## [1.23.44] - 2026-02-20

### Changed
- Mirrored Ryder's World image proxy with signed resize URLs and S3 presign fallback.
- Routed all UI images through the proxy with WebP sizing and updated media/system docs.
- Added an image proxy setup doc with CloudFormation + secret + env var checklist.

## [1.23.43] - 2026-02-15

### Changed
- Forced Devise remember-me on sign-in; set a 2-year remember window with sliding renewal
- Added basic PWA metadata and a web manifest to support iOS "Add to Home Screen"

## [1.23.42] - 2026-02-07

### Changed
- Normalized reward redemption params and surfaced invalid reward/game selections.

## [1.23.41] - 2026-02-07

### Fixed
- Guarded date normalization when parsing fails to avoid nil to_date errors.

## [1.23.40] - 2026-02-07

### Changed
- Surface invalid filter params for goals/tasks instead of silently skipping them.

## [1.23.39] - 2026-02-07

### Changed
- Normalized query params for goals/tasks filters and sorting to keep inputs predictable.

## [1.23.38] - 2026-02-07

### Changed
- Defaulted all controllers to require authentication, with an explicit public allowlist.

## [1.23.37] - 2026-02-06

### Changed
- Aligned DB constraints with model expectations (non-null requirements, case-insensitive goal uniqueness).
- Backfilled missing task/document fields before enforcing constraints.
- Enforced unique reward-task joins and added matching model validations.

## [1.23.36] - 2026-02-06

### Changed
- setting ruby-version file because pinning it to 4.0.1 isn't enough or whatever

## [1.23.35] - 2026-02-06

### Changed
- Shitposting in the 403 message for the love of the game.

## [1.23.34] - 2026-02-06

### Changed
- Locked production host allowlist to `APP_HOST`/`APP_HOSTS` (defaults to getawd.com, www.getawd.com)
- Set explicit session cookie key and SameSite/secure settings

## [1.23.33] - 2026-02-06

### Changed
- Standardized priority levels to 1–5 across the app.
- Calendar daily view now shows Levels 1–5.
- Rewards level panel now includes Levels 1–5.
- Daily reward earning now runs for Levels 1–5 only.
- Redeem flow rejects invalid reward levels.

### Fixed
- Prevented goals/tasks from accepting priority values outside 1–5.

## [1.23.32] - 2026-02-06

### Changed
- Removed pagination from docs section because ChatGPT can do the thing where they tell you they implement pagination but what actually happens is they paginate most of the shit and hope you won't notice the 2 or 3 missing articles that aren't called because you let a robot do a man's job.

## [1.23.31] - 2026-02-06

### Changed
- Grouped documents index by `metadata["category"]`, with uncategorized fallback.

## [1.23.30] - 2026-02-06

### Changed
- Document helper now maps `logo-classic.png` to `branding/logo-classic.png` for docs placeholders.

## [1.23.29] - 2026-02-06

### Changed
- Standardized landing and index card truncation rules for titles and descriptions.
- Unified list card imagery into square, centered 500px frames across featured and index views.
- Aligned document card markup with the standardized card typography.

## [1.23.28] - 2026-02-04

### Added
- Auth page styling and custom Devise views for sign in, sign up, and password reset flows.

## [1.23.27] - 2026-02-04

### Changed
- Landscaping job images now render inside a square, overflow-hidden frame.
- Blackjack visuals updated to classic green felt styling with card-like elements.

## [1.23.26] - 2026-02-04

### Changed
- Standardized landscaping/blackjack styling with shared theme variables and square image sizing.

## [1.23.25] - 2026-02-04

### Fixed
- Restored `landscaping_image_url` helper for landscaping image rendering.
- Linked landscaping page to contact page instead of inline contact details.

## [1.23.24] - 2026-02-04

### Changed
- Split blackjack and landscaping views into focused partials.

## [1.23.23] - 2026-02-04

### Changed
- Split feedbacks, navbar, and reward history/level sections into focused partials.

## [1.23.22] - 2026-02-04

### Changed
- Split documents show, games index, blog posts show, and goals show into focused partials.

## [1.23.21] - 2026-02-04

### Changed
- Split ideas show, projects index, and blog posts index into focused partials.
- Shared pagination partial for blog posts and projects.

## [1.23.20] - 2026-02-04

### Changed
- Prevented duplicate level rewards from re-earning after redemption on the same day.

## [1.23.19] - 2026-02-04

### Changed
- Split reports, contact, and task show views into focused partials.

## [1.23.18] - 2026-02-04

### Changed
- Split rewards show view into focused partials.
- Split game show view into focused partials.
- Split home featured sections into focused partials.

## [1.23.17] - 2026-02-04

### Changed
- Split task and goal forms into focused partials and shared error rendering.

## [1.23.16] - 2026-02-04

### Changed
- Split calendar views into focused partials and centralized time status display.

## [1.23.15] - 2026-02-04

### Changed
- Split dashboard index into focused partials.

## [1.23.14] - 2026-02-04

### Changed
- Split rewards index into focused partials and removed view-level queries.

## [1.23.13] - 2026-02-04

### Changed
- Removed stray controller-style `index` method from `LandscapingJob`.
- Extracted hold/resume timing logic into `Holdable::NormalizeHoldUntil` and `Holdable::ResumeIfReady`.

## [1.23.12] - 2026-02-04

### Changed
- Extracted reward eligibility checks into `Rewards::Eligibility`.

## [1.23.11] - 2026-02-04

### Changed
- Moved task completion reward logic into `Tasks::HandleCompletion`.

## [1.23.10] - 2026-02-04

### Changed
- Extracted calendar loading into `Calendar::ShowData`.
- Extracted games pagination into `Games::IndexData`.
- Extracted idea show loading into `Ideas::ShowData`.
- Extracted landscaping index loading into `Landscaping::IndexData`.
- Extracted S3 proxy resolution into `S3Proxy::ShowData`.
- Extracted videos pagination into `Videos::IndexData`.

## [1.23.9] - 2026-02-04

### Changed
- Extracted about page loading into `About::IndexData`.
- Extracted contact page loading into `Contact::IndexData`.
- Extracted contact message delivery into `Contact::SendMessage`.
- Extracted home page featured content into `Home::IndexData`.
- Extracted blog posts pagination into `BlogPosts::IndexData`.
- Extracted projects pagination into `Projects::IndexData`.
- Extracted feedback listing/creation/update into `Feedbacks::IndexData`, `Feedbacks::CreateFeedback`, and `Feedbacks::UpdateFeedback`.

## [1.23.8] - 2026-02-04

### Changed
- Extracted document index pagination into `Documents::IndexData`.
- Extracted document deletion into `Documents::DestroyDocument`.

## [1.23.7] - 2026-02-04

### Changed
- Extracted blackjack game logic into `Blackjack::Game`.

## [1.23.6] - 2026-02-04

### Changed
- Extracted dashboard aggregation into `Dashboard::IndexData`.
- Extracted reports aggregation into `Reports::IndexData`.

## [1.23.5] - 2026-02-04

### Changed
- Extracted goal index filtering/sorting into `Goals::IndexData`.
- Extracted goal creation into `Goals::CreateGoal`.
- Extracted goal updates into `Goals::UpdateGoal`.
- Extracted goal deletion into `Goals::DestroyGoal`.

## [1.23.4] - 2026-02-04

### Changed
- Made reward redemption require an explicit level (or reward_id) to avoid silent fallback to Level 1.
- Extracted task creation/repeat logic into `Tasks::CreateTask`.
- Extracted task update and complete-on-time flows into `Tasks::UpdateTask` and `Tasks::CompleteOnTime`.
- Extracted task index filtering/sorting into `Tasks::IndexData`.
- Extracted task deletion into `Tasks::DestroyTask` for consistent controller flow.

## [1.23.3] - 2026-02-03

### Changed
- Extracted reward level redemption logic into `Rewards::RedeemLevel`.
- Extracted `redeem_any` logic into `Rewards::RedeemAny`.
- Extracted `redeem_task` logic into `Rewards::RedeemTask`.
- Extracted rewards index aggregation into `Rewards::IndexData`.

## [1.23.2] - 2026-02-03

### Changed
- Removed inline view styles/scripts and aligned CSP for Turbo/importmap to keep console clean.

## [1.23.1] - 2026-02-01

### Changed
- Slight logo adjustment. New year new me or whatever.

## [1.23.0] - 2026-02-01

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

## [1.22.18] - 2026-01-31

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

## [1.22.17] - 2026-01-31

### Added
- Report card addition

## [1.22.16] - 2026-01-31

### Added
- Completion chain expansion to include more context and an emoji based on success or failure

## [1.22.15] - 2026-01-31

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

## [1.22.14] - 2026-01-26

### Changed
- Well would you look at that, ChatGPT can't even stick to formatting the changelog correctly and it took me 5+ commits to realize it.

## [1.22.13] - 2026-01-26

### Changed
- Cached S3 presigned URLs with a TTL shorter than their actual expiration
- Switched per-request/thread caching to Rails cache to avoid serving expired URLs

## [1.22.12] - 2026-01-25

### Added
- Routed image requests through a stable /media proxy to avoid expired S3 presigned URLs
- Added S3 proxy controller + route to mint fresh presigned URLs per request

## [1.22.11] - 2026-01-25

### Fixed
- Guarded dashboard constants to avoid crashes if icon/idea maps are missing
- Hardened calendar rendering against missing GOAL_ICONS and nil task dates/times
- Hardened contact/about YAML loading and guarded missing social/about data
- Guarded home featured links, blog images, and video embeds when data is missing

## [1.22.10] - 2026-01-25

### Added
- Added pagination and ordering for projects index, and guarded empty project URLs
- Added pagination for videos index and fixed videos show to use the requested video

## [1.22.9] - 2026-01-25

### Changed
- Hardened document rendering against nil/mismatched JSON arrays
- Required document title and slug
- Guarded document index thumbnails against missing image data
- Hardened document show against malformed images/youtube_id/metadata
- Added pagination and ordering for blog posts index
- Slug migration for blog_posts

## [1.22.8] - 2026-01-25

### Added
- Expanded seed data for tasks, games, documents, and rewards

## [1.22.7] - 2026-01-25

### Fixed
- Fixed task list filters, N+1 goals, and repeat-until validation
- Applied goal filters to rendered lists and eager loaded ideas
- Removed unused Reward#redeem! and hardened game progress_data parsing

## [1.22.6] - 2026-01-25

### Added
- Made completion footage URL requirement apply only to level (gaming) rewards
- Added level 3 auto-funding payload on redemption
- Display reward update errors on the reward show page

## [1.22.5] - 2026-01-25

### Changed
- Eager loaded goals on dashboard/calendar task lists to reduce N+1 queries
- Guarded calendar view against tasks without goals
- Reduced reward availability counting N+1 queries on dashboard

## [1.22.4] - 2026-01-25

### Changed
- Removed S3 presign debug logging and tightened production asset/ActiveStorage settings
- Removed Rails 8.1 new framework defaults initializer after adopting defaults
- Added pagination for documents, games, and rewards indexes
- Enforced safe handling of path-relative redirects
- Optimized reward completion helpers to avoid N+1 scans
- Cached S3 presigned URLs per request
- Added report-only Content Security Policy
- Updated Devise routes to avoid upcoming keyword deprecation warnings

## [1.22.3] - 2026-01-25

### Changed
- Prepared database.yml for primary/cable/queue/cache connections and bumped Rails to 8.1.x
- Updated Gemfile and Gemfile.lock for Rails 8.1.2
- Restored app-specific Rails config after app:update (timezone, dev cache toggles, prod mailer/SSL/logging)
- Updated enum declarations to Rails 8-compatible syntax
- Removed Ruby version pin from Gemfile
- Pinned Ruby to 4.0.1

## [1.22.2] - 2026-01-25

### Changed
- Removed duplicated `handle_completion` and `earned_on_date` definitions in `Task`
- Removed redundant plural `about` and `contacts` resource routes
- Removed unused `rewards` routes for `new`, `create`, and `destroy`
- Enforced unique slugs on documents
- Hardened reward redemption validation for level rewards and invalid game selections
- Aligned reward helper calculations with level-only earned rewards and on-hold task exclusions

## [1.22.1] - 2026-01-24

### Changed
- games show was borked because I don't use rspec or whatever

## [1.22.0] - 2026-01-19

### Added
- Blackjack lol

## [1.21.32] - 2026-01-19

### Changed
- Serving images for the remaining app sections without ability to expand

## [1.21.31] - 2026-01-19

### Changed
- Updated Documents index page to load images via `S3Helper` instead of public S3 URLs
- Updated document partial to use presigned URLs for private images
- Standardized document image access to `documents/{document_id}/{filename}`
- Removed remaining hardcoded S3 URLs from Documents views
- Aligned Documents image loading behavior with Games S3 implementation

## [1.21.30] - 2026-01-18

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

## [1.19.1] - 2025-11-19 –

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

## [1.19.0] - 2025-11-17 –

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

## [1.18.11] - 2025-11-15

### Changed
- About section
  - about `index.html.erb` added another about tile and a header
  - updated some info in `about_info.yml` to display on that page

## [1.18.10] - 2025-11-15

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


## [1.18.9] - 2025-10-26

### Changed
- Contact Info (contact_info.yml) for Twitch

## [1.18.8] - 2025-10-26

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

## [1.18.3] - 2025-09-27 –

### Changed
- Completing a goal toady should actually make it complete today, even if we're not in UTC. :|

## [1.18.2] - 2025-09-27 –

### Changed
- Added dashboard nav in ideas section of dashboard to quickly add a goal or task.

## [1.18.1] - 2025-09-27 –

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

## [1.18.0] - 2025-09-17 –

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

## [1.17.1] - 2025-09-11

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

## [1.15.1] - 2025-08-01
### Setting bucket to public altogether, will only be used for public facing images.

## [1.15.0] - 2025-08-01
### Added
- **`config/s3.yml`**
  - Environment-specific bucket, region, and access key config for AWS S3
- **`app/services/s3_service.rb`**
  - Service class to upload and access files from S3, supports public/private files
- **`Gemfile`**
  - Added `aws-sdk-s3` for S3 integration

## [1.14.5] - 2025-07-30
### Changed
- **`rewards/index.html.erb`**
  - Added link to create a new reward.
  - Enhanced layout and presentation with new styles.

- **`_rewards.scss`**
  - Added styling for the new link and general layout improvements.

## [1.14.4] - 2025-07-30
### Changed
- **`rewards_controller.rb`**
  - Only shows tasks that are incomplete when associating a new reward

## [1.14.3] - 2025-07-30
### Thanks Rails for throwing a credential pity party

## [1.14.2] - 2025-07-30
### RePrecompile my balls
- https://stackoverflow.com/questions/19650621/heroku-upload-precompiling-assets-failed
- Removing this line, not necessary and the issue was actually related to SCSS, where I was calling variables that didn't exist.

## [1.14.1] - 2025-07-29
### Precompile my balls
- https://stackoverflow.com/questions/19650621/heroku-upload-precompiling-assets-failed

## [1.14.0] - 2025-07-29
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

## [1.13.12] - 2025-07-012 -
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


## [1.13.11] - 2025-07-11
### Time Zone Fixes & Contact/About Updates

### Changed
- **`calendar_controller.rb`**, **`dashboard_controller.rb`**
  - Replaced `Date.today` with `Time.zone.today` to fix time zone bug causing tasks to appear a day early (due to UTC vs. Pacific mismatch).

- **`contact_info.yml`**, **`contact/index.html.erb`**
  - Added YouTube info to contact section.

### Added
- **About Section**
  - Added two new images of me.

## [1.13.10] - 2025-07-07
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

## [1.13.9] - 2025-07-07
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

## [1.13.8] - 2025-07-07
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

## [1.13.7] - 2025-07-06
### Seed File Fixes & Repeatable Tasks

### Changed
- **`seeds/goals.rb`**
  - Updated to reflect the correct `status` values after enum changes in [1.12.30].
- **`repeatable_tasks.rb`**, **`.gitignore`**
  - Added repeatable task commands for convenience; file ignored from version control.

## [1.13.6] - 2025-07-01
### Bug Fixes & Clarity Improvements

### Changed
- **`tasks/show.html.erb`**
  - Fixed mislabeled button that incorrectly said "Delete goal" instead of "Delete task".
- **`calendar/show.html.erb`**
  - Daily calendar now displays the task name for better clarity.

## [1.13.5] - 2025-06-17
### Gaming Version Control Implementation, Necessary to Improve Goal Tracking, Checkpoints, Calculation of Related Metrics, and Ultimately an Increase of Productivity Across the Entirety of the Gaming Platform this Section Supports. The Numbers Mason.

### Changed
- **Database**:
  - Developed insert statement to add information to DB for first series
- **`games/index.html.erb`**:
  - Removed game_notes from games/index
- **`stylesheets/application.html.erb`**, **`games/show.html.erb`**:
- Updating to apply style to each individual game section on the show (was referencing game class, needed to reference game id)

## [1.13.4] - 2025-06-17
### Navigation Clean-Up

### Added
- **`dashboard/index.html.erb`**
  - Added links to create new tasks and goals directly from the dashboard.

### Changed
- **`goals/show.html.erb`**, **`tasks/show.html.erb`**
  - Reorganized sub-navigation layout to reduce clutter and improve usability.
  - Moved delete buttons to avoid accidental clicks.
  - Converted sub-nav to unordered list with inline styles (temporary solution; further styling needed and there's nothing more permanent than a temporary solution :D).


## [1.13.3] - 2025-06-10
### Form Styling Updates

### Changed
- **`goal_icons.yml`**
  - Added additional emojis for goal categories.
- **`goals/_form.html.erb`**, **`tasks/_form.html.erb`**, **`_form.scss`**
  - Updated the description field to use a larger `<textarea>` for better usability.

## [1.13.2] - 2025-06-10
### Form Styling Updates

### Changed
- **`tasks/_form.html.erb`**, **`goals/_form.html.erb`**, **`_form.scss`**
  - Applied unified styling inspired by the "Not Started" card layout for input sections.
- **`tasks/new.html.erb`**, **`tasks/edit.html.erb`**, **`goals/new.html.erb`**, **`goals/edit.html.erb`**
  - Centered `<h1>` headers for improved visual hierarchy.

## [1.13.1] - 2025-06-09 -  (Nice)
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

## [1.13.0] - 2025-06-07
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

## [1.12.30] - 2025-06-07
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


## [1.12.29] - 2025-06-06
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

## [1.12.28] - 2025-05-11
### Landscaping Expansion

### Changed
- **`landscaping/index.html.erb`**
  - Added more clarity around target market and job types
- **`_landscaping.scss`**
  - Styled the list of services and contact information

## [1.12.27] - 2025-05-10
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

## [1.12.26] - 2025-05-10
### Readme updates

## [1.12.26] - 2025-05-10
### Readme updates

## [1.12.25] - 2025-05-10
### Dashboard Upgrades

### Added
- **`dashboard_controller.rb`**:
  - Added authentication with `before_action :authenticate_user!`.
- **`dashboard/index.html.erb`**:
  - Linked each task’s goal for quick reference.
- **`layouts/_nav.html.erb`**:
  - Added Dashboard link visible only when `user_signed_in?`.

## [1.12.24] - 2025-05-07
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

## [1.12.23] - 2025-05-06
### Hey have a README

### Changed
- **`README.MD`**:
  - Put stuff in it, just read it if you've made it this far.


## [1.12.22] - 2025-04-06
### Goal Section Cleanup

### Changed
- **`goals_controller.rb`**:
  - Updated logic to exclude completed goals by default.
- **`goals/index.html.erb`**:
  - Added checkbox toggle to show/hide completed goals.

### Notes
- Helps focus on active goals while retaining access to completed ones when needed.

## [1.12.21] - 2025-03-14
### Task Name Tooltip

### Changed
- **`calendar/show.html.erb`**:
  - Added tooltip to display `task_name` when hovering over tasks on the calendar.

## [1.12.20] - 2025-02-24
### Completed tasks now show as such

### Changed
- **`calendar/show.html.erb`**:
  - Completed tasks now display a checkmark instead of time remaining and a progress bar.

## [1.12.19] - 2025-02-24
### General Debugging & Clean-Up

### Changed
- **`_calendar.scss`**:
  - Removed redundant status dot styling.
- **`layouts/application.html.erb`**:
  - Integrated Google Font.
- **`calendar/show.html.erb`**:
  - Applied Google Font.
  - General layout and style improvements.

## [1.12.18] - 2025-02-24
### General Debugging & Clean-Up

### Changed
- project4.png

## [1.12.17] - 2025-02-24
### General Debugging & Clean-Up

### Changed
- **`tasks/index.html.erb`**, **`goals/index.html.erb`**:
  - Adjusted emoji placement for better alignment.
- **`calendar/show.html.erb`**:
  - Updated labeling for improved clarity.
  - Status dot now displays an actual pie chart.
- **`_calendar.scss`**:
  - Ensured colors display correctly.

## [1.12.16] - 2025-02-22
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

## [1.12.15] - 2025-02-22
### General Debugging & Clean-Up

### Changed
- **`_calendar.scss`**:
  - **Removed the scrollbar** from the calendar—because it looked bad.
  - Requested **ChatGPT** for a **5% style upgrade**… verdict is still out. Might fire for another AI. (I made chatGPT format this changelog appropriately, I sure hope the robots never take over :D)

### Notes
- Improves **visual appeal** of the calendar by removing unnecessary UI clutter.
- Style tweaks are **under evaluation** decisions pending future AI performance reviews.

## [1.12.14] - 2025-02-22
### General Debugging & Clean-Up

### Changed
- **`calendar_controller.rb`**:
  - **All tasks** now **display by default** on the calendar again.
  - Refined **progress wheel logic** to handle anything thrown at it.

### Notes
- Ensures **complete task visibility** on the calendar.
- Progress wheel is now **more resilient** to unexpected data inputs.

## [1.12.13] - 2025-02-22
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


## [1.12.12] - 2025-02-22
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

## [1.12.11] - 2025-02-22
### Search Implementation for Goals

### Changed
- **`goals/index.html.erb`**, **`goals_controller.rb`**, **`tasks/index.html.erb`**:
  - Added **search functionality** for goals, similar to tasks but **without filtering**.

### Notes
- Enables **basic goal searching** for easier navigation.
- Matches existing **task search behavior**, maintaining UI consistency.

## [1.12.10] - 2025-02-22
### SCSS Consistency & Pagination Update

### Changed
- **`files.scss`**:
  - Standardized **SCSS variables** for consistency, specifically related to **hover colors**.
- **`tasks_controller.rb`**:
  - Temporarily increased **pagination limit** to **100 tasks per page** until further refinement.

### Notes
- Ensures **consistent styling** across the app by properly setting SCSS variables.
- Adjusts **pagination for better usability** while future optimizations are considered.

## [1.12.9] - 2025-02-22
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

## [1.12.8] - 2025-02-22
### Task Icons

### Changed
- **`tasks/_form.html.erb`**:
  - Updated to select from **existing goals** instead of using a static YAML list, ensuring correct associations.
- **`seeds/tasks.rb`**:
  - Added **more sample tasks** for development.

### Notes
- Improves data integrity by properly linking tasks to **actual goals**.
- Enhances development environment with additional **seed data**.

## [1.12.7] - 2025-02-21
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

## [1.12.6] - 2025-02-21
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

## [1.12.5] - 2025-02-20
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

## [1.12.4] - 2025-02-20
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

## [1.12.3] - 2025-02-20
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

## [1.12.2] - 2025-02-19
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


## [1.12.1] - 2025-02-19
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


## [1.12.0] - 2025-02-18
## Front end changes for greater consistency

### Changes
- Various changes to scss and html.erb files for a more organized front end.

## [1.11.6] - 2025-02-17
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


## [1.11.5] - 2025-02-17
### Footer Implementation

### Added
- **`layouts/_footer.html.erb`**: New footer partial for consistent site-wide use.

### Changed
- **`layouts/application.html.erb`**: Integrated the new footer into the layout.
- **`blog_posts/show.html.erb`**: Fixed a missing closing `<div>` to ensure proper structure.

### Notes
- The new footer improves site consistency and navigation.
- Fixed structural issue in blog posts to prevent layout breaks.

## [1.11.4] - 2025-02-17
### Blog Cleanup

### Changed
- **`home/index.html.erb`**: Updated the **About** subheading name for clarity.
- **`application.scss`**: Added styling improvements for blog post formatting.
- **`blog_posts/show.html.erb`**: Removed unnecessary elements for a cleaner layout.

### Notes
- Improves readability and structure of the blog section.
- Simplifies blog post presentation by removing unnecessary bloat.

## [1.11.3] - 2025-02-16
### Homepage Updates

### Changed
- **`index.html.erb`**: Moved **About** and **Contact** sections to the top for better visibility.
- **`application_controller.rb`**: Updated homepage content display logic.
- **`application.scss`**: Added styling for `<h3>` elements.

### Notes
- Improves homepage organization for a better user experience.
- Enhanced styling consistency for section headers.

## [1.11.2] - 2025-02-11
### Status Indicators and App Name Fix

### Changed
- **`_calendar.scss`**: Added `.status-dot` class for task status indicators.
- **`calendar/show.html.erb`**: Implemented status dots in both calendar views.
- **`layouts/application.html.erb`**: Fixed app name display from **"AwD"** to **"AWD"**.

### Notes
- Status indicators improve task visibility in the calendar.
- Minor UI correction for consistent branding.

## [1.11.1] - 2025-02-08
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

## [1.11.0] - 2025-02-08
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

## [1.10.14] - 2025-02-07
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

## [1.10.13] - 2024-12-29
### Bug Fix (validate start_date presence)

### Changed
- models/task.rb
    - ensure due_date is provided before allowing a task to be created (it needs that to display on the calendar)

## [1.10.12] - 2024-12-02
### Updating how the buttons display

### Changed
- home/index.html.erb, projects, blog_posts, application.scss
    - Button was landing on same line as image in some resolutions, causing display issues.

## [1.10.11] - 2024-12-02
### Adding new blog post image

### Added
- blog7.png

## [1.10.10] - 2024-12-02
### Contact info fixes

### Changed
- index.heml.erb, application.scss, contact_info.yml
    - Related to what content displays, and where.

## [1.10.9] - 2024-11-23
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


## [1.9.9] - 2024-11-12
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

## [1.9.8] - 2024-11-12
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


## [1.9.7] - 2024-11-11
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

## [1.9.6] - 2024-10-27
### Refining Task Manager | Front end fixes

### Changed
-tasks/index.html.erb
    - Removed chatGPT generated front end styling directly on the html.erb file :facepalm:
    - Moved search box and filtering to it's own section altogether

## [1.9.5] - 2024-10-27
### Refining Task Manager | Hidden Tasks | Checkboxes for filtering

### Changed
- tasks_controller.rb
    - Added logic to show all tasks, on_hold, completed hidden by default
    - The %w[...] syntax is shorthand in Ruby to create an array of strings, so %w[completed on_hold] is the same as writing ['completed', 'on_hold'].
-tasks/index.html.erb
    - Added checkbox to show all tasks, on hold, completed

## [1.9.4] - 2024-10-22
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

## [1.9.3] - 2024-10-22
### Cleanup

### Fixed
- tasks_controller.rb, task.rb, _form.html.erb
    - Updated logic to ensure tasks display
    - Make it such that status displays through the use of mapping.


## [1.9.2] - 2024-10-22
### New Featured Project

### Added
- blog6.png
    - To correspond with the update statement made to blog.

### Changed
- images/project5.png
    - Updated for the actual project moxicloud-ui
- COMMANDS.md
    - Tracking specific update statements made


## [1.9.1] - 2024-10-21
### Launch Time

### Changed
- README.md
    - TMPFI
- .gitignore
    - Guess where all that README info went. It's still public info thanks to this repository :D

## [1.9.0] - 2024-10-21
### Sweeping the floor

### Changed
- This file.
    - It looks better when you're looking at it from a 'user' perspective.
- tasks/index.html.erb
    - Insert redneck - **Thems be some fancy new 'new / create' routes boihhhhh, it'd be a shame if the user couldn't.. use 'em**

## [1.8.9] - 2024-10-21
### Removing, and then re-adding task_params because chat GPT

### Changed
- Put back task_params method

## [1.8.8] - 2024-10-21
### Basically chatGPT told me to remove task_params

### Changed
- Removed task params so that stuff would display on the front end
- As it turns out, those params had nothing to do with it, and chatGPT and I did not quite see eye to eye. We both understand the importance of strict params, especially when it comes to user input. This rubber ducky sucks sometimes.

## [1.8.7] - 2024-10-21
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

## [1.8.6] - 2024-10-20
### Devise Gem | Tasks cannot be accessed at all unless signed in

### Changed
- tasks_controller.rb
    - before_action :authenticate_user!
    - Does not allow access to any action within this controller
- application.scss
    - blog-post didn't have image sizing set appropriately

## [1.8.5] - 2024-10-20
### Devise Gem | Tasks hidden unless signed in

### Changed
- _navbar.html.erb
    - <% if user_signed_in? %> for tasks

## [1.8.4] - 2024-10-20
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

## [1.7.4] - 2024-10-20
### Refactoring application.scss

### Changed
- application.scss
    - Those can be the same (blog_posts, projects)
    - Updated to make stuff centered in the cards
    - Make videos more taller too

## [1.7.3] - 2024-10-20
### Standard 1:1 image sizing for most content

### Changed
- README.md
    - Standard image sizing

## [1.7.2] - 2024-10-19
### Front end implementation including new images, API font

### Changed
- README.md
    - Call it what it is

## [1.7.1] - 2024-10-19
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

## [1.6.1] - 2024-10-19
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


## [1.6.0] - 2024-10-19
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

## [1.5.0] - 2024-10-19
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

## [1.4.0] - 2024-10-19
### Other 'featured' migrations

### Added
- Corresponding schema and migration files related migrations run

### Changed
- home_controller.rb
    - Featured logic was actually here for the home page related to featured projects and videos. Updated that.
- seeds.rb
    - Updated to add 'featured' data

## [1.3.0] - 2024-10-19
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

## [1.2.0] - 2024-10-18
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

## [1.1.0] - 2024-10-18
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

## [1.0.0] - 2024-10-17

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

## [Unreleased] - 2024-10-17
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

## [Unreleased] - 2024-10-17
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

## [Unreleased] - 2024-10-16
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

## [Unreleased] - 2024-10-16
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

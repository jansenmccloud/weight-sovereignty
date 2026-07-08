<thinking>
I've now read all the relevant files. Let me analyze the TODOs from manual testing:

1. **"the deselect food actually doesn't remove the food from dailylog or delete the foodlog entry"** - The `onDelete` callback in `AddFoodScreen` only sets `_amountOverrides[food.id] = 0.0` locally, it doesn't actually delete the food entry or remove it from dailyLog.

2. **"the add_food_screen should not contain the state of the daily log => already assigned food"** - Currently `_dailyLog` is loaded in `_loadData()` and used in `_handleSave()`. The screen should only be for adding food, not managing DailyLog state.

3. **"the food screen should only be there to add food on save"** - Currently it loads DailyLog and links to it. Should just let user pick foods and create Food entries on save.

4. **"removing the food from daily log, should be able in dashboard_screen where the food i also listed"** - Remove delete from add_food_screen; add delete capability to dashboard.

5. **"on food save => daily log is broken => weight and bmr and profile get deleted"** - In `_handleSave()` line 296-299, a new `DailyLog()` is created without preserving `bodyWeight` and `dailyLogBase`, causing data loss.

6. **"recalculation should be done outside of food add screen"** - The service's `recalculateAndSave()` creates a new DailyLog from scratch via `upsertByCalendarDay`. This is fine as long as bodyWeight/dailyLogBase are preserved.

7. **"maybe we just want a crud food screen for selected date screen"** - Good idea: AddFoodScreen becomes purely CRUD for Food (create from config), delete goes to dashboard.

8. **"food screen should be as stupid as possible and should not have any writing concerns about the dailylog entries"** - Decouple completely.

9. **"is the date already enough to decouple daily log from food entry? => maybe the food ids are not needed on dailylog side"** - YES! Food has `date` field. We can query food by date and recalculate from all foods on that date. The `foodIds` link is unnecessary complexity.

10. **"we could simply ask for the food by date whenever we want to recalculate"** - YES. The service can query `FoodRepository.listByCalendarDay()` and aggregate macros directly. No `foodIds` needed.

11. **"to reduce complexity we can hard-code the unit of the food entries to 'g' for grams"** - Remove `unit` from `FoodBase` and `FoodConfig`.

12. **"the dashboard screen isn't refreshed when navigating back to it"** - Dashboard needs proper state management (e.g., re-fetch DailyLog on date change, or provider invalidation).
</thinking>

I've read all the relevant files and now have a complete picture. Here's my plan:

## Plan: Fix Food/DailyLog Architecture Issues

### Root Cause Analysis
- `DailyLog` currently has `foodIds` / `workoutIds` linking to food entries
- `AddFoodScreen` loads DailyLog state, which causes data loss on save (bodyWeight/BMR wiped)
- Deselect only sets local override to 0, doesn't actually delete or unlink
- Dashboard doesn't refresh after navigation

### Step-by-Step Plan

**Step 1: Remove foodIds/workoutIds from DailyLog entity**
- Delete `foodIds` and `workoutIds` fields from `DailyLog` / `DailyLogBase`
- Food already has a `date` field — we can query by date for recalculation
- Run build_runner to regenerate Isar models

**Step 2: Rewrite recalculation in DailyLogService**
- Change `recalculateDailyLog(foodIds, workoutIds)` → `recalculateFromDate(DateTime day)` 
- Query all foods for the date via `_foodRepo.listByCalendarDay(day)` and aggregate macros
- Same for workouts via `_workoutRepo.listByCalendarDay(day)`

**Step 3: Decouple AddFoodScreen completely**
- Remove `_dailyLog` state and loading
- Remove linking to DailyLog entirely
- On save: create `Food` entries from selected configs + target date only
- Return just the new `Food` entries (or nothing) — no DailyLog

**Step 4: Rewrite Dashboard food section**
- Add delete button on each food entry in dashboard (calls `foodRepo.deleteById()`)
- Use `AsyncListScaffold` to show foods for selected date (query via repo)
- Calculate totals from displayed food list (no DailyLog dependency for display)

**Step 5: Fix dashboard refresh + recalculation trigger**
- After adding food, navigate back and trigger dashboard refresh via provider invalidation
- Recalculate totals in `DailyLogService.recalculateAndSave()` — now it only needs to update the `calculation` field on existing DailyLog

**Step 6: Simplify Food entity**
- Remove `unit` from `FoodBase` (hard-code to 'g')
- Remove `unit` from `FoodConfig`
- Run build_runner again
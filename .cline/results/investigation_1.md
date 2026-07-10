# plan 2

You're absolutely right — removing `foodIds` and `workoutIds` from `DailyLog` simplifies everything massively. Here's the revised plan:

## Revised Architecture

**Before (current):**
```
DailyLog.foodIds → [food IDs] → Food entries
DailyLog.workoutIds → [workout IDs] → Workout entries
→ Recalculation must sync food/workout lists with aggregates
```

**After (new):**
```
Food.repo.listByCalendarDay(date) → all foods for date
Workout.repo.listByCalendarDay(date) → all workouts for date
→ Recalculation queries foods + workouts, writes to DailyLog.calculation
→ No ID coupling at all
```

## Revised Steps

### Step 1: Remove foodIds/workoutIds from DailyLog entity
- Delete `foodIds` and `workoutIds` fields from `DailyLog`
- Run `build_runner` to regenerate Isar models
- Update `DailyLogConfig` if it references these

### Step 2: Rewrite recalculation in DailyLogService
- `recalculateForDay(DateTime date)` queries:
  - `foodRepo.listByCalendarDay(date)` → sum macros
  - `workoutRepo.listByCalendarDay(date)` → sum burn
  - Writes totals to `DailyLog.calculation` (upsert today's log)

### Step 3: Decouple AddFoodScreen completely
- Remove all DailyLog writes from the screen
- Screen only creates/updates Food entity with `date = targetDate`
- On save, call `dailyLogService.recalculateForDay(targetDate)` as a side effect

### Step 4: Rewrite Dashboard food/workout sections
- `FoodSection`: query `foodRepo.listByCalendarDay(selectedDate)` directly
- `WorkoutSummary`: same pattern
- Add long-press delete on food list items (calls `foodRepo.delete(foodId)` then `recalculateForDay`)

### Step 5: Fix dashboard refresh
- When `_selectedDate` changes → `ref.refresh(dailyLogListProvider)` + recalc
- When navigating back from food screen → already works via provider invalidation

### Step 6: Simplify Food entity
- Remove `unit` field from `FoodBase` and `FoodConfig`
- Hardcode unit as 'g' everywhere needed in presentation layer

## What This Eliminates

- ❌ No more foodIds coupling bugs
- ❌ No more DailyLog corruption on food save
- ❌ No more "deselect doesn't work" (delete just removes Food, recalc picks it up)
- ❌ No more dashboard refresh issues (query by date, always fresh)

Shall I proceed with implementation? Toggle to **Act mode** when ready.
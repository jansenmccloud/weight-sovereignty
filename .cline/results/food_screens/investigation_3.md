## Investigation Results

After reading all relevant files, here's what I found for each TODO item:

### 1. "Deselect food doesn't remove from DailyLog"
**Confirmed.** `DailyLog.removeFoodId()` correctly removes from the internal `_foodIds` set and updates the public `foodIds` set, but neither `DailyLogService.removeFoodFromLog()` nor `IsarDailyLogRepository.save()` actually persists this change to Isar. The method exists but is never called from UI.

### 2. "AddFoodScreen should not contain DailyLog state"
**Confirmed.** `FoodListNotifier` receives `dailyLog: _dashState.dailyLog!` in its `Family` constructor (line 158-164). This couples food entry to the dashboard's current log state unnecessarily.

### 3. "Dashboard screen isn't refreshed when navigating back"
**Root cause:** Dashboard uses `FutureBuilder` with `ref.watch(dailyLogForDateProvider(_selectedDate))`. The `FutureBuilder` may not rebuild on navigation return because the watched provider value hasn't changed (same date, same future identity).

### 4. "On food save → daily log broken → weight/BMR/profile deleted"
**Likely cause:** In `recalculateFromDate()`, it loads today's log, iterates over ALL foods from `listByCalendarDay(today)`, then **overwrites** the log's food/workout IDs. If there's a timing issue where the log isn't found or the set is empty during overwrite, all tracked IDs get cleared.

### 5. "Unit field can be hardcoded to 'g'"
**Confirmed.** Both `Food` and `FoodConfig` have `amount` and `unit` fields. The UI already shows "gram" as a static label (line 319 in `dash_food_section.dart`). We can simplify by removing `unit` from both models.

---

## Proposed Plan

### Phase 1: Fix Food Save Breaking DailyLog (HIGH PRIORITY)
**File:** `daily_log_service.dart`
- In `recalculateFromDate()`: don't load a fresh log — accept the log passed in, or use `getForCalendarDay(day)` not `today`
- Ensure food entries are summed correctly from the SAME day's food IDs that were on the log before save
- Key fix: **recalculate should only update Calculation values, never overwrite foodIds/workoutIds**

### Phase 2: Decouple AddFoodScreen from DailyLog (HIGH PRIORITY)
**Files:** `add_food_screen.dart`, `food_list_notifier.dart`
- Remove `dailyLog` parameter from `FoodListNotifier`
- Remove `deselectAll()` and `removeFood()` methods from the notifier (or move them to dashboard)
- Add `saveFoodName()` method to `FoodEntryEditorState` that calls `context.read(foodEntryProvider.notifier).updateFoodName(name)`
- `AddFoodScreen.onSaved` callback fires a `SaveFoodCommand` — just saves, no recalculation

### Phase 3: Fix Dashboard Refresh on Navigation Return
**File:** `dashboard_screen.dart`
- Replace `FutureBuilder` + `ref.watch` with a Riverpod `Notifier` that owns the selected date and log state
- Or add a `Key` to the `FutureBuilder` that changes when navigation returns
- Simplest fix: use `Consumer` with a provider that's invalidated after food/workout save

### Phase 4: Dashboard Workout Summary Parameter Fix
**File:** `dashboard_screen.dart`
- Pass correct parameter name: `totalDurationMinutes: workoutSummary.totalDurationMinutes` instead of `workoutSummary`

### Phase 5: Remove Unit Field from Food Models (LOW PRIORITY)
**Files:** `food.dart`, `food_config.dart`, all UI referencing `unit`
- Keep only `amount` (int, always grams)
- Update `FoodBase` and `FoodConfigEntry` to remove `unit`
- Run build_runner, update any generated code

---

Want me to proceed with Phase 1 first? Toggle to **Act mode** and I'll implement the fixes step by step.



## Found issues

I found 6 compilation errors in the current codebase:

1. __debug_screen.dart:292__ - `foodIds` / `workoutIds` getters undefined on `DailyLog` (field names may have changed)
2. __dash_food_section.dart:5__ - Wrong import path for `service_providers.dart`
3. __dash_food_section.dart:40__ - `Route<void>` type mismatch (needs `Route<int>`)
4. __dash_food_section.dart:44 & 111__ - `.notifier` used on singleton `Provider<DailyLogService>` instead of `NotifierProvider`

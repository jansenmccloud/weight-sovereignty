Good — now I have everything I need. Here's the complete plan:

---

## Plan: Dashboard + Morning Weight (Option A)

### Implementation Architecture

Following the [Flutter architecture rules](flutter/weight_sovereignty/.cursor/rules/flutter-architecture.mdc):
- **domain layer**: `DailyLog` entity, `Calculation` model (already exist — no changes needed)
- **application layer**: New `DailyLogService` use case + Riverpod providers for calculation and getOrCreateForDay
- **presentation layer**: `DashboardScreen` (today's log card + weight entry + macros overview) + `MorningWeightScreen`

### Detailed Steps

#### Step 1: `DailyLogService` in `application/dailylog/`
Create `daily_log_service.dart` — a service class with three key methods:

1. **`createForDay(DateTime day, DailyLogConfig bmrPreset)`** — creates today's DailyLog with BMR baseline from config (replaces the empty creation in `getOrCreateForDay`)
2. **`saveBodyWeight(DailyLog log, double weightKg)`** — updates bodyWeight field on a DailyLog and persists
3. **`recalculateDailyLog(List<int?> foodIds, List<int?> workoutIds)`** — aggregates food macros + workout burn calories; returns updated `Calculation`. **Does NOT write to DB** — pure computation that returns the Calculation to be saved.

Also create `daily_log_service_provider.dart` with a `Provider<DailyLogService>`.

#### Step 2: Dashboard screen in `presentation/screens/dashboard/`
Create `dashboard_screen.dart` — a single scrollable page showing:

- **Header**: App bar with date navigation (tap to change day)
- **Weight Card**: If weight exists → large display of weight + Δ vs yesterday. If missing → link to MorningWeightScreen
- **Calories Overview Card**: BMR baseline, total intake, Δ calories (net surplus/deficit), macro breakdown (protein/carbs/fat bars)
- **Food List Section**: Title "Food" with each logged food item's name + kcal; "[+ Food]" button → opens FoodEntryScreen (simple form with recent foods from `foodConfigListProvider`)
- **Workout Summary Section**: Title "Workout" with summary of logged workouts; "[+ Workout]" button → opens `WorkoutSessionScreen` (future milestone)

Design notes per [android-and-ux rules](flutter/weight_sovereignty/.cursor/rules/android-and-ux.mdc):
- Weight display: large numeric typography (headline style)
- Δ calories shown with color coding (+ = red surplus, - = blue deficit) — but muted variants to match dark theme
- No confirmation dialogs; weight entry is fast (<3s tap target)

#### Step 3: Morning Weight Screen in `presentation/screens/dashboard/`
Create `morning_weight_screen.dart` — a minimal screen for entering daily weight:

- Title: "Morning Weight" or "Weight Update"
- Large text field (numeric input, decimal support) for weight in kg
- Save button with minimum 56dp tap target
- On save: calls `DailyLogService.saveBodyWeight`, shows snackbar confirmation, pops back to Dashboard
- Auto-populates the field with yesterday's weight if available

#### Step 4: Update App Shell
Update `home_shell_screen.dart` (or replace entirely):
- Change from Settings hub → **Dashboard as default home**
- Move Settings entry to an AppBar overflow menu (gear icon) instead of main body list item
- Dashboard becomes the primary screen; Settings remains accessible

### File Map (new files)
```
lib/src/application/dailylog/
  daily_log_service.dart        # [NEW] use case methods
  daily_log_service_provider.dart  # [NEW] Provider<DailyLogService>

lib/src/presentation/screens/dashboard/
  dashboard_screen.dart         # [NEW] main tracking screen
  morning_weight_screen.dart    # [NEW] weight entry screen
```

### File Map (modified files)
```
lib/src/presentation/app_root.dart           # add DailyLogServiceProvider scope
lib/src/presentation/screens/home_shell_screen.dart  # Dashboard as default home, Settings in AppBar
lib/src/data/dailylog_repository.dart        # (no changes needed — already has getOrCreateForDay)
```

### Calculation Details
`DailyLog.calculation` is a `Calculation` embedded object with fields: `totalBurnedCaloriesKcal`, `totalIntakeCaloriesKcal`, `totalIntakeProteinG`, `totalIntakeCarbsG`, `totalIntakeFatG`.

The service will compute by:
1. Querying all `Food` entities for today's `foodIds` → sum their `intakeCaloriesKcal`, `intakeProteinG`, `intakeCarbsG`, `intakeFatG`
2. Querying all `Workout` entities for today's `workoutIds` → sum `burnedCaloriesKcal` from each workout's exercises
3. Returning a new `Calculation` with the aggregated values

This mirrors what the repo TODO says needs to happen before persisting DailyLog.

---

Does this plan look good? If so, toggle to Act mode and I'll start implementing.
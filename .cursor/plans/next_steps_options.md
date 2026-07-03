# Next Steps After Config Settings UI Completion

## Current Project State (as of 2026-07-03)

### Completed Milestones (Config Plan)
- **Milestone A** — App shell + shared UI ✅
  - `app_theme.dart` — dark Material 3 theme
  - `HomeShellScreen` — temporary home with Settings entry
  - Shared widgets: `AsyncListScaffold`, `ConfigListTile`, `ConfigFormScaffold`
  
- **Milestone B** — Settings CRUD flows ✅
  - Food presets list + edit screens
  - Exercise presets list + edit (with enum dropdowns)
  - Daily log profiles list + edit
  - Workout templates list + edit (with exercise picker)

- **Milestone C** — Tests + cleanup ✅
  - Widget tests for settings hub
  - Android manual CRUD smoke check

### What's Built But Disconnected
- Config presets UI (Food, Exercise, Workout, DailyLogConfig) — wired to providers
- Repositories + services for configs
- `DailyLog` entity + repo for actual day logging

### What Has NOT Been Built Yet
- Dashboard screen (default home view with macros/burn)
- Morning weight entry flow
- Workout session screen (full-screen, dynamic sets)
- Food add/favorites flow from dashboard
- DailyLog calculation engine (recompute macros/burn from foodIds + workoutIds)

---

## Next Priority Tasks (in recommended order)

### Option 1: Dashboard Screen (Highest Priority)
The core home screen showing today's `DailyLog` with weight, macros, and burn.

**Required components:**
- `getOrCreateForDay` helper called on app startup
- Dashboard screen displaying:
  - Today's weight with delta vs yesterday
  - Macro aggregates (protein/carbs/fat/kcal from linked foods)
  - Burned calories from linked workouts
  - Quick-add buttons: `[+ Food]`, `[+ Workout]`
- Weight entry flow (large numeric field, <3s target)
- Food add flow consuming `FoodConfig` favorites

**Key files needed:**
```
lib/src/presentation/screens/
  dashboard_screen.dart           # Main dashboard
  widgets/
    weight_display_card.dart
    macros_aggregate_card.dart
    quick_add_button_row.dart
lib/src/application/dailylog/
  get_or_create_for_day.dart      # Helper on startup
```

**Why first:** This is the default home screen users see. Everything else builds on it.

---

### Option 2: DailyLog Calculation Engine
Compute the actual numbers — totals from linked foods + workouts, BMR comparison.

**Required logic:**
- Sum calories/macros from all `Food` entries in `foodIds`
- Sum burn from all `Workout` entries in `workoutIds` (uses MET × duration)
- Compare daily intake vs BMR (from `DailyLogConfig`)
- Display net calories = BMR + workout_burn - food_intake

**Key files needed:**
```
lib/src/application/
  calculation_service.dart        # Core computation logic
lib/src/domain/entity/
  calculation.dart                # May need extension for new fields
```

**Why second:** Calculations must exist before the dashboard can display meaningful aggregates.

---

### Option 3: Workout Session Screen
Active workout UI — full-screen, minimal tap targets, dynamic sets with add/edit/long-press.

**Required components:**
- Load template from `WorkoutConfig` (from presets)
- Full-screen session screen with:
  - Exercise list from template
  - Dynamic sets per exercise (add/edit rows)
  - Timer / rest period tracking
  - Minimal animation, high contrast
  - Tap targets ≥56dp for set rows

**Key files needed:**
```
lib/src/presentation/screens/
  workout_session_screen.dart     # Full-screen session
lib/src/presentation/widgets/
  exercise_row_widget.dart
  set_row_widget.dart             # With long-press support
  workout_timer_widget.dart
lib/src/application/workout/
  session_state_provider.dart     # Riverpod state management
```

**Why third:** Needs config UI (done) + calculation engine (Option 2) for MET/burn.

---

### Option 4: Seed Initial Presets
Auto-populate sensible defaults on first launch so users aren't starting from empty.

**Approach:**
- Add a `seed_if_empty()` call in `LocalStorage.open` or app startup
- Hardcode ~10 common foods (rice, chicken breast, eggs, banana, bread)
- Hardcode ~5 basic exercises (push-up, squat, pull-up, bench press, deadlift)
- One default daily log profile (BMR based on average adult)
- One default workout template (full-body beginner routine)

**Where:**
```
lib/src/data/source/
  local_storage.dart              # Add seed call after first open
```

**Why last or optional:** Users can manually create presets. Good for UX polish but not critical.

---

## Recommended Implementation Order

1. **DailyLog calculation engine** — numbers must work before display
2. **Dashboard screen** — main home view, ties everything together
3. **Workout session screen** — core workout flow
4. **Seed presets** — optional UX polish

Alternative: Start with Dashboard skeleton (static data), then wire up real calculations.

---

## Key Constraints from Development Docs

- Weight target: <3s to entry and save
- Food target: <5s via favorites/recent list
- Workout set log: <5s per set
- No confirmation dialogs for obvious actions
- Silent auto-create today's DailyLog on date change
- Dark Material 3, industrial/calm tone — no gamification
- Offline-first, no network dependencies

---

## Files Already Available to Reuse

### Providers
- `foodConfigListProvider`, `exerciseConfigListProvider`
- `workoutConfigListProvider`, `dailyLogConfigListProvider`
- `foodListProvider`, `workoutListProvider`
- `dailyLogListProvider` (for today's DailyLog)

### Services
- `FoodService` — CRUD for food configs
- `ExerciseConfigService` — CRUD for exercise presets
- `WorkoutConfigService` — CRUD for workout templates
- `DailyLogConfigService` — CRUD for daily log profiles
- `DailyLogService` — CRUD for actual day logs

### Repositories (Domain Interfaces)
- `FoodRepo`, `WorkoutRepo`, `DailyLogRepo`
- `FoodConfigRepo`, `ExerciseConfigRepo`, etc.

### Config Models (presets/templates)
- `FoodConfig`, `ExerciseConfig`
- `WorkoutConfig`, `DailyLogConfig`

### Entity Models (logged data)
- `DailyLog`, `Food`, `Workout`
- `Calculation` — already exists, may need extension

---

## Open Questions for User

1. Should `getOrCreateForDay` run silently on startup or show a brief indicator?
2. For weight entry: should it be inline on dashboard or navigate to a dedicated screen?
3. Food add flow: should it pre-populate from `FoodConfig` favorites, or search all foods?
4. Workout session timer: real-time countdown or manual rest tracking?
5. Should we seed presets automatically, or let user create them manually first?

---

*This file was generated as a reference for choosing the next task after completing the Config Settings UI plan.*
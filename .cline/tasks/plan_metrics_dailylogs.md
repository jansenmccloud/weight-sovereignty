# plan daily logs metrics

Here is the implementation plan for `_dailyLogsWidgets()`:

## Current State

The method currently returns an empty list. The TODOs require:
1. **Total count of DailyLogs** — how many days have logged data
2. **Averages of**: intake protein, intake fat, intake carbs, intake calories

## Data Access Path

From the exploration, the provider chain is:

```
dailyLogServiceProvider → dailyLogRepositoryProvider → DailyLogRepository (interface)
                                                                        ↓
                                                                 data/dailylog_repository.dart
                                                                        ↓
                                                         queryByDateRange(start, end)
```

The key existing methods:
- `DailyLogService.refreshToday()` / `refreshForDay(day)` — gets today's log with recalculated macros
- `DailyLogRepository.getAll()` — query all logs (already exists on the interface)
- `Calculation` entity holds: `totalIntakeCaloriesKcal`, `totalIntakeProteinG`, `totalIntakeCarbsG`, `totalIntakeFatG`

## Implementation Plan for `_dailyLogsWidgets()`

### Step 1: Watch all DailyLogs via a Riverpod provider
Create an async provider that fetches all DailyLogs (or use `DailyLogService` directly in the widget with `ref.read`). Since this is a settings stats screen, loading all historical data is appropriate:

```dart
// In the widget build method:
final logs = await ref.read(allDailyLogsProvider.future);
```

Where `allDailyLogsProvider` loads every DailyLog via `_dailyLogRepo.getAll()`.

### Step 2: Compute statistics from the loaded data
Iterate over all logs and compute:
- `totalCount` — `logs.length`
- Average `totalIntakeProteinG` across non-null entries
- Average `totalIntakeFatG` across non-null entries
- Average `totalIntakeCarbsG` across non-null entries
- Average `totalIntakeCaloriesKcal` across non-null entries

### Step 3: Render as ListTile widgets
Return a `List<Widget>` (matching the existing signature) with:
- One `ListTile` per metric (count + 4 averages), using icons and formatted values similar to `_formulasWidgets()` style

Example output structure:
```
[
  ListTile(title: 'Total Logs: 42', leading: Icon(Icons.list_alt)),
  ListTile(title: 'Avg Intake Protein: 120g/day', leading: Icon.fast()),
  ListTile(title: 'Avg Intake Fat: 65g/day', ...),
  ListTile(title: 'Avg Intake Carbs: 200g/day', ...),
  ListTile(title: 'Avg Intake Calories: 2100 kcal/day', ...),
]
```

### Step 4: Handle empty state
If no logs exist, show a single `ListTile` with message "No daily logs yet" instead of statistics.

---

## Key Design Decisions

1. **Use `ref.read(dailyLogRepositoryProvider).queryByDateRange()`** directly in the widget's `build` (async) rather than creating a separate provider — stats are computed once per frame and don't need caching
2. **Format numbers with units** (g, kcal) for readability
3. **Keep the existing `ExpansionTile` wrapper** — no structural changes

## Files to Modify

- **Only one file**: `flutter/weight_sovereignty/lib/src/presentation/screens/settings/stats_screen.dart`

---

Ready to implement? Toggle to **Act mode** and I will write the code.

# plan improvement

Good catch — you're right. `getAll()` exists on the base `CrudRepository<DailyLog>` interface and returns all entries without needing date bounds. There's no performance benefit to `queryByDateRange` here since the app is hobby-scale with no large dataset concerns.

Updated approach:

### Step 1: Use `getAll()` instead
In the widget's `build`:
```dart
final logs = await ref.read(dailyLogRepositoryProvider).getAll();
```

No separate provider needed — just read directly from the repository.

### Step 2–4: Same as before
Compute stats from the list, render ListTile widgets, handle empty state.

### Updated plan file update
The implementation will change from `queryByDateRange(start, end)` → `getAll()` and everything else stays identical.

Ready to implement? Toggle to **Act mode** and I will write the code.

# plan improvement 2

Agreed. Updated averaging logic:

### Filtering rule for averages
For each metric (protein, fat, carbs, calories), exclude entries where the value is:
- **null**
- **zero** (== 0)
- **negative** (< 0)

Only non-null values > 0 contribute to the average. If all entries are filtered out for a given metric, show "—" instead of a number.

### Implementation snippet pattern
```dart
final validProtein = logs.where((l) => (l.calculation?.totalIntakeProteinG ?? 0) > 0).toList();
final avgProtein = validProtein.isEmpty
    ? null
    : validProtein.fold<double>(0, (sum, l) => sum + (l.calculation!.totalIntakeProteinG ?? 0)) / validProtein.length;
```

---

Plan is now final. Toggle to **Act mode** and I will write the code.
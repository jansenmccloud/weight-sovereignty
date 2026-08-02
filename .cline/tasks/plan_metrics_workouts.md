# plan metrics workouts

I've investigated the codebase and have a clear plan for implementing `_workoutsWidgets()`. Here's what I found:

## Data Model Summary

- **`Workout`** entity has: `WorkoutBase.name`, `date`, and `List<ExerciseBase?> exercises`
- **`ExerciseBase`** has: `name`, `categoryName`, `typeName` (cardio/lifting), `sets` (list of `ExerciseSet` with `weightKg`/`reps`), `distanceKm`, `durationMin`
- `WorkoutRepository.getAll()` returns all workouts — we can filter by date range using `queryByDateRange`

## Implementation Plan for `_workoutsWidgets()`

All 3 TODO blocks map to the following metrics:

### 1. Global Workout Totals (first TODO)
- **Total workout count**: `workouts.length`
- **Total sets across all exercises**: iterate all workouts → sum `exercise?.sets?.length ?? 0`
- **Total reps across all exercises**: iterate all workouts → for each set, sum `set?.reps ?? 0`

### 2. Per-Workout-Template Stats (second TODO)
- Group workouts by `workoutBase.name` using a `Map<String, List<Workout>>`
- For each template: count workouts, collect all exercise names across sessions
- Track unique exercise names per template

### 3. Personal Bests (third TODO)
For **lifting** exercises:
- Group all exercises by `name` across all workouts
- For each exercise name: find the set with `max weightKg` and the set with `max reps`

For **cardio** exercises:
- Group by `name`; for each: find max `durationMin` and max `distanceKm`

### UI Structure (using `ListTile`)

```
_expandingTile("Workouts", _workoutsWidgets)
├── [Section] Global Totals
│   ├── ListTile: Total Workouts: N
│   ├── ListTile: Total Sets: N
│   └── ListTile: Total Reps: N
├── [Section] Per Template (ExpansionTile per template, or collapsible)
│   ├── ListTile: "Template A" — X workouts, Y exercises tracked
│   └── ...
└── [Section] Personal Bests
    ├── ExpansionTile: "Lifting PRs"
    │   ├── ListTile: "Exercise Name" — Max: Xkg / Y reps
    │   └── ...
    └── ExpansionTile: "Cardio PRs"
        ├── ListTile: "Exercise Name" — Max: X min / Y km
        └── ...
```

### Implementation approach (in `_workoutsWidgets()`):
1. `await ref.read(workoutRepositoryProvider).getAll()` to get all workouts
2. Compute global stats in a single pass
3. Build template map: `workouts.groupBy((w) => w.workoutBase?.name ?? 'Unknown')`
4. Build PR maps: collect all exercises with their type, group by name, find max per metric
5. Return list of widgets

### Key helpers needed:
- Extension or helper to extract `ExerciseType` from `exercise?.typeName` (already has `ExerciseType.getTypeFromString()`)
- Helper to distinguish lifting vs cardio PR display

---

**Questions before implementation:**
1. Should the per-template breakdown use nested `ExpansionTile` inside the main tile wrapper, or a simpler flat list?
2. For PRs, should we show the workout date where the PR occurred, or just the values?
3. Any preferred icon for "workout" section tiles to keep visual variety without overdoing it?

If you're satisfied with this plan, **toggle to Act mode** and I'll implement it.

# Answers

answers to your open questions:

1. a simplier flat list is more suitable

2. the values with date: but always show both values together: weight and reps, so like distance and duration => examples 
- for max weight entry: 90 kg | 8 Reps (2026-09-02)
- for max reps entry: 70 kg | 15 Reps (2026-09-01)
- for max distance entry: 20 km | 200 min (2026-09-02)
- for max duration entry: 18 km | 220 min (2025-12-01)

3. no preferred icon, take any, i will replace it afterwards

take these information to refineand finalize the plan

# finalized plan

Here's the finalized implementation plan:

---

## Final Plan: `_workoutsWidgets()` Implementation

### Method signature stays `Future<List<Widget>> _workoutsWidgets() async { ... }`

### Step 1: Fetch all workouts
```dart
final workouts = await ref.read(workoutRepositoryProvider).getAll();
```
Use `workoutRepositoryProvider` (not `dailyLogRepositoryProvider`) — it's already imported via `repository_providers.dart`.

### Step 2: Compute global totals in one pass
```dart
int totalWorkouts = workouts.length;
int totalSets = 0;
int totalReps = 0;
for (final w in workouts) {
  final exercises = w.exercises ?? [];
  for (final ex in exercises) {
    final sets = ex?.sets ?? [];
    totalSets += sets.length;
    for (final s in sets) {
      totalReps += s?.reps ?? 0;
    }
  }
}
```

### Step 3: Per-template breakdown (flat list)
```dart
final templateMap = <String, List<Workout>>{};
for (final w in workouts) {
  final name = w.workoutBase?.name ?? 'Unknown Workout';
  templateMap.putIfAbsent(name, () => []);
  templateMap[name]!.add(w);
}
```
For each entry: count unique exercise names across all sessions in that template → one `ListTile` per template.

### Step 4: Personal Bests — Lifting PRs
Collect all lifting exercises grouped by name into a map `Map<String, List<ExerciseBase>>`. For each exercise:
- Iterate all its sets across all workouts
- Find the set with max weight AND the workout date it belongs to
- Find the set with max reps AND the workout date it belongs to
- Format: `"90 kg | 8 Reps (2026-09-02)"`

### Step 5: Personal Bests — Cardio PRs
Collect all cardio exercises grouped by name. For each:
- Find max `distanceKm` with date → `"20 km | 200 min (2026-09-02)"` (distance + duration from same entry)
- Find max `durationMin` with date → `"18 km | 220 min (2025-12-01)"` (distance + duration from same entry)

Note: For cardio, distance and duration come from the **same** `ExerciseBase`, not individual max values from different entries. So we find the single entry with max distance and report its distance+duration together, and separately find the entry with max duration and report its distance+duration together.

### Step 6: Build widget list (flat)
```
ListTile — Total Workouts: N                    [Icons.fitness_center]
ListTile — Total Sets: N                        [Icons.layers]
ListTile — Total Reps: N                        [Icons.repeat]
[divider or section label]
ListTile — "Workout Template A" — 3 workouts, 5 exercises   [Icons.workspace_premium]
ListTile — "Workout Template B" — 2 workouts, 3 exercises   [Icons.workspace_premium]
[divider or section label]
ListTile — Lifting PRs header                   [Icons.emoji_events]
ListTile — "Exercise Name" — 90 kg | 8 Reps (2026-09-02)  [Icons.fitness_center]
ListTile — "Exercise Name" — 70 kg | 15 Reps (2026-09-01) [Icons.fitness_center]
ListTile — Cardio PRs header                    [Icons.directions_run]
ListTile — "Running" — 20 km | 200 min (2026-09-02)        [Icons.directions_run]
ListTile — "Cycling" — 18 km | 220 min (2025-12-01)        [Icons.directions_bike]
```

### Dependencies already available
- `workoutRepositoryProvider` — add to imports (already exported by `repository_providers.dart`)
- No new models needed — everything uses existing `Workout`, `ExerciseBase`, `ExerciseSet`
- Icons from Material — use generic ones (`Icons.fitness_center`, `Icons.layers`, `Icons.repeat`, `Icons.emoji_events`, `Icons.directions_run`)

---

Ready to implement. Toggle to **Act mode** when you're good to go.
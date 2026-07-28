# export config plan

I've reviewed all four config entity types and the existing export infrastructure. Here's the plan:

## Config Entity Summary

| Entity | Key Fields | Relations |
|--------|-----------|-----------|
| `FoodConfig` | name, favorite, calories/protein/carbs/fat, amountG | flat |
| `ExerciseConfig` | name, category/type/intensity (enums as strings), weightKg, reps, sets, distanceKm, durationMin, burnedCaloriesKcal | flat, enums stored as string names |
| `WorkoutConfig` | name, exercisePresetNames (List\<String?>) | references ExerciseConfig by name |
| `DailyLogConfig` | name, bmr/planned deficit/macros | flat preset template |

## Plan: JSON Export for Config Data

### 1. Add config repository dependencies to ExportService

Import and wire up the four config repos: `FoodConfigRepo`, `ExerciseConfigRepo`, `WorkoutConfigRepo`, `DailyLogConfigRepo`. The service already has a dependency-injection pattern — just add the four new parameters.

### 2. Add JSON export methods

Since configs are presets (no date filtering needed for import/export), I'd propose **removing the date picker for config exports** or making it optional. A flat JSON structure works best:

```json
{
  "exportFormat": "weight_sovereignty_config",
  "version": "1.0",
  "exportedAt": "2026-07-28T23:00:00",
  "foodConfigs": [ ... ],
  "exerciseConfigs": [ ... ],
  "workoutConfigs": [ ... ],
  "dailyLogConfigs": [ ... ]
}
```

Each collection exports the raw Isar fields (excluding `id` and `@ignore` getters), with enum strings preserved as-is. This structure supports:
- **Selective export** — all four or any subset
- **Date range option** — though configs are timeless, keeping the date filter in UI is harmless for consistency

### 3. UI Changes to ExportScreen

Add a second top-level selector: **Data type** (time series vs config presets). When "Config presets" is selected, hide the date range section and show a checklist of the four config types with toggle chips.

```
┌─────────────────────────────┐
│ Data category               │
│ [Time Series] [Config Presets]  │
├─────────────────────────────┤
│ Entity type                 │
│ [FoodConfig] [ExerciseConfig] │
│ [WorkoutConfig] [DailyLogConfig] │
├─────────────────────────────┤
│ Export config data          │   ← button hides date range
└─────────────────────────────┘
```

### 4. Import counterpart (future)

The JSON format is designed to be **round-trippable** — `fromJson()` can repopulate all four config collections, supporting the device-change/corruption recovery use case.

---

### Questions for you:

1. **Date range for config export** — Since configs are timeless presets, should we hide the date picker entirely when "Config Presets" is selected, or keep it for UI consistency?

2. **Import feature scope** — Should this plan include the import functionality (JSON → Isar) as well, or just export for now?

3. **WorkoutConfig exercisePresetNames** — WorkoutConfig references ExerciseConfig by name string list. Should we also export the full ExerciseConfig objects embedded inside WorkoutConfigs, or keep them as separate arrays and resolve by name on import?

----

# answera to open questions

answer to your questions to refine the plan:

1. yes hide the date picker when "Config Presets" is selected
2. just export for now
3. resolve by name later on import

also additional info for your proposed solution:
- for the "Config Presets" export we export all config objects in one file, no need to multiselect them, export config all together

refine the plan with these information

# refined plan

Here's the refined plan:

---

## Refined Plan: Config Presets Export

### 1. `ExportService` — add config export method

**File:** `lib/src/application/export_service.dart`

- Add four new repo constructor parameters: `foodConfigRepo`, `exerciseConfigRepo`, `workoutConfigRepo`, `dailyLogConfigRepo`
- Add one method: `toConfigJson()` that reads all four collections and returns a single JSON string

**Exported JSON shape:**
```json
{
  "exportFormat": "weight_sovereignty_config",
  "version": "1.0",
  "exportedAt": "2026-07-29T00:00:00+02:00",
  "foodConfigs": [...],
  "exerciseConfigs": [...],
  "workoutConfigs": [...],
  "dailyLogConfigs": [...]
}
```

Each array contains the raw fields of each config object as Isar stores them (no `@ignore` getters). Enum values stored as strings (e.g. `"chest"`, `"cardio"`). WorkoutConfig keeps its `exercisePresetNames` as a string list — resolved by name on import later.

### 2. `ExportScreen` — add "Config Presets" data category

**File:** `lib/src/presentation/screens/settings/export_screen.dart`

Add a top-level segment control:

```
┌──────────────────────────────────┐
│ Export type                       │
│ [Time Series Data] [Config Presets]  │
├──────────────────────────────────┤
│ (shows date picker + entity selector for time series)    │
│ OR                               │
│ (single "Export config data" button for configs)         │
└──────────────────────────────────┘
```

**Changes:**
- Add enum `ExportType { timeSeries, configPresets }` with a segment control at top
- When `configPresets`: hide date range section and entity selector; show single "Export & Save" button that calls the new `toConfigJson()` method
- When `timeSeries`: keep existing behavior (entity selector + date range)

**Filename convention:** `weight_sovereignty_config_ymd.json`

### 3. File pickers dependency check

Verify `file_picker: ^8.0.0` is in `pubspec.yaml`. If not already present, add it and run `flutter pub get`.

---

### Files to modify:
1. `flutter/weight_sovereignty/lib/src/application/export_service.dart` — add config repos + `toConfigJson()`
2. `flutter/weight_sovereignty/lib/src/presentation/screens/settings/export_screen.dart` — add config presets export path
3. `flutter/weight_sovereignty/pubspec.yaml` — verify `file_picker` (already added per your earlier work)

---

Ready to implement. **Toggle to Act mode** and I'll make these changes.
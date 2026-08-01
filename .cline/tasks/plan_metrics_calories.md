# plan metrics calories

## Plan: `_caloriesWidgets()` Implementation

### Data Available from `DailyLog`

| Field | Source | Meaning |
|-------|--------|---------|
| `calculation.totalIntakeCaloriesKcal` | food intake | Calories eaten |
| `dailyLogBase.bmrCaloriesKcal` | BMR preset | Basal metabolic rate |
| `plannedDeficitKcal` | preset | Planned deficit |
| `calculation.totalBurnedCaloriesKcal` | workout burn | Calories burned via exercise |

**Deficit calculation:** `deficit = (BMR + burned) - intake` (positive = surplus, negative = deficit)

---

### Architecture

Reuse `WeightChart`'s CustomPaint approach but create a **multi-curve line chart** widget (separate file) since we have 4 series to overlay on one coordinate system. Adapt the hover/interceptor pattern from `weight_chart.dart`.

**New files:**
1. `flutter/weight_sovereignty/lib/src/presentation/widgets/calories_chart.dart` — multi-curve chart widget + painter

---

### Resolution Modes

| Mode | Aggregation | X-axis span |
|------|-------------|-------------|
| Daily | Each log point | All available |
| Weekly | 7-day rolling mean per curve | Last 28–90 days visible |
| Monthly | Per-calendar-month aggregates | Last 6–12 months |
| Yearly | Per-calendar-year aggregates | All years available |

**Smoothing:**
- **Daily:** raw values, null-excluded points still plotted (gaps, no interpolation)
- **Weekly:** rolling 7-day mean — need ≥1 data point in window to compute
- **Monthly:** sum intake/burn per month, average BMR across days in month
- **Yearly:** same as monthly but aggregated by year

---

### Chart Curves (4 lines, distinct visual treatment)

```
Line 1: Intake Calories    — solid, white/light gray
Line 2: BMR                — dashed or thinner (baseline reference)
Line 3: Burned Calories    — muted accent color
Line 4: Deficit            — area fill below line (green if negative=deficit, red if positive=surplus) OR a separate line with inverted coloring
```

**Legend:** Compact row below chart or in-corner legend with colored dots + labels.

**Hover tooltip:** Shows all 4 values for the nearest date on tap/hover.

---

### `_caloriesWidgets()` Structure

```dart
Future<List<Widget>> _caloriesWidgets() async { ... }
// Returns: [
//   ResolutionPickerRow(...),  // segmented control: Daily | Weekly | Monthly | Yearly
//   CaloriesChart(...),         // the CustomPaint chart (reuses WeightChart patterns)
//   LegendRow(...),             // compact legend
// ]
```

**Resolution picker:** Horizontal `SegmentedButton` or custom row of pill buttons — consistent with M3 dark theme. No modal spam.

---

### Data Aggregation Helper (inside `_caloriesWidgets()`)

```dart
enum Resolution { daily, weekly, monthly, yearly }

// 1. Fetch all logs (reuse dailyLogRepositoryProvider)
// 2. Group by resolution bucket
// 3. Compute per-bucket aggregates:
//    - avg BMR (from dailyLogBase.bmrCaloriesKcal)
//    - sum intake (from calculation.totalIntakeCaloriesKcal)
//    - sum burned (from calculation.totalBurnedCaloriesKcal)
//    - compute deficit = BMR + burned - intake
// 4. For weekly: rolling 7-day window before final bucket aggregation
// 5. Emit List<CaloriesChartDataPoint>{date, intake, bmr, burned, deficit}
```

---

### Adaptation from `weight_chart.dart`

| From weight_chart.dart | Adapted for calories_chart.dart |
|------------------------|--------------------------------|
| `WeightDataPoint{date, weight}` | `CaloriesChartDataPoint{date, intake, bmr, burned, deficit}` |
| Single-line painter | 4-line painter with color coding |
| Hover → single label | Hover → all-4-values tooltip |
| Y-axis: kg | Y-axis: kcal (auto-scale) |
| Grid lines at 4 steps | Grid lines at N steps (kcal increments) |
| `CustomPainter` | `CustomPainter` (same pattern) |

---

### Files to Create/Modify

| Action | File |
|--------|------|
| **Create** | `flutter/weight_sovereignty/lib/src/presentation/widgets/calories_chart.dart` |
| **Modify** | `flutter/weight_sovereignty/lib/src/presentation/screens/settings/stats_screen.dart` — replace `_caloriesWidgets()` stub with `Future<List<Widget>>` returning chart + resolution picker |

---

### Questions for Clarification

1. **Deficit visualization:** Should deficit be a line (crossing zero) or an area chart (zero-to-line)?
2. **Time range cap:** Any max data range to show? E.g., "show last 2 years maximum" to avoid tiny, unreadable charts on daily mode?
3. **Zero handling:** If BMR is null but intake/burn exist (or vice versa), should the chart still plot other lines for that date, or skip entirely?
4. **BMR source:** `bmrCaloriesKcal` comes from `DailyLogConfig` preset via `setBase`. Is this the correct BMR source, or should BMR be computed dynamically from body weight / Mifflin-St Jeor formula?

Once you confirm these details, toggle to **Act mode** and I'll implement.

# Answers 

answers to your open questions:
1. both: the planned deficit as line, the real calculated deficit the area 
2. last 2 years as cap sounds good => also adjust plan: remove yearly resolution => support only daily, weekly and monthly
3. keep showing zero values if entries values are null => curve will have a hole which is okay
4. take the set BMR from DailyLogConfig => for a calculated BMR we would need more master data like body height, gender and age

take these information and refine the plan

# Refined plan

## Refined Plan: `_caloriesWidgets()` Implementation

### Data Model

From `DailyLog`:
- `calculation.totalIntakeCaloriesKcal` — food intake (nullable → plot as hole in curve)
- `dailyLogBase.bmrCaloriesKcal` — from preset (nullable → plot as hole)
- `calculation.totalBurnedCaloriesKcal` — workout burn (nullable)
- `plannedDeficitKcal` — planned deficit from preset
- **Computed actual deficit:** `(BMR + burned) - intake`

### Resolution Modes (3 modes)

| Mode | Aggregation | X-axis | Null handling |
|------|-------------|--------|---------------|
| Daily | Each log point as-is | All available (capped to 2 years oldest→today) | Null = gap in curve (no interpolation) |
| Weekly | Rolling 7-day mean | Last ~3 months visible | Window with ≥1 non-null value → compute avg |
| Monthly | Per-calendar-month aggregates | Last ~12 months | Same: avg where partial data exists |

### Chart Design

**Planned deficit line** (from `plannedDeficitKcal` preset): solid, medium contrast
**Actual deficit** (computed = BMR + burned - intake): area fill (green below zero=deficit, red above zero=surplus)
**Intake calories**: solid white/gray line
**BMR**: dashed/thinner gray line
**Burned calories**: muted accent color line

Legend: compact colored dots with labels at bottom of chart.
Hover tooltip: all 5 values + date for nearest data point.

### File Changes

| Action | File |
|--------|------|
| **Create** | `flutter/weight_sovereignty/lib/src/presentation/widgets/calories_chart.dart` — contains `CaloriesChart` widget, `CaloriesChartDataPoint`, resolution picker (`_ResolutionPicker`), and `CaloriesChartPainter` (multi-curve CustomPainter) |
| **Modify** | `flutter/weight_sovereignty/lib/src/presentation/screens/settings/stats_screen.dart` — change `_caloriesWidgets()` to `Future<List<Widget>>`, import new widget, add data aggregation logic |

### `_caloriesWidgets()` Structure (returned list)

```dart
[
  ResolutionPickerRow(resolution, onResolutionChanged),  // pill buttons: Daily | Weekly | Monthly
  SizedBox(height: 8),
  FutureBuilder<List<CaloriesChartDataPoint>>(             // aggregation is async-safe via ref
    future: computeCaloriesDataPoints(resolution),
    builder: (ctx, snap) => snap.data != null
      ? CaloriesChart(dataPoints: snap.data!, resolution: resolution)
      : CircularProgressIndicator(),
  ),
  SizedBox(height: 8),
  LegendRow(),                                              // compact legend with colored dots
]
```

### Data Aggregation (inside `_caloriesWidgets()`)

```dart
enum Resolution { daily, weekly, monthly }

List<DailyLog> allLogs = await ref.read(dailyLogRepositoryProvider).getAll();
// Filter to last 2 years from today
final now = DateTime.now();
final cutoff = DateTime(now.year - 2, now.month, now.day);
allLogs = allLogs.where((l) => l.date!.isAfter(cutoff)).toList()
  ..sort((a, b) => a.date!.compareTo(b.date!));

switch resolution:
  daily → emit CaloriesChartDataPoint{date: log.date, intake, bmr, burned, plannedDeficit, actualDeficit}
  weekly → group by 7-day buckets from now backward → rolling mean per metric
  monthly → group by calendar month → sum intake/burn, avg BMR, compute deficit
```

### Implementation Steps (in code)

1. **`calories_chart.dart`**: 
   - `CaloriesChartDataPoint{date, intake, bmr, burned, plannedDeficit, actualDeficit}` data class
   - `_ResolutionPicker` — horizontal pill button row (Daily/Weekly/Monthly) using M3 `SegmentedButton` or custom wrapped buttons styled per dark theme
   - `CaloriesChart` — StatefulWidget with hover interceptor (like WeightChart)
   - `CaloriesChartPainter` — CustomPainter drawing 5 series (4 lines + area fill for actual deficit)
2. **`stats_screen.dart`**: Replace `_caloriesWidgets()` stub with async method that fetches logs, computes/transforms data points, returns the widget list

### Open Items (confirmed, no blockers)

- ✅ Deficit: planned = line, actual = area (green/red)
- ✅ Time cap: last 2 years; removed yearly resolution
- ✅ Null values: show as gaps (don't interpolate)
- ✅ BMR source: `dailyLogBase.bmrCaloriesKcal` from preset

---

Ready to implement. Toggle to **Act mode** when you approve this plan.

# Context was full - checkpoint to continue:

I created the calories_chart.dart file, but the context window is at 84% with more work remaining. Let me continue by updating stats_screen.dart to use this new widget and implement _caloriesWidgets(). However, I need to be careful about context consumption. Let me proceed efficiently.

## what was completed:

Created `flutter/weight_sovereignty/lib/src/presentation/widgets/calories_chart.dart` with:

1. **`CaloriesChartDataPoint`** — data model with intake, BMR, burned, plannedDeficit, actualDeficit fields
2. **`ChartResolution`** enum — daily, weekly, monthly (placeholder for aggregation logic)
3. **`CaloriesChart`** widget — multi-curve CustomPaint chart matching the weight_chart pattern:
   - Hover interception with MouseRegion → vertical cursor line on hover
   - Dark background (`#0A0A0A`) matching workout session styling
   - 4 curves: intake calories (white), BMR (muted), burned+BMR total (accent), planned deficit (dotted)
   - Green shaded area above intake when burned > 0, red below when burned < 0
   - Tooltip labels with all values for the hovered date
4. **`ResolutionPicker`** — pill-style horizontal row for daily/weekly/monthly toggle

**Remaining work in stats_screen.dart:**
- Add import for `calories_chart.dart`
- Replace `_caloriesWidgets()` placeholder with a Future method that:
  - Fetches today's `DailyLog` and historical logs via `dailyLogRepositoryProvider`
  - Reads BMR preset from `dailyBmrPresetConfigRepo`
  - Applies resolution selection (currently stubbed — passes through raw data)
  - Returns `[CaloriesChart, ResolutionPicker]` wrapped in ExpansionTile

To complete: toggle to Act mode and I'll wire up stats_screen.dart with the service call and provider integration.
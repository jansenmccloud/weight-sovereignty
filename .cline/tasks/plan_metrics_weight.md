# plan metrics weight

I've examined the data model and repository interface. Here's what I found:

## Data Model

- `DailyLog.bodyWeight` (double?) — the weight measurement
- `DailyLog.date` (DateTime?, indexed) — the calendar day
- Query method exists: `queryByDateRange(DateTime start, DateTime end)`

## Plan for `_weightWidgets()`

### 1. Rolling Averages (7/14/30 days)
Straightforward — query the repo for the respective date ranges and compute averages from `bodyWeight`:

```dart
List<ListTile> _weightWidgets() {
  final now = DateTime.now();
  final recentLogs = await ref.read(dailyLogRepositoryProvider).queryByDateRange(
    now.subtract(const Duration(days: 30)), now);
  
  // Compute 7/14/30-day averages from the sorted results
}
```

### 2. Weight Diagram — Two Options

**Option A: Custom `CustomPaint` widget (recommended)**
- Draw a simple line chart using Flutter's `Canvas` API
- Dark background, single accent color line + dots for data points
- X-axis: dates, Y-axis: weight values
- No new dependencies — aligns with project philosophy
- Full control over dark theme styling

**Option B: Add `fl_chart` package**
- Popular, feature-rich Flutter charting library
- Requires adding dependency + running code gen
- More polished out-of-the-box, but heavier

### Recommended Approach

Go with **Option A** (custom `CustomPaint`). Reasons:
- Project constraints emphasize minimal dependencies and dark-first design
- A weight progression chart is simple enough to implement custom (line + dots)
- Matches the "industrial/calm" aesthetic — no gamified colors or chrome
- No dependency overhead for a single use case

### Implementation Steps

1. Query daily logs for last 30 days via `queryByDateRange`
2. Sort by date, extract `(date, bodyWeight)` pairs (skip null weights)
3. Compute averages for 7/14/30 day windows
4. Build a custom `WeightChart` widget using `CustomPaint`:
   - Near-black background matching workout session style
   - White/gray line with dots at each data point
   - Y-axis labels on the left (weight values)
   - X-axis labels every 5-7 days (dates)
   - Optional: dashed line showing trend/average

# Summarized plan

I have all the information needed. Here's the complete implementation plan:

## Final Plan

### 1. Metrics (above chart)
- Query last 30 days of logs via `dailyLogRepositoryProvider.queryByDateRange`
- Compute rolling averages for 7/14/30 days from non-null `bodyWeight` values
- Display as 3 `ListTile` widgets with icons

### 2. WeightChart (custom `CustomPaint`)
- Single file: `lib/src/presentation/widgets/weight_chart.dart`
- Inputs: list of `(date, weight)` pairs, chart dimensions
- Renders: near-black background, white line + dots, Y-axis labels (weight), X-axis labels (dates)
- Includes a dashed horizontal line for the overall average

### 3. Integration
- Replace `_weightWidgets()` to return metrics + `WeightChart` widget
- Use `FutureBuilder` pattern like `_dailyLogsWidgets()` already does

No new dependencies needed. The implementation follows the existing code patterns in this file (ExpansionTile, ListTile, ref.watch).

Ready to implement — toggle to **Act mode** and I'll build it.
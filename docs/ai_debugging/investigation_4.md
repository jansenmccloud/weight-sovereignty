## Bug Analysis: X-axis Labels Not Showing Below Each Data Point

### Root Cause

Both charts share the same conceptual approach but have different implementations of the same underlying flaw.

---

### calories_chart.dart (line ~305-320)

```dart
final dateSteps = dataPoints.length > 7 ? (dataPoints.length > 31 ? 6 : 5) : dataPoints.length;
final step = (dataPoints.length - 1) / (dateSteps < 2 ? 1 : dateSteps);

for (int i = 0; i <= dataPoints.length; i++) {           // ← BUG 1: iterates too far
  final idx = (i * step).toInt().clamp(0, dataPoints.length - 1);
  ...
}
```

**Problems:**
1. **Loop runs to `dataPoints.length` instead of `dateSteps`**: When you have few data points (e.g., 3), `dateSteps = 3`, so the loop iterates 4 times. The computed indices `i * step` produce `0, 1, 2, 3` — all valid. So labels appear at every point, but when there are MORE data points (e.g., 10), `step = (10-1)/5 = 1.8`, producing indices `0, 1, 3, 5, 7, 9, ...` — many labels skip around unpredictably.
2. **No guard on `i * step < dataPoints.length`**: The loop blindly iterates beyond valid index range, relying solely on `.clamp()` which silently masks out-of-bounds indices.
3. **Label overlap**: For large datasets with `step > 1`, consecutive `i * step` values may map to the same integer index, causing duplicate labels at the same position.

---

### weight_chart.dart (line ~185-200)

```dart
final dateSteps = sorted.length > 7 ? 6 : sorted.length;
final step = (sorted.length - 1) / (dateSteps < 2 ? 1 : dateSteps);
for (int i = 0; i <= dateSteps && i * step < sorted.length; i++) {   // Has guard, but...
  final idx = (i * step).toInt().clamp(0, sorted.length - 1);
  ...
}
```

**Problems:**
1. **The guard `i * step < sorted.length` is correct but the logic is still off**: With 7 data points, `dateSteps = 6`, `step = 6/6 = 1`. Loop runs for `i = 0..6`, producing indices `0, 1, 2, 3, 4, 5, 6` — exactly 7 labels (one per point). This works.
2. **With >7 data points**: `dateSteps = 6` always, but `step = (sorted.length - 1) / 6`. For 10 points, `step = 1.5`, producing indices `0, 1, 3, 4, 6, 7, 9` — 7 labels for 10 points. Labels appear at non-uniform intervals, not "below each data point."
3. **The user's expectation is "label below each data point"** but the code intentionally subsamples to `dateSteps` labels. The current implementation may be intentional for sparse labeling — the question is whether it fails to show ANY label in certain test cases.

---

### Specific Failure Scenarios During Testing

| Scenario | calories_chart.dart | weight_chart.dart |
|----------|---------------------|-------------------|
| **2 data points** | `dateSteps=2`, `step=1/2=0.5`, loop 0..4 → indices `0,0,1,1,1` — duplicates at same spot | `dateSteps=2`, `step=1`, loop 0..2 → indices `0,1,2→clamped to 1` — last label overlaps second point |
| **1 data point** | `dateSteps=1`, `step=0/1=0`, all indices = 0 → single label duplicated | `dateSteps=1`, `step=0`, division safe → index 0 repeated |
| **Exactly 7 data points** | Works correctly (labels at every point) | Works correctly |
| **8 data points** | `dateSteps=6`, step=0.875, loop 0..8 → indices jump around unpredictably | `dateSteps=6`, step=1.0, shows 7 of 8 labels — one missing |

---

### Plan to Fix

**Option A: Label every data point** (if that's the user's intent)
- Remove `dateSteps` logic entirely
- Loop `for (int i = 0; i < dataPoints.length; i++)` directly
- Add rotation/overflow handling for crowded labels

**Option B: Keep sparse labeling but fix the loop bounds**
- calories_chart.dart: Change loop to `i <= dateSteps` AND add guard `i * step < dataPoints.length`
- weight_chart.dart: Already has guard, just verify correctness

**Option C: Smart adaptive labeling** (recommended)
- Use proper tick generation logic that accounts for chart width in pixels
- Avoid overlapping labels by checking text width vs available space
- Show labels at meaningful intervals (1st, 7th, 14th... or at least every N pixels)

---

### Questions for Clarification

1. Do you want a label **below every data point**, or **every N points** to avoid overlap?
2. In what test scenario did the labels fail to show? (How many data points? What date range?)
3. Should labels rotate vertically when they'd overlap?

Once you clarify, I can produce the precise fix.
Good — now I have a solid picture of the current state. Let me lay out where we stand and what's left.

## Current State Summary

**Completed:**
- ✅ Config presets UI (Food, Exercise, Workout, DailyLog CRUD screens)
- ✅ Shared widgets (`AsyncListScaffold`, `ConfigListTile`, `ConfigFormScaffold`)
- ✅ Settings hub with four CRUD flows
- ✅ Repository layer for all configs
- ✅ `getOrCreateForDay` exists in repository but **does NOT use BMR preset** (just creates empty DailyLog)
- ✅ App shell with HomeShellScreen → Settings

**Not yet implemented (remaining tasks):**

| Task | Priority | Notes |
|------|----------|-------|
| **Dashboard screen** | High — the main app screen | Shows today's DailyLog: weight, macros, BMR baseline, Δ calories, food list, workout summary |
| **Morning weight flow** | High — per dev.md step 2 | If no weight for today → show large numeric input; user taps save in <3s |
| **DailyLog calculation logic** | Critical TODO on `hasImplementedCalculation = true` placeholder | Recompute `Calculation` from linked `foodIds` + `workoutIds` before save |
| **Food add flow on dashboard** | Medium — tap [+ Food] → recent/favorites from `FoodConfig` | Uses `foodConfigListProvider` to pick favorite food, creates `Food` entity |
| **Workout session screen** | Medium — full-screen workout mode with dynamic sets | Separate screen; taps preset from dashboard or settings |
| **App startup: silent DailyLog creation** | Low — auto-create today's log on date change | Called from HomeShellScreen/MaterialApp init |

---

## Next Steps Options (pick one)

### Option A: Dashboard + Morning Weight (recommended — highest impact first)
Build the core daily tracking experience:
1. Implement `getOrCreateForDay` that creates a DailyLog from `DailyLogConfig` BMR preset
2. Implement `calculationForToday()` service to aggregate food/workout calories + update Calculation on DailyLog
3. Create `dashboard_screen.dart` — shows today's DailyLog card (BMR, Δ calories, macros, weight input if missing)
4. Create `morning_weight_screen.dart` — large numeric field for daily weight entry with fast save
5. Wire up with a new `DailyLogService` use case + Riverpod providers
6. Replace HomeShellScreen → Dashboard as default home

### Option B: Workout Session Screen
Build the workout flow (full-screen mode, dynamic sets):
1. Create `workout_session_screen.dart` with add/edit/complete set rows
2. Implement workout timer logic (rest timer between sets)
3. Wire up to existing `WorkoutConfig` presets

### Option C: DailyLog Calculation Engine First
Focus on the backend math before UI:
1. Implement calculation aggregation from `Food` → macros + calories
2. Implement MET/burn calculation from `Workout` entities
3. Add `recalculateAndSaveDailyLog(DailyLog)` in a service layer
4. Update DailyLogRepository to call this before persist

---

**Recommendation:** Start with **Option A** (Dashboard + Morning Weight) — it covers the core daily loop: wake up → log weight → see today's macro dashboard. This is also what the dev.md identifies as Steps 1–2 of the primary user flow.

Which option would you like to tackle first?
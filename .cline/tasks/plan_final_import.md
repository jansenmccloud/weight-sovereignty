## Final Plan: Config Preset Import

### What it does
Imports config presets (food, exercise, workout, daily log) from a JSON file exported by the app's existing `ExportService.toConfigJson()`. Entries with matching `name` overwrite existing ones; unique names create new entries.

---

### 1. Add `fromConfigJson()` to `ExportService`

**File:** `flutter/weight_sovereignty/lib/src/application/export_service.dart`

```dart
/// Import config presets from a JSON string (opposite of toConfigJson).
/// Overwrites entries with the same name, creates new entries for unique names.
/// Returns a summary map with counts per type.
Future<Map<String, dynamic>> fromConfigJson(String json) async {
  final Map<String, dynamic> data = jsonDecode(json);
  
  // Validate format and version
  if (data['exportFormat'] != 'weight_sovereignty_config') {
    throw FormatException('Invalid export format');
  }
  
  int total = 0;
  
  for (final Map<String, dynamic> item in List<dynamic>.from(data['foodConfigs'] ?? [])) {
    final entity = FoodConfig()
      ..name = item['name']
      ..intakeCaloriesKcal = item['intakeCaloriesKcal']
      ..intakeProteinG = item['intakeProteinG']
      ..intakeCarbsG = item['intakeCarbsG']
      ..intakeFatG = item['intakeFatG']
      ..amountG = item['amountG']
      ..favorite = item['favorite'];
    await foodConfigRepo.save(entity);
    total++;
  }
  
  // Repeat for exerciseConfigs, workoutConfigs, dailyLogConfigs (same pattern as _entityMap reverse)
  
  return {'food': ..., 'exercise': ..., 'workout': ..., 'dailyLog': ..., 'total': total};
}
```

Key: relies on Isar's unique `name` index with `replace: true` for upsert behavior.

---

### 2. Create `ImportScreen`

**File:** `flutter/weight_sovereignty/lib/src/presentation/screens/settings/import_screen.dart`

Flow (3 steps, vertical layout):
1. **File picker** — `FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json'])` → show filename
2. **Preview** — parse JSON, display counts per config type (e.g., "Will import: 5 foods, 12 exercises")
3. **Confirmation + Import** — button with hint "Imported entries will overwrite existing entries with the same name" → call `ExportService.fromConfigJson()` → show result status text

---

### 3. Wire into Settings Hub

**File:** `flutter/weight_sovereignty/lib/src/presentation/screens/settings/settings_hub_screen.dart`

Add a `ListTile` below "Data export":
```dart
ListTile(
  leading: const Icon(Icons.file_download_outlined, color: AppTheme.white),
  title: const Text('Import config presets', style: TextStyle(color: AppTheme.white)),
  subtitle: const Text('Import presets from JSON backup', style: TextStyle(color: AppTheme.grey)),
  onTap: () => _open(context, const ImportScreen()),
),
```

---

### Files changed (3 files)
| File | Change |
|------|--------|
| `lib/src/application/export_service.dart` | Add `fromConfigJson()` method |
| `lib/src/presentation/screens/settings/import_screen.dart` | New file |
| `lib/src/presentation/screens/settings/settings_hub_screen.dart` | Add import ListTile entry |
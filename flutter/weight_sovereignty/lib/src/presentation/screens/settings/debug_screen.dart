import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:weight_sovereignty/src/application/providers/providers.dart';
import 'package:weight_sovereignty/src/domain/config/dailylog_config.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';
import 'package:weight_sovereignty/src/domain/config/food_config.dart';
import 'package:weight_sovereignty/src/domain/config/workout_config.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/domain/entity/food.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

class DebugScreen extends ConsumerStatefulWidget {
  const DebugScreen({super.key});

  @override
  ConsumerState<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends ConsumerState<DebugScreen> {
  String? _selectedEntity;
  String _entriesText = '';
  bool _loading = false;

  final List<String> _entityTypes = const ['DailyLog', 'Food', 'Workout', 'DailyLogConfig', 'FoodConfig', 'WorkoutConfig', 'ExerciseConfig'];

  @override
  Widget build(BuildContext context) {
    final isarAsync = ref.watch(isarProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Debug')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Flexible(
                  child: DropdownButton<String>(
                    value: _selectedEntity,
                    dropdownColor: AppTheme.surface,
                    items: _entityTypes
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, style: const TextStyle(color: AppTheme.white)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null && isarAsync.hasValue) {
                        _loadEntries(isarAsync.value!, value);
                      }
                      setState(() => _selectedEntity = value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                if (_selectedEntity == 'DailyLog') ...[
                  const SizedBox(width: 16, height: 36, child: VerticalDivider(color: AppTheme.grey, thickness: 1)),
                  TextButton.icon(
                    onPressed: _loading ? null : _deleteAllDailyLogs,
                    icon: const Icon(Icons.delete_sweep_outlined, color: AppTheme.red, size: 18),
                    label: const Text('Delete All DailyLogs', style: TextStyle(color: AppTheme.red)),
                  ),
                ],
                if (_selectedEntity == 'Food') ...[
                  const SizedBox(width: 16, height: 36, child: VerticalDivider(color: AppTheme.grey, thickness: 1)),
                  TextButton.icon(
                    onPressed: _loading ? null : _deleteAllFoods,
                    icon: const Icon(Icons.delete_sweep_outlined, color: AppTheme.red, size: 18),
                    label: const Text('Delete All Foods', style: TextStyle(color: AppTheme.red)),
                  ),
                ],
                if (_selectedEntity == 'Workout') ...[
                  const SizedBox(width: 16, height: 36, child: VerticalDivider(color: AppTheme.grey, thickness: 1)),
                  TextButton.icon(
                    onPressed: _loading ? null : _deleteAllWorkouts,
                    icon: const Icon(Icons.delete_sweep_outlined, color: AppTheme.red, size: 18),
                    label: const Text('Delete All Workouts', style: TextStyle(color: AppTheme.red)),
                  ),
                ],
                if (_loading) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.white)),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.grey,
                  border: Border.all(color: AppTheme.surface),
                ),
                child: _entriesText.isEmpty
                    ? const Center(
                        child: Text('...', style: TextStyle(color: AppTheme.grey)),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(8),
                        child: SelectableText(
                          _entriesText,
                          style: const TextStyle(color: AppTheme.white, fontFamily: 'monospace', fontSize: 12),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadEntries(Isar isar, String entityName) async {
    setState(() {
      _loading = true;
      _entriesText = '';
    });

    try {
      late final List<dynamic> entries;

      switch (entityName) {
        case 'DailyLog':
          entries = await isar.collection<DailyLog>().where().findAll();
          break;
        case 'Food':
          entries = await isar.collection<Food>().where().findAll();
          break;
        case 'Workout':
          entries = await isar.collection<Workout>().where().findAll();
          break;
        case 'DailyLogConfig':
          entries = await isar.collection<DailyLogConfig>().where().findAll();
          break;
        case 'FoodConfig':
          entries = await isar.collection<FoodConfig>().where().findAll();
          break;
        case 'WorkoutConfig':
          entries = await isar.collection<WorkoutConfig>().where().findAll();
          break;
        case 'ExerciseConfig':
          entries = await isar.collection<ExerciseConfig>().where().findAll();
          break;
        default:
          throw UnimplementedError(entityName);
      }

      final formatter = _EntityFormatter();
      String formatted;
      try {
        formatted = entries.map((e) => formatter.format(e)).join('\n\n');
      } catch (_) {
        formatted = entries.map((e) => e.toString()).join('\n\n');
      }
      setState(() {
        _entriesText = formatted.isEmpty ? '(no entries)' : formatted;
      });
    } catch (e) {
      setState(() {
        _entriesText = 'Error: $e';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteAllWorkouts() async {
    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete all Workout entries?'),
        content: const Text('This will permanently remove all workout entries. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final isarAsync = ref.read(isarProvider);
    if (!isarAsync.hasValue) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Database not ready')));
      }
      return;
    }

    final isar = isarAsync.value!;
    await isar.writeTxn(() => isar.collection<Workout>().clear());

    if (!mounted) return;
    setState(() {
      _entriesText = '(all Workout entries deleted)';
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All Workout entries cleared')));
  }

  Future<void> _deleteAllFoods() async {
    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete all Food entries?'),
        content: const Text('This will permanently remove all food entries. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final isarAsync = ref.read(isarProvider);
    if (!isarAsync.hasValue) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Database not ready')));
      }
      return;
    }

    final isar = isarAsync.value!;
    await isar.writeTxn(() => isar.collection<Food>().clear());

    if (!mounted) return;
    setState(() {
      _entriesText = '(all Food entries deleted)';
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All Food entries cleared')));
  }

  Future<void> _deleteAllDailyLogs() async {
    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete all DailyLogs?'),
        content: const Text('This will permanently remove all daily log entries. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final isarAsync = ref.read(isarProvider);
    if (!isarAsync.hasValue) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Database not ready')));
      }
      return;
    }

    final isar = isarAsync.value!;
    await isar.writeTxn(() => isar.collection<DailyLog>().clear());

    if (!mounted) return;
    setState(() {
      _entriesText = '(all DailyLogs deleted)';
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All DailyLogs cleared')));
  }
}

class _EntityFormatter {
  String format(dynamic entry) {
    final type = entry.runtimeType;
    if (type == DailyLog) return _formatDailyLog(entry as DailyLog);
    if (type == Food) return _formatFood(entry as Food);
    if (type == Workout) return _formatWorkout(entry as Workout);
    if (type == DailyLogConfig) return _formatDailyLogConfig(entry as DailyLogConfig);
    if (type == FoodConfig) return _formatFoodConfig(entry as FoodConfig);
    if (type == WorkoutConfig) return _formatWorkoutConfig(entry as WorkoutConfig);
    if (type == ExerciseConfig) return _formatExerciseConfig(entry as ExerciseConfig);
    // Fallback: use reflection-like field access via dart:mirrors is not available, use dynamic Map
    return entry.toString();
  }

  String _kv(String label, dynamic value) {
    final v = value == null ? '(null)' : value.toString();
    return '  $label: $v\n';
  }

  String _formatDailyLog(DailyLog e) {
    return 'DailyLog(id=${e.id}\n'
        '${_kv('date', e.date?.toLocal())}'
        '${_kv('bodyWeight', e.bodyWeight != null ? '${e.bodyWeight} kg' : '(null)')}'
        '${_kv('bmrCaloriesKcal', e.dailyLogBase?.bmrCaloriesKcal)}'
        '${_kv('name', e.dailyLogBase?.name)}'
        '${_kv('totalBurnedCaloriesKcal', e.calculation?.totalBurnedCaloriesKcal)}'
        '${_kv('totalIntakeCaloriesKcal', e.calculation?.totalIntakeCaloriesKcal)}'
        '${_kv('totalIntakeProteinG', e.calculation?.totalIntakeProteinG)}'
        '${_kv('totalIntakeCarbsG', e.calculation?.totalIntakeCarbsG)}'
        '${_kv('totalIntakeFatG', e.calculation?.totalIntakeFatG)}'
        ')';
  }

  String _formatFood(Food e) {
    final base = e.foodBase;
    return 'Food(id=${e.id}, date=${e.date?.toLocal()}\n'
        '${_kv('name', base?.name)}'
        '${_kv('favorite', base?.favorite)}'
        '${_kv('caloriesKcal', base?.intakeCaloriesKcal)}'
        '${_kv('proteinG', base?.intakeProteinG)}'
        '${_kv('carbsG', base?.intakeCarbsG)}'
        '${_kv('fatG', base?.intakeFatG)}'
        '${_kv('amountG', base?.amountG)}';
  }

  String _formatWorkout(Workout e) {
    final base = e.workoutBase;
    final exerciseLines = ((e.exercises ?? []).where((ex) => ex != null))
        .map((ex) {
          final eb = ex as ExerciseBase;
          final name = eb.name ?? '(null)';
          final category = eb.categoryName ?? '(null)';
          final sets = eb.sets?.length ?? '(null)';
          final reps = eb.sets?[0]?.reps ?? '(null)';
          final kg = eb.sets?[0]?.weightKg ?? '(null)';
          final calories = eb.burnedCaloriesKcal ?? '(null)';
          return '  - $name ($category) reps=$reps sets=$sets kg=$kg calories=$calories';
        })
        .join('\n');
    return 'Workout(id=${e.id}, date=${e.date?.toLocal()}\n'
        '${_kv('name', base?.name)}'
        '  exercises:\n$exerciseLines)';
  }

  String _formatDailyLogConfig(DailyLogConfig e) {
    return 'DailyLogConfig(id=${e.id}, name=${e.name}, bmrCaloriesKcal=${e.bmrCaloriesKcal})';
  }

  String _formatFoodConfig(FoodConfig e) {
    return 'FoodConfig(id=${e.id}, name=${e.name}, favorite=${e.favorite}, calories=${e.intakeCaloriesKcal}, protein=${e.intakeProteinG}, carbs=${e.intakeCarbsG}, fat=${e.intakeFatG}, amountG=${e.amountG})';
  }

  String _formatWorkoutConfig(WorkoutConfig e) {
    return 'WorkoutConfig(id=${e.id}, name=${e.name}, exercisePresetIds=${e.exercisePresetNames})';
  }

  String _formatExerciseConfig(ExerciseConfig e) {
    return 'ExerciseConfig(id=${e.id}, name=${e.name}, category=${e.category.name}, type=${e.type.name}, level=${e.intensityLevel.name}, weightKg=${e.weightKg}, reps=${e.reps}, sets=${e.sets}, distanceKm=${e.distanceKm}, durationMin=${e.durationMin}, cal=${e.burnedCaloriesKcal})';
  }
}

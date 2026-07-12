import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/domain/config/dailylog_config.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/domain/entity/food.dart';
import 'package:weight_sovereignty/src/domain/repo/dailylog_config_repo.dart';
import 'package:weight_sovereignty/src/domain/repo/dailylog_repo.dart';
import 'package:weight_sovereignty/src/domain/repo/food_repo.dart';
import 'package:weight_sovereignty/src/domain/repo/workout_repo.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart';

/// Provider for DailyLogService.
final dailyLogServiceProvider = Provider<DailyLogService>((ref) {
  return DailyLogService(ref);
});

/// Service for DailyLog use cases.
/// - Create a new DailyLog from a BMR preset (DailyLogConfig)
/// - Save body weight
/// - Recalculate Calculation from daily food/workout
class DailyLogService {
  final Ref ref;

  DailyLogService(this.ref);

  DailyLogConfigRepository get _dailyLogConfigRepo =>
      ref.read(dailyLogConfigRepositoryProvider);

  DailyLogRepository get _dailyLogRepo => ref.read(dailyLogRepositoryProvider);
  FoodRepository get _foodRepo => ref.read(foodRepositoryProvider);
  WorkoutRepository get _workoutRepo => ref.read(workoutRepositoryProvider);

  /// Get today's DailyLog or silently create one with BMR from first profile or default
  Future<DailyLog> getOrCreateForDay(DateTime day) async {
    final todayLog = await getForDay(day);
    if (todayLog != null) return todayLog;
    return createForDay(day);
  }

  /// Get today's DailyLog
  Future<DailyLog?> getForDay(DateTime day) async {
    return _dailyLogRepo.getByCalendarDay(day);
  }

  /// Create a new DailyLog for [day] with BMR from first profile or default.
  /// Uses upsert to ensure exactly one entry per calendar day.
  Future<DailyLog> createForDay(DateTime day) async {
    // take BMR from profile
    var bmrPreset = DailyLogConfig()
      ..name = 'Default'
      ..bmrCaloriesKcal = 2000
      ..plannedDeficitKcal = 0;

    final config = await _dailyLogConfigRepo.getAll();
    if (config.isNotEmpty && config.first.bmrCaloriesKcal != null) {
      bmrPreset = config.first;
    }

    final log = DailyLog()
      ..setBase = bmrPreset
      ..bodyWeight = 90.0;

    // take bodyweight from day before if existing
    final yesterday = day.subtract(const Duration(days: 1));
    final yesterdayLog = await _dailyLogRepo.getByCalendarDay(yesterday);
    if (yesterdayLog != null && yesterdayLog.bodyWeight != null) {
      log.bodyWeight = yesterdayLog.bodyWeight;
    }

    return await _dailyLogRepo.upsertByCalendarDay(day, log);
  }

  /// Save body weight [weightKg] to an existing DailyLog.
  /// Uses upsert by calendar day to prevent duplicates.
  Future<DailyLog> saveBodyWeight(DailyLog log, double weightKg) async {
    log.bodyWeight = weightKg;
    log.date ??= DateTime.now();
    return await _dailyLogRepo.upsertByCalendarDay(log.date!, log);
  }

  /// Recalculate Calculation from all foods and workouts for [day].
  /// Queries entities directly by calendar date
  /// Returns the updated Calculation to be saved on DailyLog.
  /// Does NOT write to DB — caller decides when to persist.
  Future<Calculation> recalculateFromDate(DateTime day) async {
    int totalBurned = 0;
    int totalIntake = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    // Aggregate food macros for the date.
    // Food.intake* values are already scaled by _createFoodWithAmount in AddFoodScreen,
    // so we sum them directly without any additional scaling.
    final foods = await _foodRepo.listByCalendarDay(day);
    for (final food in foods) {
      if (food.foodBase != null) {
        final base = food.foodBase!;
        totalIntake += (base.intakeCaloriesKcal ?? 0);
        totalProtein += (base.intakeProteinG ?? 0).toDouble();
        totalCarbs += (base.intakeCarbsG ?? 0).toDouble();
        totalFat += (base.intakeFatG ?? 0).toDouble();
      }
    }

    // Aggregate workout burn for the date
    final workouts = await _workoutRepo.listByCalendarDay(day);
    for (final workout in workouts) {
      if (workout.exercises != null) {
        for (final ex in workout.exercises!) {
          totalBurned += ex?.burnedCaloriesKcal ?? 0;
        }
      }
    }

    return Calculation()
      ..totalBurnedCaloriesKcal = totalBurned
      ..totalIntakeCaloriesKcal = totalIntake
      ..totalIntakeProteinG = totalProtein
      ..totalIntakeCarbsG = totalCarbs
      ..totalIntakeFatG = totalFat;
  }

  /// Delete a food entry from a specific date.
  Future<void> deleteFoodByDate(Food food, DateTime day) async {
    // Delete the food entry directly by date match
    final foods = await _foodRepo.listByCalendarDay(day);
    for (final f in foods) {
      if (f.id == food.id) {
        await _foodRepo.deleteById(f.id!);
        break;
      }
    }
  }

  /// Query foods by name for auto-complete in add food screen.
  Future<List<Food>> searchFoods(String query) async {
    if (query.isEmpty) return [];
    // Search across all config presets by name
    final allFoods = await _foodRepo.getAll();
    return allFoods
        .where(
          (f) => (f.foodBase?.name ?? '').toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
  }

  /// Full recalculate + persist pipeline.
  /// Queries all foods/workouts for the log's date, recomputes totals, persists via upsert.
  Future<DailyLog> recalculateAndSave(DailyLog log) async {
    if (log.date == null) {
      await _dailyLogRepo.save(log);
      return log;
    }
    final calculation = await recalculateFromDate(log.date!);
    log.calculation = calculation;
    return await _dailyLogRepo.upsertByCalendarDay(log.date!, log);
  }

  /// Get today's DailyLog, create if missing, and fully re-persist it (recalculate macros from all foods/workouts).
  /// Use this to refresh the dashboard after a mutation (e.g. adding food, logging weight, completing workout set).
  Future<DailyLog> refreshToday() async {
    final today = DateTime.now();
    DailyLog log = await getOrCreateForDay(today);
    return recalculateAndSave(log);
  }

  /// Get a DailyLog by date, create if missing, and fully re-persist it (recalculate macros from all foods/workouts).
  Future<DailyLog> refreshForDay(DateTime day) async {
    DailyLog log = await getOrCreateForDay(day);
    return recalculateAndSave(log);
  }
}

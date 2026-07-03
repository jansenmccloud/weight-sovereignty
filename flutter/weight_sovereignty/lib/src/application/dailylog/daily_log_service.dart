import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/domain/config/dailylog_config.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/domain/repo/dailylog_repo.dart';
import 'package:weight_sovereignty/src/domain/repo/food_repo.dart';
import 'package:weight_sovereignty/src/domain/repo/workout_repo.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart';

/// Service for DailyLog use cases.
/// - Create a new DailyLog from a BMR preset (DailyLogConfig)
/// - Save body weight
/// - Recalculate Calculation from food/workout IDs
class DailyLogService {
  final Ref ref;

  DailyLogService(this.ref);

  DailyLogRepository get _dailyLogRepo =>
      ref.read(dailyLogRepositoryProvider);
  FoodRepository get _foodRepo => ref.read(foodRepositoryProvider);
  WorkoutRepository get _workoutRepo => ref.read(workoutRepositoryProvider);

  /// Create a new DailyLog for [day] using [bmrPreset] for BMR baseline.
  Future<DailyLog> createForDay(DateTime day, DailyLogConfig bmrPreset) async {
    final log = DailyLog()
      ..date = day
      ..dailyLogBase = DailyLogBase()
        ..name = bmrPreset.name
        ..bmrCaloriesKcal = bmrPreset.bmrCaloriesKcal;
    await _dailyLogRepo.save(log);
    return log;
  }

  /// Save body weight [weightKg] to an existing DailyLog.
  Future<DailyLog> saveBodyWeight(DailyLog log, double weightKg) async {
    log.bodyWeight = weightKg;
    await _dailyLogRepo.save(log);
    return log;
  }

  /// Recalculate Calculation from linked food/workout IDs.
  /// Returns the updated Calculation to be saved on DailyLog.
  /// Does NOT write to DB — caller decides when to persist.
  Future<Calculation> recalculateDailyLog(
    List<int?> foodIds,
    List<int?> workoutIds,
  ) async {
    int totalBurned = 0;
    int totalIntake = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    // Aggregate food macros
    for (int? foodId in foodIds.whereType<int>()) {
      final food = await _foodRepo.getById(foodId);
      if (food != null && food.foodBase != null) {
        totalIntake += food.foodBase!.intakeCaloriesKcal ?? 0;
        totalProtein += food.foodBase!.intakeProteinG ?? 0;
        totalCarbs += food.foodBase!.intakeCarbsG ?? 0;
        totalFat += food.foodBase!.intakeFatG ?? 0;
      }
    }

    // Aggregate workout burn
    for (int? workoutId in workoutIds.whereType<int>()) {
      final workout = await _workoutRepo.getById(workoutId);
      if (workout != null && workout.exercises != null) {
        for (ExerciseBase? ex in workout.exercises!) {
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

  /// Full recalculate + persist pipeline.
  Future<DailyLog> recalculateAndSave(DailyLog log) async {
    final calculation = await recalculateDailyLog(
      log.foodIds ?? [],
      log.workoutIds ?? [],
    );
    log.calculation = calculation;
    await _dailyLogRepo.save(log);
    return log;
  }
}

/// Provider for DailyLogService.
final dailyLogServiceProvider = Provider<DailyLogService>((ref) {
  return DailyLogService(ref);
});
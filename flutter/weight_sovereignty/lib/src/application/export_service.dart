import 'package:weight_sovereignty/src/domain/repo/dailylog_repo.dart';
import 'package:weight_sovereignty/src/domain/repo/food_repo.dart';
import 'package:weight_sovereignty/src/domain/repo/workout_repo.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/domain/entity/food.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';

/// Generates CSV strings for exported domain models.
class ExportService {
  ExportService({required this.dailyLogRepo, required this.foodRepo, required this.workoutRepo});

  final DailyLogRepository dailyLogRepo;
  final FoodRepository foodRepo;
  final WorkoutRepository workoutRepo;

  /// Export [DailyLog] entries within the given date range as CSV (semicolon-separated for Excel compatibility).
  Future<String> toDailyLogCsv(DateTime start, DateTime end) async {
    final logs = await dailyLogRepo.queryByDateRange(start, end);
    const sep = ';';

    final buf = StringBuffer();
    // UTF-8 BOM for Excel compatibility
    buf.write('\uFEFF');

    // Header
    buf.writeln(
      [
        'date',
        'body_weight_kg',
        'bmr_calories',
        'planned_deficit_kcal',
        'planned_protein_g',
        'planned_fat_g',
        'planned_carbs_g',
        'total_burned_calories',
        'total_intake_calories',
        'total_intake_protein_g',
        'total_intake_carbs_g',
        'total_intake_fat_g',
      ].join(sep),
    );

    for (final log in logs) {
      final base = log.dailyLogBase;
      final calcs = log.calculation;
      buf.writeln(
        [
          _dateOnly(log.date),
          _fmt(log.bodyWeight),
          _fmt(base?.bmrCaloriesKcal),
          _fmt(base?.plannedDeficitKcal),
          _fmt(base?.plannedProteinG),
          _fmt(base?.plannedFatG),
          _fmt(base?.plannedCarbsG),
          _fmt(calcs?.totalBurnedCaloriesKcal),
          _fmt(calcs?.totalIntakeCaloriesKcal),
          _fmt(calcs?.totalIntakeProteinG),
          _fmt(calcs?.totalIntakeCarbsG),
          _fmt(calcs?.totalIntakeFatG),
        ].join(sep),
      );
    }

    return buf.toString();
  }

  /// Export [Food] entries within the given date range as CSV (semicolon-separated for Excel compatibility).
  Future<String> toFoodCsv(DateTime start, DateTime end) async {
    final foods = await foodRepo.queryByDateRange(start, end);
    const sep = ';';

    final buf = StringBuffer();
    buf.write('\uFEFF');

    buf.writeln(['date', 'name', 'calories', 'protein_g', 'carbs_g', 'fat_g', 'amount_g'].join(sep));

    for (final food in foods) {
      final fb = food.foodBase;
      buf.writeln([_dateOnly(food.date), _csvSafe(fb?.name ?? ''), _fmt(fb?.intakeCaloriesKcal), _fmt(fb?.intakeProteinG), _fmt(fb?.intakeCarbsG), _fmt(fb?.intakeFatG), _fmt(fb?.amountG)].join(sep));
    }

    return buf.toString();
  }

  /// Export [Workout] entries within the given date range as CSV (semicolon-separated for Excel compatibility).
  /// Each row represents one exercise set (flat structure).
  Future<String> toWorkoutCsv(DateTime start, DateTime end) async {
    final workouts = await workoutRepo.queryByDateRange(start, end);
    const sep = ';';

    final buf = StringBuffer();
    buf.write('\uFEFF');

    buf.writeln(['date', 'workout_name', 'exercise_name', 'category', 'type', 'intensity', 'weight_kg', 'reps', 'duration_min', 'distance_km', 'burned_calories'].join(sep));

    for (final workout in workouts) {
      final wb = workout.workoutBase;
      final exercises = workout.exercises ?? [];
      for (final exercise in exercises) {
        if (exercise == null) continue;
        final sets = exercise.sets ?? [];
        if (sets.isEmpty) {
          // Export exercise-level summary even without sets
          buf.writeln(
            [
              _dateOnly(workout.date),
              _csvSafe(wb?.name ?? ''),
              _csvSafe(exercise.name ?? ''),
              exercise.categoryName ?? '',
              exercise.typeName ?? '',
              exercise.intensityLevelName ?? '',
              '',
              '',
              _fmt(exercise.durationMin),
              _fmt(exercise.distanceKm),
              _fmt(exercise.burnedCaloriesKcal),
            ].join(sep),
          );
        } else {
          for (final set in sets) {
            if (set == null) continue;
            buf.writeln(
              [
                _dateOnly(workout.date),
                _csvSafe(wb?.name ?? ''),
                _csvSafe(exercise.name ?? ''),
                exercise.categoryName ?? '',
                exercise.typeName ?? '',
                exercise.intensityLevelName ?? '',
                _fmt(set.weightKg),
                _fmt(set.reps),
                _fmt(exercise.durationMin),
                _fmt(exercise.distanceKm),
                _fmt(exercise.burnedCaloriesKcal),
              ].join(sep),
            );
          }
        }
      }
    }

    return buf.toString();
  }

  /// Format a DateTime as 'yyyy-MM-dd' (calendar day only).
  String _dateOnly(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  /// Format nullable values for CSV output.
  String _fmt(Object? value) {
    if (value == null) return '';
    if (value is int) return value.toString();
    if (value is double) return value.toStringAsFixed(2);
    if (value is num) return value.toString();
    return value.toString();
  }

  /// Quote the value if it contains semicolons or double quotes to keep CSV valid.
  String _csvSafe(String value) {
    if (value.contains(';') || value.contains('"')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}

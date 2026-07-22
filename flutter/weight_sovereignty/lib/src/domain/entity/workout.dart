import 'package:isar/isar.dart';
import 'package:weight_sovereignty/src/domain/config/workout_config.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';

part 'workout.g.dart';

@collection
class Workout {
  Id id = Isar.autoIncrement;
  WorkoutBase? workoutBase;
  @Index()
  DateTime? date;
  List<ExerciseBase?>? exercises;

  @ignore
  set setBase(WorkoutConfig conf) {
    workoutBase = WorkoutBase()
      ..name = conf.name
      ..exercisePresetNames = conf.exercisePresetNames;
  }

  @ignore
  set setExercises(List<ExerciseConfig?> configs) {
    exercises = [];
    for (ExerciseConfig? c in configs) {
      if (c != null) {
        exercises!.add(ExerciseBase.fromConfig(c));
      }
    }
  }
}

@embedded
class WorkoutBase {
  String? name;
  List<String?>? exercisePresetNames;
}

@embedded
class ExerciseSet {
  int? weightKg;
  int? reps;
  bool finished = false;

  ExerciseSet copy() {
    final newE = ExerciseSet();
    newE.weightKg = weightKg;
    newE.reps = reps;
    newE.finished = finished;
    return newE;
  }
}

class CalcConstants {
  static final Map<IntensityLevel, double> metsCardio = {IntensityLevel.light: 2.9, IntensityLevel.moderate: 3.3, IntensityLevel.intense: 5.3};
  static final Map<IntensityLevel, double> metsLifting = {IntensityLevel.light: 3.5, IntensityLevel.moderate: 4.5, IntensityLevel.intense: 6.0};
  static final int timePerRepSeconds = 6;
}

@embedded
class ExerciseBase {
  String? name;
  String? categoryName;
  String? intensityLevelName;
  int? burnedCaloriesKcal;

  String? typeName;
  double? distanceKm;
  int? durationMin;
  List<ExerciseSet?>? sets;

  @ignore
  late ExerciseCategory category;

  @ignore
  late ExerciseType type;

  @ignore
  late IntensityLevel intensityLevel;

  static ExerciseBase fromConfig(ExerciseConfig c) {
    final exerciseSets = _createSet(c.weightKg, c.reps, c.sets);

    return ExerciseBase()
      ..name = c.name
      ..categoryName = c.category.name
      ..typeName = c.type.name
      ..intensityLevelName = c.intensityLevel.name
      ..sets = exerciseSets
      ..distanceKm = c.distanceKm
      ..durationMin = c.durationMin
      ..burnedCaloriesKcal = c.burnedCaloriesKcal
      ..category = c.category
      ..type = c.type
      ..intensityLevel = c.intensityLevel;
  }

  // A) Calories_burned = MET × weight (kg) × duration (h)
  // B) Calories_per_minute = (MET × 3.5 × weight(kg)) / 200
  //    Calories_burned = Calories_per_minute × minutes
  int calcAndSetBurnedCalories(double bodyWeight) {
    if (ExerciseType.getTypeFromString(typeName) == ExerciseType.lifting) {
      final met = CalcConstants.metsLifting[IntensityLevel.getIntensityLevelFromString(intensityLevelName)];
      burnedCaloriesKcal = _calculateBurnedCalories(met, bodyWeight);
    } else {
      final met = CalcConstants.metsCardio[IntensityLevel.getIntensityLevelFromString(intensityLevelName)];
      burnedCaloriesKcal = _calculateBurnedCalories(met, bodyWeight);
    }
    return burnedCaloriesKcal!;
  }

  int _calculateBurnedCalories(double? met, double bodyWeight) {
    if (met == null || durationMin == null) {
      return 0;
    }
    final burned = ((met * 3.5 * bodyWeight) / 200.0) * durationMin!.toDouble();
    return burned.ceil();
  }
}

List<ExerciseSet>? _createSet(int? weightKg, int? reps, int? sets) {
  if (sets == null) {
    return null;
  }
  final newEntries = <ExerciseSet>[];
  for (var i = 0; i < sets; i++) {
    newEntries.add(
      ExerciseSet()
        ..reps = reps
        ..weightKg = weightKg,
    );
  }
  return newEntries;
}

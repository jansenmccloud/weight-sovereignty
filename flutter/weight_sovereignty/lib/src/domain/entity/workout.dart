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

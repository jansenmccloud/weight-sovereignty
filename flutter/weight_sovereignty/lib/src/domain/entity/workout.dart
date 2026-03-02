import 'package:isar/isar.dart';
import 'package:weight_sovereignty/src/domain/config/workout_config.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';

part 'workout.g.dart';

@collection
class Workout {
  Id id = Isar.autoIncrement;
  WorkoutBase? workoutBase;
  DateTime? date;
  List<ExerciseBase?>? exercises;

  @ignore
  set setBase(WorkoutConfig conf) {
    workoutBase = WorkoutBase()
      ..name = conf.name
      ..exercisePresetIds = conf.exercisePresetIds;
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
  List<String?>? exercisePresetIds;
}

@embedded
class ExerciseBase {
  String? name;
  String? categoryName;
  String? typeName;
  String? intensityLevelName;
  int? weightKg;
  int? reps;
  int? sets;
  double? distanceKm;
  int? durationMin;
  int? burnedCaloriesKcal;

  @ignore
  late ExerciseCategory category;

  @ignore
  late ExerciseType type;

  @ignore
  late IntensityLevel intensityLevel;

  static ExerciseBase fromConfig(ExerciseConfig c) {
    return ExerciseBase()
      ..name = c.name
      ..categoryName = c.categoryName
      ..typeName = c.typeName
      ..intensityLevelName = c.intensityLevelName
      ..weightKg = c.weightKg
      ..reps = c.reps
      ..sets = c.sets
      ..distanceKm = c.distanceKm
      ..durationMin = c.durationMin
      ..burnedCaloriesKcal = c.burnedCaloriesKcal
      ..category = c.category
      ..type = c.type
      ..intensityLevel = c.intensityLevel;
  }
}

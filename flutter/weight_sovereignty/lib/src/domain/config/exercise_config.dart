import 'package:isar/isar.dart';

part 'exercise_config.g.dart';

enum ExerciseCategory {
  none,
  back,
  arms,
  chest,
  legs,
  shoulders;

  static ExerciseCategory getCategoryFromString(String? s) {
    if (s == null) return ExerciseCategory.none;
    for (final ExerciseCategory c in ExerciseCategory.values) {
      if (c.name == s) return c;
    }
    return ExerciseCategory.none;
  }
}

enum ExerciseType {
  cardio,
  lifting;

  static ExerciseType getTypeFromString(String? s) {
    if (s == null) return ExerciseType.cardio;
    for (final ExerciseType t in ExerciseType.values) {
      if (t.name == s) return t;
    }
    return ExerciseType.cardio;
  }
}

enum IntensityLevel {
  light,
  moderate,
  intense;

  static IntensityLevel getIntensityLevelFromString(String? s) {
    if (s == null) return IntensityLevel.moderate;
    for (final IntensityLevel i in IntensityLevel.values) {
      if (i.name == s) return i;
    }
    return IntensityLevel.moderate;
  }
}

@collection
class ExerciseConfig {
  Id id = Isar.autoIncrement;
  @Index(unique: true, caseSensitive: false, replace: true)
  String? name;
  @Index()
  String? categoryName;
  @Index()
  String? typeName;
  @Index()
  String? intensityLevelName;

  int? weightKg;
  int? reps;
  int? sets;
  double? distanceKm;
  int? durationMin;
  int? burnedCaloriesKcal;

  @ignore
  ExerciseCategory get category => ExerciseCategory.getCategoryFromString(categoryName);

  @ignore
  ExerciseType get type => ExerciseType.getTypeFromString(typeName);

  @ignore
  IntensityLevel get intensityLevel => IntensityLevel.getIntensityLevelFromString(intensityLevelName);
}

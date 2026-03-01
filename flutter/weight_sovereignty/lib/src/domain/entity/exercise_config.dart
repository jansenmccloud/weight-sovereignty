import 'package:equatable/equatable.dart';

enum Category {
  none,
  back,
  arms,
  chest,
  legs,
  shoulders;

  static Category getCategoryFromString(String s) {
    for (Category c in Category.values) {
      if (c.toString() == s) {
        return c;
      }
    }
    return Category.none;
  }
}

enum Type {
  cardio,
  lifting;

  static Type getTypeFromString(String s) {
    for (Type t in Type.values) {
      if (t.toString() == s) {
        return t;
      }
    }
    return Type.cardio;
  }
}

enum IntensityLevel {
  light,
  moderate,
  intense;

  static IntensityLevel getIntensityLevelFromString(String s) {
    for (IntensityLevel i in IntensityLevel.values) {
      if (i.toString() == s) {
        return i;
      }
    }
    return IntensityLevel.moderate;
  }
}

class ExerciseConfig with EquatableMixin {
  ExerciseConfig({
    this.id,
    this.name,
    this.category,
    this.type,
    this.intensityLevel,
    this.weightKg,
    this.reps,
    this.sets,
    this.distanceKm,
    this.durationMin,
    this.burnedCaloriesKcal,
  });

  final int? id;
  final String? name;
  final Category? category;
  final Type? type;
  final IntensityLevel? intensityLevel;
  final int? weightKg;
  final int? reps;
  final int? sets;
  final double? distanceKm;
  final int? durationMin;
  final int? burnedCaloriesKcal;

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    type,
    intensityLevel,
    weightKg,
    reps,
    sets,
    distanceKm,
    durationMin,
    burnedCaloriesKcal,
  ];
}

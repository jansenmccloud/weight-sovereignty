import 'dart:convert';
import 'package:weight_sovereignty/src/domain/entity/exercise_config.dart';

class ExerciseConfigDto extends ExerciseConfig {
  ExerciseConfigDto({
    super.id,
    super.name,
    super.category,
    super.type,
    super.intensityLevel,
    super.weightKg,
    super.reps,
    super.sets,
    super.distanceKm,
    super.durationMin,
    super.burnedCaloriesKcal,
  });

  factory ExerciseConfigDto.fromRawJson(String str) =>
      ExerciseConfigDto.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory ExerciseConfigDto.fromMap(Map<String, dynamic> json) =>
      ExerciseConfigDto(
        id: json['id'],
        name: json['name'],
        category: Category.getCategoryFromString(json['category']),
        type: Type.getTypeFromString(json['type']),
        intensityLevel: IntensityLevel.getIntensityLevelFromString(
          json['intensityLevel'],
        ),
        weightKg: json['weightKg'],
        reps: json['reps'],
        sets: json['sets'],
        distanceKm: json['distanceKm'],
        durationMin: json['durationMin'],
        burnedCaloriesKcal: json['burnedCaloriesKcal'],
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'category': category.toString(),
    'type': type.toString(),
    'intensityLevel': intensityLevel.toString(),
    'weightKg': weightKg,
    'reps': reps,
    'sets': sets,
    'distanceKm': distanceKm,
    'durationMin': durationMin,
    'burnedCaloriesKcal': burnedCaloriesKcal,
  };

  static ExerciseConfigDto fromExerciseConfig(ExerciseConfig e) {
    return ExerciseConfigDto(
      id: e.id,
      name: e.name,
      category: e.category,
      type: e.type,
      intensityLevel: e.intensityLevel,
      weightKg: e.weightKg,
      reps: e.reps,
      sets: e.sets,
      distanceKm: e.distanceKm,
      durationMin: e.durationMin,
      burnedCaloriesKcal: e.burnedCaloriesKcal,
    );
  }

  ExerciseConfig toExerciseConfig() {
    return ExerciseConfig(
      id: id,
      name: name,
      category: category,
      type: type,
      intensityLevel: intensityLevel,
      weightKg: weightKg,
      reps: reps,
      sets: sets,
      distanceKm: distanceKm,
      durationMin: durationMin,
      burnedCaloriesKcal: burnedCaloriesKcal,
    );
  }
}

import 'dart:convert';
import 'package:weight_sovereignty/src/data/dto/exercise_config_dto.dart';
import 'package:weight_sovereignty/src/domain/entity/workout_config.dart';

import '../../domain/entity/exercise_config.dart';

class WorkoutConfigDto extends WorkoutConfig {
  WorkoutConfigDto({super.id, super.name, super.exercises});

  factory WorkoutConfigDto.fromRawJson(String str) =>
      WorkoutConfigDto.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory WorkoutConfigDto.fromMap(Map<String, dynamic> json) =>
      WorkoutConfigDto(
        id: json['id'],
        name: json['name'],
        exercises: json['exercises'] == null
            ? []
            : List<ExerciseConfigDto>.from(
                json['exercises']!.map(
                  (dynamic x) => ExerciseConfigDto.fromMap(x),
                ),
              ),
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'exercises': exercises == null
        ? []
        : List<dynamic>.from(
            exercises!.map((x) => ExerciseConfigDto.fromExerciseConfig(x!)),
          ),
  };

  static WorkoutConfigDto fromWorkoutConfig(WorkoutConfig w) {
    return WorkoutConfigDto(
      id: w.id,
      name: w.name,
      exercises: w.exercises == null
          ? []
          : List<ExerciseConfigDto>.from(
              w.exercises!.map((x) => ExerciseConfigDto.fromExerciseConfig(x!)),
            ),
    );
  }

  WorkoutConfig toWorkoutConfig() {
    List<ExerciseConfigDto?>? d = exercises as List<ExerciseConfigDto?>?;
    return WorkoutConfig(
      id: id,
      name: name,
      exercises: d == null
          ? []
          : List<ExerciseConfig>.from(d.map((x) => x!.toExerciseConfig())),
    );
  }
}

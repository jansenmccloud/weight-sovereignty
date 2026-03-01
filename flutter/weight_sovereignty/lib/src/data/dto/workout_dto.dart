import 'dart:convert';
import 'package:weight_sovereignty/src/data/dto/workout_config_dto.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';

class WorkoutDto extends Workout {
  WorkoutDto({super.id, super.workoutConfig, super.date});

  factory WorkoutDto.fromRawJson(String str) =>
      WorkoutDto.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory WorkoutDto.fromMap(Map<String, dynamic> json) => WorkoutDto(
    id: json['id'],
    workoutConfig: json['workoutConfig'] == null
        ? null
        : WorkoutConfigDto.fromMap(json['workoutConfig']),
    date: json['date'] == null ? null : DateTime.parse(json['date']),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'workoutConfig': workoutConfig == null
        ? null
        : (workoutConfig as WorkoutConfigDto).toMap(),
    'date': date?.toIso8601String(),
  };

  static WorkoutDto fromWorkout(Workout w) {
    return WorkoutDto(
      id: w.id,
      workoutConfig: w.workoutConfig == null
          ? null
          : WorkoutConfigDto.fromWorkoutConfig(w.workoutConfig!),
      date: w.date,
    );
  }

  Workout toWorkout() {
    WorkoutConfigDto? d = workoutConfig as WorkoutConfigDto?;
    return Workout(id: id, workoutConfig: d?.toWorkoutConfig(), date: date);
  }
}

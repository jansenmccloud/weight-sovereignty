import 'package:equatable/equatable.dart';
import 'package:weight_sovereignty/src/domain/entity/workout_config.dart';

enum IntensityLevel { light, moderate, intense }

class Workout with EquatableMixin {
  Workout({
    this.id,
    this.workoutConfig,
    this.date,
    this.durationMin,
    this.intensityLevel,
    this.burnedCaloriesKcal,
  });

  final int? id;
  final WorkoutConfig? workoutConfig;
  final DateTime? date;
  final int? durationMin;
  final IntensityLevel? intensityLevel;
  final int? burnedCaloriesKcal;

  @override
  List<Object?> get props => [
    id,
    workoutConfig,
    date,
    durationMin,
    intensityLevel,
    burnedCaloriesKcal,
  ];
}

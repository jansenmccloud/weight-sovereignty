import 'package:equatable/equatable.dart';
import 'package:weight_sovereignty/src/domain/entity/workout_config.dart';

class Workout with EquatableMixin {
  Workout({this.id, this.workoutConfig, this.date});

  final int? id;
  final WorkoutConfig? workoutConfig;
  final DateTime? date;

  @override
  List<Object?> get props => [id, workoutConfig, date];
}

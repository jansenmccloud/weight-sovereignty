import 'package:equatable/equatable.dart';
import 'package:weight_sovereignty/src/domain/entity/exercise_config.dart';

enum WorkoutType { cardio, lifting }

class WorkoutConfig with EquatableMixin {
  WorkoutConfig({this.id, this.name, this.workoutType, this.exercises});

  final int? id;
  final String? name;
  final WorkoutType? workoutType;
  final List<ExerciseConfig?>? exercises;

  @override
  List<Object?> get props => [id, name, workoutType, exercises];
}

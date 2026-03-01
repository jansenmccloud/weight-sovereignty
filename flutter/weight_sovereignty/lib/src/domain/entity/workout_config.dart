import 'package:equatable/equatable.dart';
import 'package:weight_sovereignty/src/domain/entity/exercise_config.dart';

class WorkoutConfig with EquatableMixin {
  WorkoutConfig({this.id, this.name, this.exercises});

  final int? id;
  final String? name;
  final List<ExerciseConfig?>? exercises;

  @override
  List<Object?> get props => [id, name, exercises];
}

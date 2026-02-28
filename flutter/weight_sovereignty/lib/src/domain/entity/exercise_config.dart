import 'package:equatable/equatable.dart';

enum Category { none, back, arms, chest, legs, shoulders }

class ExerciseConfig with EquatableMixin {
  ExerciseConfig({
    this.id,
    this.name,
    this.category,
    this.weightKg,
    this.reps,
    this.sets,
  });

  final int? id;
  final String? name;
  final Category? category;
  final int? weightKg;
  final int? reps;
  final int? sets;

  @override
  List<Object?> get props => [id, name, category, weightKg, reps, sets];
}

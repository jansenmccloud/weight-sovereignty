import 'package:equatable/equatable.dart';

enum Category { none, back, arms, chest, legs, shoulders }

enum Type { cardio, lifting }

enum IntensityLevel { light, moderate, intense }

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

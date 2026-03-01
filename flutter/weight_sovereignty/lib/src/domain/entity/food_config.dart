import 'package:equatable/equatable.dart';

class FoodConfig with EquatableMixin {
  FoodConfig({
    this.id,
    this.name,
    this.favorite,
    this.intakeCaloriesKcal,
    this.intakeProteinG,
    this.intakeCarbsG,
    this.intakeFatG,
    this.amount,
    this.unit,
  });

  final int? id;
  final String? name;
  final bool? favorite;
  final int? intakeCaloriesKcal;
  final int? intakeProteinG;
  final int? intakeCarbsG;
  final int? intakeFatG;
  final int? amount;
  final String? unit;

  @override
  List<Object?> get props => [
    id,
    name,
    favorite,
    intakeCaloriesKcal,
    intakeProteinG,
    intakeCarbsG,
    intakeFatG,
    amount,
    unit,
  ];
}

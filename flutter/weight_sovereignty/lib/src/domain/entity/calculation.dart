import 'package:equatable/equatable.dart';

class Calculation with EquatableMixin {
  Calculation({
    this.totalBurnedCaloriesKcal,
    this.totalIntakeCaloriesKcal,
    this.totalIntakeProteinG,
    this.totalIntakeCarbsG,
    this.totalIntakeFatG,
  });

  final int? totalBurnedCaloriesKcal;
  final int? totalIntakeCaloriesKcal;
  final double? totalIntakeProteinG;
  final double? totalIntakeCarbsG;
  final double? totalIntakeFatG;

  @override
  List<Object?> get props => [
    totalBurnedCaloriesKcal,
    totalIntakeCaloriesKcal,
    totalIntakeProteinG,
    totalIntakeCarbsG,
    totalIntakeFatG,
  ];
}

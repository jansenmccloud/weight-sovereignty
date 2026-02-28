import 'package:equatable/equatable.dart';

class Calculation with EquatableMixin {
  Calculation({
    this.totalCaloriesBurnedKcal,
    this.totalCaloriesIntakeKcal,
    this.totalProteinIntakeG,
    this.totalCarbsIntakeG,
    this.totalFatIntakeG,
  });

  final int? totalCaloriesBurnedKcal;
  final int? totalCaloriesIntakeKcal;
  final double? totalProteinIntakeG;
  final double? totalCarbsIntakeG;
  final double? totalFatIntakeG;

  @override
  List<Object?> get props => [
    totalCaloriesBurnedKcal,
    totalCaloriesIntakeKcal,
    totalProteinIntakeG,
    totalCarbsIntakeG,
    totalFatIntakeG,
  ];
}

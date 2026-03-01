import 'dart:convert';
import 'package:weight_sovereignty/src/domain/entity/calculation.dart';

class CalculationDto extends Calculation {
  CalculationDto({
    super.totalBurnedCaloriesKcal,
    super.totalIntakeCaloriesKcal,
    super.totalIntakeProteinG,
    super.totalIntakeCarbsG,
    super.totalIntakeFatG,
  });

  factory CalculationDto.fromRawJson(String str) =>
      CalculationDto.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory CalculationDto.fromMap(Map<String, dynamic> json) => CalculationDto(
    totalBurnedCaloriesKcal: json['totalBurnedCaloriesKcal'],
    totalIntakeCaloriesKcal: json['totalIntakeCaloriesKcal'],
    totalIntakeProteinG: json['totalIntakeProteinG'],
    totalIntakeCarbsG: json['totalIntakeCarbsG'],
    totalIntakeFatG: json['totalIntakeFatG'],
  );

  Map<String, dynamic> toMap() => {
    'totalBurnedCaloriesKcal': totalBurnedCaloriesKcal,
    'totalIntakeCaloriesKcal': totalIntakeCaloriesKcal,
    'totalIntakeProteinG': totalIntakeProteinG,
    'totalIntakeCarbsG': totalIntakeCarbsG,
    'totalIntakeFatG': totalIntakeFatG,
  };

  static CalculationDto fromCalculation(Calculation calc) {
    return CalculationDto(
      totalBurnedCaloriesKcal: calc.totalBurnedCaloriesKcal,
      totalIntakeCaloriesKcal: calc.totalIntakeCaloriesKcal,
      totalIntakeProteinG: calc.totalIntakeProteinG,
      totalIntakeCarbsG: calc.totalIntakeCarbsG,
      totalIntakeFatG: calc.totalIntakeFatG,
    );
  }

  Calculation toCalculation() {
    return Calculation(
      totalBurnedCaloriesKcal: totalBurnedCaloriesKcal,
      totalIntakeCaloriesKcal: totalIntakeCaloriesKcal,
      totalIntakeProteinG: totalIntakeProteinG,
      totalIntakeCarbsG: totalIntakeCarbsG,
      totalIntakeFatG: totalIntakeFatG,
    );
  }
}

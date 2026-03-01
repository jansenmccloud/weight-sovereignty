import 'dart:convert';
import 'package:weight_sovereignty/src/domain/entity/food_config.dart';

class FoodConfigDto extends FoodConfig {
  FoodConfigDto({
    super.id,
    super.name,
    super.favorite,
    super.intakeCaloriesKcal,
    super.intakeProteinG,
    super.intakeCarbsG,
    super.intakeFatG,
    super.amount,
    super.unit,
  });

  factory FoodConfigDto.fromRawJson(String str) =>
      FoodConfigDto.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory FoodConfigDto.fromMap(Map<String, dynamic> json) => FoodConfigDto(
    id: json['id'],
    name: json['name'],
    favorite: json['favorite'],
    intakeCaloriesKcal: json['intakeCaloriesKcal'],
    intakeProteinG: json['intakeProteinG'],
    intakeCarbsG: json['intakeCarbsG'],
    intakeFatG: json['intakeFatG'],
    amount: json['amount'],
    unit: json['unit'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'favorite': favorite,
    'intakeCaloriesKcal': intakeCaloriesKcal,
    'intakeProteinG': intakeProteinG,
    'intakeCarbsG': intakeCarbsG,
    'intakeFatG': intakeFatG,
    'amount': amount,
    'unit': unit,
  };

  static FoodConfigDto fromFoodConfig(FoodConfig f) {
    return FoodConfigDto(
      id: f.id,
      name: f.name,
      favorite: f.favorite,
      intakeCaloriesKcal: f.intakeCaloriesKcal,
      intakeProteinG: f.intakeProteinG,
      intakeCarbsG: f.intakeCarbsG,
      intakeFatG: f.intakeFatG,
      amount: f.amount,
      unit: f.unit,
    );
  }

  FoodConfig toFoodConfig() {
    return FoodConfig(
      id: id,
      name: name,
      favorite: favorite,
      intakeCaloriesKcal: intakeCaloriesKcal,
      intakeProteinG: intakeProteinG,
      intakeCarbsG: intakeCarbsG,
      intakeFatG: intakeFatG,
      amount: amount,
      unit: unit,
    );
  }
}

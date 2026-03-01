import 'dart:convert';
import 'package:weight_sovereignty/src/data/dto/food_config_dto.dart';
import 'package:weight_sovereignty/src/domain/entity/food.dart';

class FoodDto extends Food {
  FoodDto({super.id, super.foodConfig, super.date});

  factory FoodDto.fromRawJson(String str) => FoodDto.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory FoodDto.fromMap(Map<String, dynamic> json) => FoodDto(
    id: json['id'],
    foodConfig: json['foodConfig'] == null
        ? null
        : FoodConfigDto.fromMap(json['foodConfig']),
    date: json['date'] == null ? null : DateTime.parse(json['date']),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'foodConfig': foodConfig == null
        ? null
        : (foodConfig as FoodConfigDto).toMap(),
    'date': date?.toIso8601String(),
  };

  static FoodDto fromFood(Food f) {
    return FoodDto(
      id: f.id,
      foodConfig: f.foodConfig == null
          ? null
          : FoodConfigDto.fromFoodConfig(f.foodConfig!),
      date: f.date,
    );
  }

  Food toFood() {
    FoodConfigDto? d = foodConfig as FoodConfigDto?;
    return Food(id: id, foodConfig: d?.toFoodConfig(), date: date);
  }
}

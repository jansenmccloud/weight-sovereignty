import 'package:equatable/equatable.dart';

class FoodConfig with EquatableMixin {
  FoodConfig({
    this.id,
    this.name,
    this.favorite,
    this.caloriesKcal,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.amount,
    this.unit,
  });

  final int? id;
  final String? name;
  final bool? favorite;
  final int? caloriesKcal;
  final int? proteinG;
  final int? carbsG;
  final int? fatG;
  final int? amount;
  final String? unit;

  @override
  List<Object?> get props => [
    id,
    name,
    favorite,
    caloriesKcal,
    proteinG,
    carbsG,
    fatG,
    amount,
    unit,
  ];
}

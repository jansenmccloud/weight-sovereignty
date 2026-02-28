import 'package:equatable/equatable.dart';
import 'package:weight_sovereignty/src/domain/entity/food_config.dart';

class Food with EquatableMixin {
  Food({this.id, this.foodConfig, this.date});

  final int? id;
  final FoodConfig? foodConfig;
  final DateTime? date;

  @override
  List<Object?> get props => [id, foodConfig, date];
}

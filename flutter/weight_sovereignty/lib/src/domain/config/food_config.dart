import 'package:isar/isar.dart';

part 'food_config.g.dart';

@collection
class FoodConfig {
  Id id = Isar.autoIncrement;
  @Index(unique: true, caseSensitive: false, replace: true)
  String? name;
  @Index()
  bool? favorite;
  int? intakeCaloriesKcal;
  int? intakeProteinG;
  int? intakeCarbsG;
  int? intakeFatG;
  int? amount;
  String? unit;
}

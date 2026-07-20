import 'package:isar/isar.dart';
import 'package:weight_sovereignty/src/domain/config/food_config.dart';

part 'food.g.dart';

@collection
class Food {
  Id id = Isar.autoIncrement;
  FoodBase? foodBase;
  @Index()
  DateTime? date;

  @ignore
  set setBase(FoodConfig conf) {
    foodBase = FoodBase()
      ..name = conf.name
      ..favorite = conf.favorite
      ..intakeCaloriesKcal = conf.intakeCaloriesKcal
      ..intakeProteinG = conf.intakeProteinG
      ..intakeCarbsG = conf.intakeCarbsG
      ..intakeFatG = conf.intakeFatG
      ..amountG = conf.amountG;
  }
}

@embedded
class FoodBase {
  String? name;
  bool? favorite;
  int? intakeCaloriesKcal;
  int? intakeProteinG;
  int? intakeCarbsG;
  int? intakeFatG;
  int? amountG;
}

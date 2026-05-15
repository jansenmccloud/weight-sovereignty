import 'package:weight_sovereignty/src/domain/config/food_config.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';

abstract class FoodConfigRepository implements CrudRepository<FoodConfig> {
  Future<List<FoodConfig>> listFavorites();
}

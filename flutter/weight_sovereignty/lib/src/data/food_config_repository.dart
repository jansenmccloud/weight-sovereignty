import 'package:isar/isar.dart';
import 'package:weight_sovereignty/src/data/source/local/isar_crud.dart';
import 'package:weight_sovereignty/src/domain/config/food_config.dart';
import 'package:weight_sovereignty/src/domain/repo/food_config_repo.dart';

class IsarFoodConfigRepository implements FoodConfigRepository {
  IsarFoodConfigRepository(Isar isar) : _configs = isar.foodConfigs, _crud = IsarCrud(isar.foodConfigs);

  final IsarCollection<FoodConfig> _configs;
  final IsarCrud<FoodConfig> _crud;

  @override
  Future<FoodConfig?> getById(int id) => _crud.getById(id);

  @override
  Future<List<FoodConfig>> getAll() => _crud.getAll();

  @override
  Future<int> save(FoodConfig entity) => _crud.put(entity);

  @override
  Future<bool> deleteById(int id) => _crud.deleteById(id);

  @override
  Future<List<FoodConfig>> listFavorites() {
    return _configs.filter().favoriteEqualTo(true).findAll();
  }
}

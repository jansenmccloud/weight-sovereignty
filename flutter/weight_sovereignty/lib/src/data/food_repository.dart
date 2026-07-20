import 'package:isar/isar.dart';
import 'package:weight_sovereignty/src/data/source/local/isar_crud.dart';
import 'package:weight_sovereignty/src/domain/entity/food.dart';
import 'package:weight_sovereignty/src/domain/repo/food_repo.dart';
import 'package:weight_sovereignty/src/domain/util/date_only.dart';

class IsarFoodRepository implements FoodRepository {
  IsarFoodRepository(Isar isar) : _foods = isar.foods, _crud = IsarCrud(isar.foods);

  final IsarCollection<Food> _foods;
  final IsarCrud<Food> _crud;

  @override
  Future<Food?> getById(int id) => _crud.getById(id);

  @override
  Future<List<Food>> getAll() => _crud.getAll();

  @override
  Future<int> save(Food entity) => _crud.put(entity);

  @override
  Future<bool> deleteById(int id) => _crud.deleteById(id);

  @override
  Future<List<Food>> listByCalendarDay(DateTime day) {
    return _foods.filter().dateEqualTo(toCalendarDay(day)).findAll();
  }

  @override
  Future<List<Food>> listByIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    final items = await _foods.getAll(ids);
    return items.whereType<Food>().toList();
  }
}

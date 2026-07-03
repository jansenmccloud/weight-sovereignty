import 'package:weight_sovereignty/src/domain/entity/food.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';

abstract class FoodRepository implements CrudRepository<Food> {
  Future<List<Food>> listByCalendarDay(DateTime day);

  Future<List<Food>> listByIds(List<int> ids);
}

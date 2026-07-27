import 'package:weight_sovereignty/src/domain/entity/food.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';

abstract class FoodRepository implements CrudRepository<Food> {
  Future<List<Food>> listByCalendarDay(DateTime day);

  Future<List<Food>> listByIds(List<int> ids);

  /// Query all Food entries within the given date range (inclusive).
  Future<List<Food>> queryByDateRange(DateTime start, DateTime end);
}

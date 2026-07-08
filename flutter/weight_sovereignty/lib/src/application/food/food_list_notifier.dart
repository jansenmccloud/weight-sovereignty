import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/crud/crud_list_notifier_mixin.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart';
import 'package:weight_sovereignty/src/domain/entity/food.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';
final foodListProvider =
    AsyncNotifierProvider<FoodListNotifier, List<Food>>(FoodListNotifier.new);

class FoodListNotifier extends AsyncNotifier<List<Food>>
    with CrudListNotifierMixin<Food> {
  @override
  CrudRepository<Food> repository() => ref.read(foodRepositoryProvider);

  Future<List<Food>> listByCalendarDay(DateTime day) =>
      ref.read(foodRepositoryProvider).listByCalendarDay(day);

  Future<List<Food>> listByIds(List<int> ids) =>
      ref.read(foodRepositoryProvider).listByIds(ids);

  /// Query foods for a specific date (alias for listByCalendarDay).
  Future<List<Food>> listByDate(DateTime day) =>
      listByCalendarDay(day);
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/crud/crud_list_notifier_mixin.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart';
import 'package:weight_sovereignty/src/domain/config/food_config.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';
final foodConfigListProvider =
    AsyncNotifierProvider<FoodConfigListNotifier, List<FoodConfig>>(
  FoodConfigListNotifier.new,
);

class FoodConfigListNotifier extends AsyncNotifier<List<FoodConfig>>
    with CrudListNotifierMixin<FoodConfig> {
  @override
  CrudRepository<FoodConfig> repository() =>
      ref.read(foodConfigRepositoryProvider);

  Future<List<FoodConfig>> listFavorites() =>
      ref.read(foodConfigRepositoryProvider).listFavorites();
}

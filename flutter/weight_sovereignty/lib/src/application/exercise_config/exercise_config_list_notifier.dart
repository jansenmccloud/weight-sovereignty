import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/crud/crud_list_notifier_mixin.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';

final exerciseConfigListProvider = AsyncNotifierProvider<ExerciseConfigListNotifier, List<ExerciseConfig>>(ExerciseConfigListNotifier.new);

class ExerciseConfigListNotifier extends AsyncNotifier<List<ExerciseConfig>> with CrudListNotifierMixin<ExerciseConfig> {
  @override
  CrudRepository<ExerciseConfig> repository() => ref.read(exerciseConfigRepositoryProvider);

  Future<ExerciseConfig?> getByName(String name) => ref.read(exerciseConfigRepositoryProvider).getByName(name);

  Future<List<ExerciseConfig>> listByCategory(ExerciseCategory category) => ref.read(exerciseConfigRepositoryProvider).listByCategory(category);
}

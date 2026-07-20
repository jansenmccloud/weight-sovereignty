import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/crud/crud_list_notifier_mixin.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart';
import 'package:weight_sovereignty/src/domain/config/workout_config.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';

final workoutConfigListProvider = AsyncNotifierProvider<WorkoutConfigListNotifier, List<WorkoutConfig>>(WorkoutConfigListNotifier.new);

class WorkoutConfigListNotifier extends AsyncNotifier<List<WorkoutConfig>> with CrudListNotifierMixin<WorkoutConfig> {
  @override
  CrudRepository<WorkoutConfig> repository() => ref.read(workoutConfigRepositoryProvider);
}

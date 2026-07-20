import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/crud/crud_list_notifier_mixin.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';

final workoutListProvider = AsyncNotifierProvider<WorkoutListNotifier, List<Workout>>(WorkoutListNotifier.new);

class WorkoutListNotifier extends AsyncNotifier<List<Workout>> with CrudListNotifierMixin<Workout> {
  @override
  CrudRepository<Workout> repository() => ref.read(workoutRepositoryProvider);

  Future<List<Workout>> listByCalendarDay(DateTime day) => ref.read(workoutRepositoryProvider).listByCalendarDay(day);

  Future<List<Workout>> listByIds(List<int> ids) => ref.read(workoutRepositoryProvider).listByIds(ids);
}

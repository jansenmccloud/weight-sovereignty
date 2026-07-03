import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';

abstract class WorkoutRepository implements CrudRepository<Workout> {
  Future<List<Workout>> listByCalendarDay(DateTime day);

  Future<List<Workout>> listByIds(List<int> ids);
}

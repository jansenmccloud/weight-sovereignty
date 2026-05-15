import 'package:isar/isar.dart';
import 'package:weight_sovereignty/src/data/source/local/isar_crud.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/domain/repo/workout_repo.dart';
import 'package:weight_sovereignty/src/domain/util/date_only.dart';

class IsarWorkoutRepository implements WorkoutRepository {
  IsarWorkoutRepository(Isar isar)
      : _workouts = isar.workouts,
        _crud = IsarCrud(isar.workouts);

  final IsarCollection<Workout> _workouts;
  final IsarCrud<Workout> _crud;

  @override
  Future<Workout?> getById(int id) => _crud.getById(id);

  @override
  Future<List<Workout>> getAll() => _crud.getAll();

  @override
  Future<int> save(Workout entity) => _crud.put(entity);

  @override
  Future<bool> deleteById(int id) => _crud.deleteById(id);

  @override
  Future<List<Workout>> listByCalendarDay(DateTime day) {
    return _workouts.filter().dateEqualTo(toCalendarDay(day)).findAll();
  }

  @override
  Future<List<Workout>> listByIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    final items = await _workouts.getAll(ids);
    return items.whereType<Workout>().toList();
  }
}

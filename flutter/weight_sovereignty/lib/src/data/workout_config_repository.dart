import 'package:isar/isar.dart';
import 'package:weight_sovereignty/src/data/source/local/isar_crud.dart';
import 'package:weight_sovereignty/src/domain/config/workout_config.dart';
import 'package:weight_sovereignty/src/domain/repo/workout_config_repo.dart';

class IsarWorkoutConfigRepository implements WorkoutConfigRepository {
  IsarWorkoutConfigRepository(Isar isar) : _crud = IsarCrud(isar.workoutConfigs);

  final IsarCrud<WorkoutConfig> _crud;

  @override
  Future<WorkoutConfig?> getById(int id) => _crud.getById(id);

  @override
  Future<List<WorkoutConfig>> getAll() => _crud.getAll();

  @override
  Future<int> save(WorkoutConfig entity) => _crud.put(entity);

  @override
  Future<bool> deleteById(int id) => _crud.deleteById(id);
}

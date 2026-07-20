import 'package:isar/isar.dart';
import 'package:weight_sovereignty/src/data/source/local/isar_crud.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';
import 'package:weight_sovereignty/src/domain/repo/exercise_config_repo.dart';

class IsarExerciseConfigRepository implements ExerciseConfigRepository {
  IsarExerciseConfigRepository(Isar isar) : _configs = isar.exerciseConfigs, _crud = IsarCrud(isar.exerciseConfigs);

  final IsarCollection<ExerciseConfig> _configs;
  final IsarCrud<ExerciseConfig> _crud;

  @override
  Future<ExerciseConfig?> getById(int id) => _crud.getById(id);

  @override
  Future<List<ExerciseConfig>> getAll() => _crud.getAll();

  @override
  Future<int> save(ExerciseConfig entity) => _crud.put(entity);

  @override
  Future<bool> deleteById(int id) => _crud.deleteById(id);

  @override
  Future<ExerciseConfig?> getByName(String name) {
    return _configs.filter().nameEqualTo(name).findFirst();
  }

  @override
  Future<List<ExerciseConfig>> listByCategory(ExerciseCategory category) {
    return _configs.filter().categoryNameEqualTo(category.name).findAll();
  }
}

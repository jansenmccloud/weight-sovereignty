import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';

abstract class ExerciseConfigRepository implements CrudRepository<ExerciseConfig> {
  Future<ExerciseConfig?> getByName(String name);

  Future<List<ExerciseConfig>> listByCategory(ExerciseCategory category);
}

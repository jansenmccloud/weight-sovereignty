import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';

void applyExerciseEnumsForSave(ExerciseConfig config) {
  config.categoryName = config.category.name;
  config.typeName = config.type.name;
  config.intensityLevelName = config.intensityLevel.name;
}

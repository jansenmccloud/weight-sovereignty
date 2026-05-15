import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weight_sovereignty/src/domain/config/dailylog_config.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';
import 'package:weight_sovereignty/src/domain/config/food_config.dart';
import 'package:weight_sovereignty/src/domain/config/workout_config.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/domain/entity/food.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';

class LocalStorage {
  LocalStorage._();

  static Isar? _instance;

  static Future<Isar> open() async {
    if (_instance != null && _instance!.isOpen) {
      return _instance!;
    }
    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [
        DailyLogSchema,
        FoodSchema,
        WorkoutSchema,
        DailyLogConfigSchema,
        FoodConfigSchema,
        WorkoutConfigSchema,
        ExerciseConfigSchema,
      ],
      directory: dir.path,
    );
    return _instance!;
  }

  static Future<void> close() async {
    if (_instance?.isOpen ?? false) {
      await _instance!.close();
    }
    _instance = null;
  }

  /// Opens an isolated database (tests). Does not replace the app singleton.
  static Future<Isar> openForTest(String directory) {
    return Isar.open(
      [
        DailyLogSchema,
        FoodSchema,
        WorkoutSchema,
        DailyLogConfigSchema,
        FoodConfigSchema,
        WorkoutConfigSchema,
        ExerciseConfigSchema,
      ],
      directory: directory,
      name: 'test_${DateTime.now().microsecondsSinceEpoch}',
    );
  }
}

import 'package:isar/isar.dart';

part 'workout_config.g.dart';

@collection
class WorkoutConfig {
  Id id = Isar.autoIncrement;
  @Index(unique: true, caseSensitive: false, replace: true)
  String? name;
  List<String?>? exercisePresetIds;
}
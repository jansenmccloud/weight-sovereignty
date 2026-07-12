import 'package:isar/isar.dart';

part 'dailylog_config.g.dart';

@collection
class DailyLogConfig {
  Id id = Isar.autoIncrement;
  @Index(unique: true, caseSensitive: false, replace: true)
  String? name;
  int? bmrCaloriesKcal;
  int? plannedDeficitKcal;
}

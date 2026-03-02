import 'package:isar/isar.dart';
import 'package:weight_sovereignty/src/domain/config/dailylog_config.dart';

part 'dailylog.g.dart';

@collection
class DailyLog {
  Id id = Isar.autoIncrement;
  DailyLogBase? dailyLogBase;
  DateTime? date;

  double? bodyWeight;
  List<int?>? foodIds;
  List<int?>? workoutIds;
  Calculation? calculation;

  @ignore
  set setBase(DailyLogConfig conf) {
    dailyLogBase = DailyLogBase()
      ..name = conf.name
      ..bmrCaloriesKcal = conf.bmrCaloriesKcal;
  }
}

@embedded
class DailyLogBase {
  String? name;
  int? bmrCaloriesKcal;
}

@embedded
class Calculation {
  int? totalBurnedCaloriesKcal;
  int? totalIntakeCaloriesKcal;
  double? totalIntakeProteinG;
  double? totalIntakeCarbsG;
  double? totalIntakeFatG;
}
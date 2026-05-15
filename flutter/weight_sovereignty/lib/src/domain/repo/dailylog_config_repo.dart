import 'package:weight_sovereignty/src/domain/config/dailylog_config.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';

abstract class DailyLogConfigRepository implements CrudRepository<DailyLogConfig> {
  Future<DailyLogConfig?> getByName(String name);
}

import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';

abstract class DailyLogRepository implements CrudRepository<DailyLog> {
  Future<DailyLog?> getByCalendarDay(DateTime day);

  Future<DailyLog> getOrCreateForDay(DateTime day);
}

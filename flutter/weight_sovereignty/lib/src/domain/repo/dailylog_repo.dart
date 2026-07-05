import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';

abstract class DailyLogRepository implements CrudRepository<DailyLog> {
  Future<DailyLog?> getByCalendarDay(DateTime day);

  Future<DailyLog> getOrCreateForDay(DateTime day);

  /// Upsert a DailyLog for the given calendar day.
  /// If an entry already exists for that day, updates it in place.
  /// Otherwise creates a new entry. Returns the resulting DailyLog.
  Future<DailyLog> upsertByCalendarDay(DateTime day, DailyLog log);
}

import 'package:isar/isar.dart';
import 'package:weight_sovereignty/src/data/source/local/isar_crud.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/domain/repo/dailylog_repo.dart';
import 'package:weight_sovereignty/src/domain/util/date_only.dart';

class IsarDailyLogRepository implements DailyLogRepository {
  IsarDailyLogRepository(Isar isar) : _dailyLogs = isar.dailyLogs, _crud = IsarCrud(isar.dailyLogs);

  final IsarCollection<DailyLog> _dailyLogs;
  final IsarCrud<DailyLog> _crud;

  @override
  Future<DailyLog?> getById(int id) => _crud.getById(id);

  @override
  Future<List<DailyLog>> getAll() => _crud.getAll();

  @override
  Future<int> save(DailyLog entity) => _crud.put(entity);

  @override
  Future<bool> deleteById(int id) => _crud.deleteById(id);

  @override
  Future<DailyLog?> getByCalendarDay(DateTime day) {
    return _dailyLogs.filter().dateEqualTo(toCalendarDay(day)).findFirst();
  }

  @override
  Future<DailyLog> upsertByCalendarDay(DateTime day, DailyLog log) async {
    final calendarDay = toCalendarDay(day);
    log.date = calendarDay;
    final existing = await getByCalendarDay(calendarDay);
    if (existing != null) {
      log.id = existing.id;
    }
    await _crud.put(log);
    return (await getByCalendarDay(calendarDay))!;
  }
}

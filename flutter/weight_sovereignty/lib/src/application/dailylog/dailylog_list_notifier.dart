import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/crud/crud_list_notifier_mixin.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';
import 'package:weight_sovereignty/src/domain/repo/dailylog_repo.dart';

/// CRUD list for [DailyLog]. Aggregate recalc from food/workout IDs is not yet wired.
final dailyLogListProvider =
    AsyncNotifierProvider<DailyLogListNotifier, List<DailyLog>>(
  DailyLogListNotifier.new,
);

class DailyLogListNotifier extends AsyncNotifier<List<DailyLog>>
    with CrudListNotifierMixin<DailyLog> {
  @override
  CrudRepository<DailyLog> repository() => ref.read(dailyLogRepositoryProvider);

  DailyLogRepository get _dailyLogRepo =>
      ref.read(dailyLogRepositoryProvider);

  Future<DailyLog?> getByCalendarDay(DateTime day) =>
      _dailyLogRepo.getByCalendarDay(day);
}

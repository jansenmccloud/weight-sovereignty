import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/crud/crud_list_notifier_mixin.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart';
import 'package:weight_sovereignty/src/domain/config/dailylog_config.dart';
import 'package:weight_sovereignty/src/domain/repo/crud_repository.dart';

final dailyLogConfigListProvider = AsyncNotifierProvider<DailyLogConfigListNotifier, List<DailyLogConfig>>(DailyLogConfigListNotifier.new);

class DailyLogConfigListNotifier extends AsyncNotifier<List<DailyLogConfig>> with CrudListNotifierMixin<DailyLogConfig> {
  @override
  CrudRepository<DailyLogConfig> repository() => ref.read(dailyLogConfigRepositoryProvider);

  Future<DailyLogConfig?> getByName(String name) => ref.read(dailyLogConfigRepositoryProvider).getByName(name);
}

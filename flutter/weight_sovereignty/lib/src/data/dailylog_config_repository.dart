import 'package:isar/isar.dart';
import 'package:weight_sovereignty/src/data/source/local/isar_crud.dart';
import 'package:weight_sovereignty/src/domain/config/dailylog_config.dart';
import 'package:weight_sovereignty/src/domain/repo/dailylog_config_repo.dart';

class IsarDailyLogConfigRepository implements DailyLogConfigRepository {
  IsarDailyLogConfigRepository(Isar isar) : _configs = isar.dailyLogConfigs, _crud = IsarCrud(isar.dailyLogConfigs);

  final IsarCollection<DailyLogConfig> _configs;
  final IsarCrud<DailyLogConfig> _crud;

  @override
  Future<DailyLogConfig?> getById(int id) => _crud.getById(id);

  @override
  Future<List<DailyLogConfig>> getAll() => _crud.getAll();

  @override
  Future<int> save(DailyLogConfig entity) => _crud.put(entity);

  @override
  Future<bool> deleteById(int id) => _crud.deleteById(id);

  @override
  Future<DailyLogConfig?> getByName(String name) {
    return _configs.filter().nameEqualTo(name).findFirst();
  }
}

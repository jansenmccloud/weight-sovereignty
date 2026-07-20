import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:weight_sovereignty/src/data/dailylog_repository.dart';
import 'package:weight_sovereignty/src/data/food_repository.dart';
import 'package:weight_sovereignty/src/data/source/local/local_storage.dart';
import 'package:weight_sovereignty/src/domain/entity/food.dart';
import 'package:weight_sovereignty/src/domain/util/date_only.dart';
import '../isar_test_helper.dart';

void main() {
  group('Isar repositories', () {
    late Directory tempDir;
    late Isar isar;
    late IsarFoodRepository foodRepo;
    late IsarDailyLogRepository dailyLogRepo;

    setUpAll(() async {
      await initializeIsarCoreForTests();
    });

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('weight_sovereignty_test');
      isar = await LocalStorage.openForTest(tempDir.path);
      foodRepo = IsarFoodRepository(isar);
      dailyLogRepo = IsarDailyLogRepository(isar);
    });

    tearDown(() async {
      await isar.close(deleteFromDisk: true);
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('Food CRUD round-trip', () async {
      final food = Food()
        ..date = toCalendarDay(DateTime(2026, 5, 15))
        ..foodBase = (FoodBase()
          ..name = 'Oats'
          ..intakeCaloriesKcal = 350);

      final id = await foodRepo.save(food);
      expect(id, greaterThan(0));

      final loaded = await foodRepo.getById(id);
      expect(loaded?.foodBase?.name, 'Oats');

      final all = await foodRepo.getAll();
      expect(all, hasLength(1));

      loaded!.foodBase!.intakeCaloriesKcal = 400;
      await foodRepo.save(loaded);
      expect((await foodRepo.getById(id))?.foodBase?.intakeCaloriesKcal, 400);

      expect(await foodRepo.deleteById(id), isTrue);
      expect(await foodRepo.getAll(), isEmpty);
    });

    test('listByCalendarDay returns only matching day', () async {
      await foodRepo.save(Food()..date = toCalendarDay(DateTime(2026, 5, 14)));
      await foodRepo.save(Food()..date = toCalendarDay(DateTime(2026, 5, 15)));
      await foodRepo.save(Food()..date = toCalendarDay(DateTime(2026, 5, 15)));

      final may15 = await foodRepo.listByCalendarDay(DateTime(2026, 5, 15));
      expect(may15, hasLength(2));
    });
  });
}

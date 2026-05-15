import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:weight_sovereignty/src/application/providers/isar_provider.dart';
import 'package:weight_sovereignty/src/data/dailylog_config_repository.dart';
import 'package:weight_sovereignty/src/data/dailylog_repository.dart';
import 'package:weight_sovereignty/src/data/exercise_config_repository.dart';
import 'package:weight_sovereignty/src/data/food_config_repository.dart';
import 'package:weight_sovereignty/src/data/food_repository.dart';
import 'package:weight_sovereignty/src/data/workout_config_repository.dart';
import 'package:weight_sovereignty/src/data/workout_repository.dart';
import 'package:weight_sovereignty/src/domain/repo/dailylog_config_repo.dart';
import 'package:weight_sovereignty/src/domain/repo/dailylog_repo.dart';
import 'package:weight_sovereignty/src/domain/repo/exercise_config_repo.dart';
import 'package:weight_sovereignty/src/domain/repo/food_config_repo.dart';
import 'package:weight_sovereignty/src/domain/repo/food_repo.dart';
import 'package:weight_sovereignty/src/domain/repo/workout_config_repo.dart';
import 'package:weight_sovereignty/src/domain/repo/workout_repo.dart';

Isar _requireIsar(Ref ref) {
  return ref.watch(isarProvider).requireValue;
}

final dailyLogRepositoryProvider = Provider<DailyLogRepository>((ref) {
  return IsarDailyLogRepository(_requireIsar(ref));
});

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return IsarFoodRepository(_requireIsar(ref));
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return IsarWorkoutRepository(_requireIsar(ref));
});

final dailyLogConfigRepositoryProvider = Provider<DailyLogConfigRepository>((ref) {
  return IsarDailyLogConfigRepository(_requireIsar(ref));
});

final foodConfigRepositoryProvider = Provider<FoodConfigRepository>((ref) {
  return IsarFoodConfigRepository(_requireIsar(ref));
});

final workoutConfigRepositoryProvider = Provider<WorkoutConfigRepository>((ref) {
  return IsarWorkoutConfigRepository(_requireIsar(ref));
});

final exerciseConfigRepositoryProvider = Provider<ExerciseConfigRepository>((ref) {
  return IsarExerciseConfigRepository(_requireIsar(ref));
});

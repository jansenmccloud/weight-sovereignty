import 'package:equatable/equatable.dart';
import 'package:weight_sovereignty/src/domain/entity/calculation.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog_config.dart';

class DailyLog with EquatableMixin {
  DailyLog({
    this.id,
    this.date,
    this.dailyLogConfig,
    this.bodyWeight,
    this.foodIds,
    this.workoutIds,
    this.calculation,
  });

  final int? id;
  final DateTime? date;
  final DailyLogConfig? dailyLogConfig;
  final double? bodyWeight;
  final List<int?>? foodIds;
  final List<int?>? workoutIds;
  final Calculation? calculation;

  @override
  List<Object?> get props => [
    id,
    date,
    dailyLogConfig,
    bodyWeight,
    foodIds,
    workoutIds,
    calculation,
  ];
}

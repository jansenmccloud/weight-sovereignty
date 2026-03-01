import 'package:equatable/equatable.dart';
import 'package:weight_sovereignty/src/domain/entity/calculation.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog_config.dart';

class DailyLog with EquatableMixin {
  DailyLog({
    this.id,
    this.dailyLogConfig,
    this.date,

    this.bodyWeight,
    this.foodIds,
    this.workoutIds,
    this.calculation,
  });

  final int? id;
  final DailyLogConfig? dailyLogConfig;
  final DateTime? date;

  final double? bodyWeight;
  final List<int?>? foodIds;
  final List<int?>? workoutIds;
  final Calculation? calculation;

  @override
  List<Object?> get props => [
    id,
    dailyLogConfig,
    date,

    bodyWeight,
    foodIds,
    workoutIds,
    calculation,
  ];
}

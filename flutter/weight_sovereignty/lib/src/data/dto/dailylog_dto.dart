import 'dart:convert';
import 'package:weight_sovereignty/src/data/dto/calculation_dto.dart';
import 'package:weight_sovereignty/src/data/dto/dailylog_config_dto.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';

class DailyLogDto extends DailyLog {
  DailyLogDto({
    super.id,
    super.dailyLogConfig,
    super.date,
    super.bodyWeight,
    super.foodIds,
    super.workoutIds,
    super.calculation,
  });

  factory DailyLogDto.fromRawJson(String str) =>
      DailyLogDto.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory DailyLogDto.fromMap(Map<String, dynamic> json) => DailyLogDto(
    id: json['id'],
    dailyLogConfig: json['dailyLogConfig'] == null
        ? null
        : DailyLogConfigDto.fromMap(json['dailyLogConfig']),
    date: json['date'] == null ? null : DateTime.parse(json['date']),
    bodyWeight: json['bodyWeight'],
    foodIds: json['foodIds'] == null
        ? []
        : List<int>.from(json['foodIds']!.map((dynamic x) => x)),
    workoutIds: json['workoutIds'] == null
        ? []
        : List<int>.from(json['workoutIds']!.map((dynamic x) => x)),
    calculation: json['calculation'] == null
        ? null
        : CalculationDto.fromMap(json['calculation']),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'dailyLogConfig': dailyLogConfig == null
        ? null
        : (dailyLogConfig as DailyLogConfigDto).toMap(),
    'date': date?.toIso8601String(),
    'bodyWeight': bodyWeight,
    'foodIds': foodIds == null
        ? []
        : List<dynamic>.from(foodIds!.map((x) => x)),
    'workoutIds': workoutIds == null
        ? []
        : List<dynamic>.from(workoutIds!.map((x) => x)),
    'calculation': calculation == null
        ? null
        : (calculation as CalculationDto).toMap(),
  };

  static DailyLogDto fromDailyLog(DailyLog d) {
    return DailyLogDto(
      id: d.id,
      dailyLogConfig: d.dailyLogConfig == null
          ? null
          : DailyLogConfigDto.fromDailyLogConfig(d.dailyLogConfig!),
      date: d.date,
      bodyWeight: d.bodyWeight,
      foodIds: d.foodIds == null ? [] : d.foodIds!,
      workoutIds: d.workoutIds == null ? [] : d.workoutIds!,
      calculation: d.calculation == null
          ? null
          : CalculationDto.fromCalculation(d.calculation!),
    );
  }

  DailyLog toDailyLog() {
    DailyLogConfigDto? d = dailyLogConfig as DailyLogConfigDto?;
    CalculationDto? c = calculation as CalculationDto?;
    return DailyLog(
      id: id,
      dailyLogConfig: d?.toDailyLogConfig(),
      date: date,
      bodyWeight: bodyWeight,
      foodIds: foodIds ?? [],
      workoutIds: workoutIds ?? [],
      calculation: c?.toCalculation(),
    );
  }
}

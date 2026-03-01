import 'dart:convert';
import 'package:weight_sovereignty/src/domain/entity/dailylog_config.dart';

class DailyLogConfigDto extends DailyLogConfig {
  DailyLogConfigDto({super.id, super.name, super.bmrCaloriesKcal});

  factory DailyLogConfigDto.fromRawJson(String str) =>
      DailyLogConfigDto.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory DailyLogConfigDto.fromMap(Map<String, dynamic> json) =>
      DailyLogConfigDto(
        id: json['id'],
        name: json['name'],
        bmrCaloriesKcal: json['bmrCaloriesKcal'],
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'bmrCaloriesKcal': bmrCaloriesKcal,
  };

  static DailyLogConfigDto fromDailyLogConfig(DailyLogConfig d) {
    return DailyLogConfigDto(
      id: d.id,
      name: d.name,
      bmrCaloriesKcal: d.bmrCaloriesKcal,
    );
  }

  DailyLogConfig toDailyLogConfig() {
    return DailyLogConfig(id: id, name: name, bmrCaloriesKcal: bmrCaloriesKcal);
  }
}

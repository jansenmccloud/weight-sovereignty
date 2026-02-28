import 'package:equatable/equatable.dart';

class DailyLogConfig with EquatableMixin {
  DailyLogConfig({this.id, this.name, this.bmrCaloriesKcal});

  final int? id;
  final String? name;
  final int? bmrCaloriesKcal;

  @override
  List<Object?> get props => [id, name, bmrCaloriesKcal];
}

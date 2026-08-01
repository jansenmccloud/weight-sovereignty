import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';
import 'package:weight_sovereignty/src/presentation/widgets/weight_chart.dart';
import 'package:weight_sovereignty/src/presentation/widgets/calories_chart.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // Formulas
          _expandableTileWrapper("Formulas", _formulasWidgets()),
          // DailyLogs
          FutureBuilder<List<Widget>>(
            future: _dailyLogsWidgets(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return _expandableTileWrapper("Daily Logs", snapshot.data!);
            },
          ),
          // Weight Progression
          FutureBuilder<List<Widget>>(
            future: _weightWidgets(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return _expandableTileWrapper("Weight Progression", snapshot.data!);
            },
          ),
          // Calories
          FutureBuilder<List<Widget>>(
            future: _caloriesWidgets(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return _expandableTileWrapper("Calories", snapshot.data!);
            },
          ),
          // Workouts
          _expandableTileWrapper("Workouts", _workoutsWidgets()),
          ]),
      ),
    );
  }

  Widget _expandableTileWrapper(String title, List<Widget> children) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(color: AppTheme.white)),
      children: children,
    );
  }

  List<Widget> _formulasWidgets() {
    return [
      ListTile(
        title: Text('Kcal = Kcal/[m] x Duration[m]', style: TextStyle(color: AppTheme.white)),
        leading: Icon(Icons.calculate_outlined, color: AppTheme.white,),
        subtitle: Text('Kcal/[m] = (MET x 3.5 x Weight[kg]) / 200', style: TextStyle(color: AppTheme.white)),
      ),
      ListTile(
        title: Text('Duration[m] = Lifting Duration[s] / 60', style: TextStyle(color: AppTheme.white)),
        leading: Icon(Icons.fitness_center_outlined, color: AppTheme.white,),
        subtitle: Text('Lifting Duration[s] = Repetitions x 6[s]', style: TextStyle(color: AppTheme.white)),
      ),
      ListTile(
        title: Text('Metabolic Equivalent of Task', style: TextStyle(color: AppTheme.white)),
        leading: Icon(Icons.multiple_stop_sharp, color: AppTheme.white,),
        subtitle: Text('Cardio: light=2.9, moderate=3.3, intense=5.3\nLifting: light=3.5, moderate=4.5, intense=6.0\n ', style: TextStyle(color: AppTheme.white)),
      ),
    ];
  }

  Future<List<Widget>> _dailyLogsWidgets() async {
    final logs = await ref.read(dailyLogRepositoryProvider).getAll();

    if (logs.isEmpty) {
      return [ListTile(title: Text('No daily logs yet', style: TextStyle(color: AppTheme.white)))];
    }

    // Total count
    final totalCount = logs.length;

    // Averages — exclude null, zero, and negative entries
    final validProtein = logs.where((l) => (l.calculation?.totalIntakeProteinG ?? 0) > 0).toList();
    final validFat = logs.where((l) => (l.calculation?.totalIntakeFatG ?? 0) > 0).toList();
    final validCarbs = logs.where((l) => (l.calculation?.totalIntakeCarbsG ?? 0) > 0).toList();
    final validCalories = logs.where((l) => (l.calculation?.totalIntakeCaloriesKcal ?? 0) > 0).toList();

    double? avgProtein;
    if (validProtein.isNotEmpty) {
      avgProtein = validProtein.fold<double>(0, (s, l) => s + ((l.calculation!.totalIntakeProteinG?.toDouble()) ?? 0)) / validProtein.length;
    }

    double? avgFat;
    if (validFat.isNotEmpty) {
      avgFat = validFat.fold<double>(0, (s, l) => s + ((l.calculation!.totalIntakeFatG?.toDouble()) ?? 0)) / validFat.length;
    }

    double? avgCarbs;
    if (validCarbs.isNotEmpty) {
      avgCarbs = validCarbs.fold<double>(0, (s, l) => s + ((l.calculation!.totalIntakeCarbsG?.toDouble()) ?? 0)) / validCarbs.length;
    }

    int? avgCalories;
    if (validCalories.isNotEmpty) {
      avgCalories = (validCalories.fold<int>(0, (s, l) => s + (l.calculation!.totalIntakeCaloriesKcal ?? 0)) / validCalories.length).round();
    }

    return [
      ListTile(
        title: Text('Total Logs: $totalCount', style: TextStyle(color: AppTheme.white)),
        leading: Icon(Icons.list_alt, color: AppTheme.white),
      ),
      ListTile(
        title: Text('Avg Intake Protein: ${avgProtein != null ? '${avgProtein.toStringAsFixed(1)}g/day' : '—'}', style: TextStyle(color: AppTheme.white)),
        leading: Icon(Icons.restaurant, color: AppTheme.white),
      ),
      ListTile(
        title: Text('Avg Intake Fat: ${avgFat != null ? '${avgFat.toStringAsFixed(1)}g/day' : '—'}', style: TextStyle(color: AppTheme.white)),
        leading: Icon(Icons.opacity, color: AppTheme.white),
      ),
      ListTile(
        title: Text('Avg Intake Carbs: ${avgCarbs != null ? '${avgCarbs.toStringAsFixed(1)}g/day' : '—'}', style: TextStyle(color: AppTheme.white)),
        leading: Icon(Icons.grain, color: AppTheme.white),
      ),
      ListTile(
        title: Text('Avg Intake Calories: ${avgCalories != null ? '$avgCalories kcal/day' : '—'}', style: TextStyle(color: AppTheme.white)),
        leading: Icon(Icons.local_fire_department, color: AppTheme.white),
      ),
    ];
  }

  Future<List<Widget>> _weightWidgets() async {
    final logs = await ref.read(dailyLogRepositoryProvider).getAll();

    if (logs.isEmpty) {
      return [ListTile(title: Text('No weight data available', style: TextStyle(color: AppTheme.white)))];
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Helper to filter logs within N days
    List<DailyLog> logsInLastDays(int days) {
      final cutoff = today.subtract(Duration(days: days));
      return logs.where((l) {
        final logDate = DateTime(l.date!.year, l.date!.month, l.date!.day);
        return logDate.isAfter(cutoff) && logDate.isBefore(today.add(const Duration(days: 1)));
      }).toList();
    }

    // Compute average weight from a list of logs
    double? avgWeight(List<DailyLog> logList) {
      final valid = logList.where((l) => (l.bodyWeight ?? 0.0) > 0.0).toList();
      if (valid.isEmpty) return null;
      return valid.fold<double>(0, (s, l) => s + (l.bodyWeight?.toDouble() ?? 0)) / valid.length;
    }

    // Weight data points for chart (all available data)
    final allWeightPoints = <WeightDataPoint>[];
    final sortedLogs = List<DailyLog>.from(logs)
      ..sort((a, b) => a.date!.compareTo(b.date!));

    for (final log in sortedLogs) {
      if ((log.bodyWeight ?? 0.0) > 0.0) {
        allWeightPoints.add(
          WeightDataPoint(
            date: DateTime(log.date!.year, log.date!.month, log.date!.day),
            weight: log.bodyWeight!.toDouble(),
          ),
        );
      }
    }

    // Rolling averages
    final logs7d = logsInLastDays(7);
    final logs14d = logsInLastDays(14);
    final logs30d = logsInLastDays(30);

    final avg7 = avgWeight(logs7d);
    final avg14 = avgWeight(logs14d);
    final avg30 = avgWeight(logs30d);

    return [
      // Weight chart
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: WeightChart(
          dataPoints: allWeightPoints,
          height: 180.0,
        ),
      ),
      // Rolling averages
      ListTile(
        title: Text('7-Day Avg: ${avg7 != null ? '${avg7.toStringAsFixed(1)} kg' : '—'}', style: TextStyle(color: AppTheme.white)),
        leading: Icon(Icons.filter_7_outlined, color: AppTheme.white),
      ),
      ListTile(
        title: Text('14-Day Avg: ${avg14 != null ? '${avg14.toStringAsFixed(1)} kg' : '—'}', style: TextStyle(color: AppTheme.white)),
        leading: Icon(Icons.calendar_today, color: AppTheme.white),
      ),
      ListTile(
        title: Text('30-Day Avg: ${avg30 != null ? '${avg30.toStringAsFixed(1)} kg' : '—'}', style: TextStyle(color: AppTheme.white)),
        leading: Icon(Icons.calendar_month_outlined, color: AppTheme.white),
      ),
    ];
  }

  Future<List<Widget>> _caloriesWidgets() async {
    final logsRepo = ref.read(dailyLogRepositoryProvider);
    final allLogs = await logsRepo.getAll();

    if (allLogs.isEmpty) {
      return [ListTile(title: Text('No calorie data available', style: TextStyle(color: AppTheme.white)))];
    }

    // Filter to last 2 years
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cutoff = DateTime(now.year - 2, now.month, now.day);
    final filteredLogs = allLogs.where((l) {
      final logDate = DateTime(l.date!.year, l.date!.month, l.date!.day);
      return logDate.isAfter(cutoff) && logDate.isBefore(today.add(const Duration(days: 1)));
    }).toList()..sort((a, b) => a.date!.compareTo(b.date!));

    if (filteredLogs.isEmpty) {
      return [ListTile(title: Text('No calorie data in last 2 years', style: TextStyle(color: AppTheme.white)))];
    }

    // Compute daily data points
    final dataPoints = <CaloriesChartDataPoint>[];
    for (final log in filteredLogs) {
      dataPoints.add(CaloriesChartDataPoint.fromDailyLog(log));
    }

    // Resolution picker — use a proper StatefulWidget wrapper (see _CaloriesChartSection)
    return [
      _CaloriesChartSection(dataPoints: dataPoints),
    ];
  }

  List<Widget> _workoutsWidgets() {
    return [
      //TODO metric: total count of logged workouts
      //TODO metric: count of logged workouts grouped by workoutBase.name
      //TODO metric: count of logged exercises within the workouts grouped by exercise name
      //TODO metrics accumulated among exercises: average number of sets, average number of reps
      //TODO metrics for each exercise within all workouts: personal best (max. weightKg)
    ];
  }
}

/// StatefulWidget that owns resolution state for the calories chart.
class _CaloriesChartSection extends StatefulWidget {
  const _CaloriesChartSection({required this.dataPoints});

  final List<CaloriesChartDataPoint> dataPoints;

  @override
  State<_CaloriesChartSection> createState() => _CaloriesChartSectionState();
}

class _CaloriesChartSectionState extends State<_CaloriesChartSection> {
  ChartResolution _resolution = ChartResolution.daily;

  List<CaloriesChartDataPoint> get _resampledPoints {
    switch (_resolution) {
      case ChartResolution.daily:
        return widget.dataPoints;

      case ChartResolution.weekly:
        return _aggregateWeekly(widget.dataPoints);

      case ChartResolution.monthly:
        return _aggregateMonthly(widget.dataPoints);
    }
  }

  /// Aggregate daily points into 7-day rolling mean buckets.
  List<CaloriesChartDataPoint> _aggregateWeekly(List<CaloriesChartDataPoint> points) {
    if (points.isEmpty) return [];

    final Map<DateTime, List<CaloriesChartDataPoint>> buckets = <DateTime, List<CaloriesChartDataPoint>>{};

    for (final p in points) {
      final daysFromStart = p.date.difference(points.first.date).inDays;
      final bucketIndex = daysFromStart ~/ 7;
      final anchorDate = points.first.date.add(Duration(days: bucketIndex * 7));
      buckets.putIfAbsent(anchorDate, () => []).add(p);
    }

    final sortedAnchors = buckets.keys.toList()..sort();
    return sortedAnchors.map((anchor) {
      final bp = buckets[anchor]!;
      return _averagePoints(bp);
    }).toList();
  }

  /// Aggregate daily points into per-calendar-month buckets.
  List<CaloriesChartDataPoint> _aggregateMonthly(List<CaloriesChartDataPoint> points) {
    if (points.isEmpty) return [];

    final Map<String, List<CaloriesChartDataPoint>> buckets = <String, List<CaloriesChartDataPoint>>{};

    for (final p in points) {
      final key = '${p.date.year}-${p.date.month.toString().padLeft(2, '0')}';
      buckets.putIfAbsent(key, () => []).add(p);
    }

    final sortedKeys = buckets.keys.toList()..sort();
    return sortedKeys.map((key) {
      final bp = buckets[key]!;
      return _averagePoints(bp);
    }).toList();
  }

  /// Compute average CaloriesChartDataPoint from a bucket of points.
  CaloriesChartDataPoint _averagePoints(List<CaloriesChartDataPoint> points) {
    double? avgIntake, avgBmr, avgBurned, avgPlannedDeficit, avgActualDeficit;

    final nonNullIntake = points.where((p) => p.intake != null).toList();
    if (nonNullIntake.isNotEmpty) {
      avgIntake = nonNullIntake.fold<double>(0, (s, p) => s + p.intake!) / nonNullIntake.length;
    }

    final nonNullBmr = points.where((p) => p.bmr != null).toList();
    if (nonNullBmr.isNotEmpty) {
      avgBmr = nonNullBmr.fold<double>(0, (s, p) => s + p.bmr!) / nonNullBmr.length;
    }

    final nonNullBurned = points.where((p) => p.burned != null).toList();
    if (nonNullBurned.isNotEmpty) {
      avgBurned = nonNullBurned.fold<double>(0, (s, p) => s + p.burned!) / nonNullBurned.length;
    }

    final nonNullDeficit = points.where((p) => p.plannedDeficit != null).toList();
    if (nonNullDeficit.isNotEmpty) {
      avgPlannedDeficit = nonNullDeficit.fold<double>(0, (s, p) => s + p.plannedDeficit!) / nonNullDeficit.length;
    }

    final nonNullActualDeficit = points.where((p) => p.actualDeficit != null).toList();
    if (nonNullActualDeficit.isNotEmpty) {
      avgActualDeficit = nonNullActualDeficit.fold<double>(0, (s, p) => s + p.actualDeficit!) / nonNullActualDeficit.length;
    }

    // Use first date as anchor
    final anchorDate = points.first.date;

    return CaloriesChartDataPoint(
      date: anchorDate,
      intake: avgIntake,
      bmr: avgBmr,
      burned: avgBurned,
      plannedDeficit: avgPlannedDeficit,
      actualDeficit: avgActualDeficit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ResolutionPicker(
          resolution: _resolution,
          onChanged: (r) => setState(() => _resolution = r),
        ),
        const SizedBox(height: 8),
        CaloriesChart(dataPoints: _resampledPoints),
      ],
    );
  }
}

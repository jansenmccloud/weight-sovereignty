import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';
import 'package:weight_sovereignty/src/presentation/widgets/stats/calories_chart_section.dart';
import 'package:weight_sovereignty/src/presentation/widgets/stats/weight_chart.dart';
import 'package:weight_sovereignty/src/presentation/widgets/stats/calories_chart.dart';

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _expandableTileWrapper("Formulas", _formulasWidgets),
            _expandableTileWrapper("Daily Logs", _dailyLogsWidgets),
            _expandableTileWrapper("Weight Progression", _weightWidgets),
            _expandableTileWrapper("Calories", _caloriesWidgets),
            _expandableTileWrapper("Workouts", _workoutsWidgets),
          ],
        ),
      ),
    );
  }

  Widget _expandableTileWrapper(String title, Future<List<Widget>> Function() func) {
    return FutureBuilder<List<Widget>>(
      future: func(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return ExpansionTile(
          title: Text(title, style: TextStyle(color: AppTheme.white)),
          children: snapshot.data!,
        );
      },
    );
  }

  Future<List<Widget>> _formulasWidgets() {
    return Future(() => [
      ListTile(
        title: Text('Kcal = Kcal/[m] x Duration[m]', style: TextStyle(color: AppTheme.white)),
        leading: Icon(Icons.calculate_outlined, color: AppTheme.white),
        subtitle: Text('Kcal/[m] = (MET x 3.5 x Weight[kg]) / 200', style: TextStyle(color: AppTheme.white)),
      ),
      ListTile(
        title: Text('Duration[m] = Lifting Duration[s] / 60', style: TextStyle(color: AppTheme.white)),
        leading: Icon(Icons.fitness_center_outlined, color: AppTheme.white),
        subtitle: Text('Lifting Duration[s] = Repetitions x 6[s]', style: TextStyle(color: AppTheme.white)),
      ),
      ListTile(
        title: Text('Metabolic Equivalent of Task', style: TextStyle(color: AppTheme.white)),
        leading: Icon(Icons.multiple_stop_sharp, color: AppTheme.white),
        subtitle: Text('Cardio: light=2.9, moderate=3.3, intense=5.3\nLifting: light=3.5, moderate=4.5, intense=6.0\n ', style: TextStyle(color: AppTheme.white)),
      ),
    ]);
  }

  Future<List<Widget>> _dailyLogsWidgets() async {
    final logs = await ref.read(dailyLogRepositoryProvider).getAll();

    if (logs.isEmpty) {
      return [
        ListTile(
          title: Text('No daily logs yet', style: TextStyle(color: AppTheme.white)),
        ),
      ];
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
      return [
        ListTile(
          title: Text('No weight data available', style: TextStyle(color: AppTheme.white)),
        ),
      ];
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
    final sortedLogs = List<DailyLog>.from(logs)..sort((a, b) => a.date!.compareTo(b.date!));

    for (final log in sortedLogs) {
      if ((log.bodyWeight ?? 0.0) > 0.0) {
        allWeightPoints.add(WeightDataPoint(date: DateTime(log.date!.year, log.date!.month, log.date!.day), weight: log.bodyWeight!.toDouble()));
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
        child: WeightChart(dataPoints: allWeightPoints, height: 180.0),
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
      return [
        ListTile(
          title: Text('No calorie data available', style: TextStyle(color: AppTheme.white)),
        ),
      ];
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
      return [
        ListTile(
          title: Text('No calorie data in last 2 years', style: TextStyle(color: AppTheme.white)),
        ),
      ];
    }

    // Compute daily data points
    final dataPoints = <CaloriesChartDataPoint>[];
    for (final log in filteredLogs) {
      dataPoints.add(CaloriesChartDataPoint.fromDailyLog(log));
    }

    return [
      CaloriesChartSection(dataPoints: dataPoints),
      ListTile(
        title: Text('Intake Calories', style: TextStyle(color: AppTheme.white.withAlpha(200))),
        leading: Icon(Icons.line_axis, color: AppTheme.white.withAlpha(200)),
      ),
      ListTile(
        title: Text('Burned Calories (BMR + Workout)', style: TextStyle(color: AppTheme.purple.withAlpha(180))),
        leading: Icon(Icons.line_axis, color: AppTheme.purple.withAlpha(180)),
      ),
      ListTile(
        title: Text('BMR', style: TextStyle(color: AppTheme.white.withAlpha(100))),
        leading: Icon(Icons.linear_scale, color: AppTheme.white.withAlpha(100)),
      ),
      ListTile(
        title: Text('Actual Deficit', style: TextStyle(color: AppTheme.yellow.withAlpha(120))),
        leading: Icon(Icons.area_chart, color: AppTheme.yellow.withAlpha(120)),
      ),
      ListTile(
        title: Text('Planned Deficit', style: TextStyle(color: AppTheme.green.withAlpha(180))),
        leading: Icon(Icons.linear_scale_rounded, color: AppTheme.green.withAlpha(180)),
      ),
    ];
  }

  Future<List<Widget>> _workoutsWidgets() {
    return Future(() => [
      //TODO metric: total count of logged workouts
      //TODO metrics accumulated among all exercises: total number of sets, total number of reps

      //TODO metric: count of logged workouts grouped by workoutBase.name
      //TODO metric: count of logged exercises within the workouts grouped by exercise name

      //TODO metrics personal best for each exercise (grouped by name) within all workouts: 
      // A) for each workout of type lifting : personal best: 1. entry with max weightKg, 2. entry with max reps
      // B) for each workout of type cardio : personal best: 1. entry with max duration, 2. entry with max distance

    ]);
  }
}

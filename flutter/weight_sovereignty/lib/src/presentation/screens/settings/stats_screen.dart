import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
          _expandableTileWrapper("Weight Progression", _weightWidgets()),
          // Calories
          _expandableTileWrapper("Calories", _caloriesWidgets()),
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

  List<Widget> _weightWidgets() {
    return [
      // TODO last 30 day weight average
      // TODO last 14 day weight average
      // TODO last 7 day weight average
      // TODO diagramm showing daily weight measurements
    ];
  }

  List<Widget> _caloriesWidgets() {
    return [
      //TODO diagram containing curves of intake calories, BMR, deficit and burned calories
      //TODO diagram may be switchable between daily, weekly, mountly and yearly resolution
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

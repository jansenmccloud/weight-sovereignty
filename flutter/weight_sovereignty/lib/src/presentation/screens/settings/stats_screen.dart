import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          _expandableTileWrapper("Formulas", _formulasWidgets()),
          _expandableTileWrapper("Daily Logs", _dailyLogsWidgets()),
          _expandableTileWrapper("Weight Progression", _weightWidgets()),
          _expandableTileWrapper("Calories", _caloriesWidgets()),
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

  List<Widget> _dailyLogsWidgets() {
    return [
      // TODO total count of dailyLogs
      // TODO averages of: intake protein, intake fat, intake carbs, intake 
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

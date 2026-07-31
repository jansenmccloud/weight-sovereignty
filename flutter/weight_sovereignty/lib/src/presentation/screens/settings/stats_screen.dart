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
          _expandableTileWrapper("Formulas", _infoWidgets()),
          _expandableTileWrapper("Daily Logs", _infoWidgets()),
          _expandableTileWrapper("Weight Progression", _infoWidgets()),
          _expandableTileWrapper("Calories", _infoWidgets()),
          _expandableTileWrapper("Workouts", _infoWidgets()),
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

  List<Widget> _infoWidgets() {
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
        subtitle: Text('Cardio: light=2.9, moderate=3.3, intense=5.3\nLifting: light=3.5, moderate=4.5, intense=6.0', style: TextStyle(color: AppTheme.white)),
      ),
    ];
  }
}

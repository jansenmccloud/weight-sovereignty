import 'package:flutter/material.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/dailylog_config_list_screen.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/exercise_config_list_screen.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/food_config_list_screen.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/workout_config_list_screen.dart';

class SettingsHubScreen extends StatelessWidget {
  const SettingsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Presets & settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.restaurant_outlined),
            title: const Text('Food presets'),
            subtitle: const Text('Recurring meals and macros'),
            onTap: () => _open(context, const FoodConfigListScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center_outlined),
            title: const Text('Exercise presets'),
            subtitle: const Text('Templates for strength and cardio'),
            onTap: () => _open(context, const ExerciseConfigListScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.view_list_outlined),
            title: const Text('Workout templates'),
            subtitle: const Text('Named workouts built from exercises'),
            onTap: () => _open(context, const WorkoutConfigListScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.monitor_weight_outlined),
            title: const Text('Daily log profiles'),
            subtitle: const Text('BMR and baseline presets'),
            onTap: () => _open(context, const DailyLogConfigListScreen()),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}

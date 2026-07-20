import 'package:flutter/material.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/dailylog_config_list_screen.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/debug_screen.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/exercise_config_list_screen.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/food_config_list_screen.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/workout_config_list_screen.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

class SettingsHubScreen extends StatelessWidget {
  const SettingsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Presets & settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.restaurant_outlined, color: AppTheme.white),
            title: const Text('Food presets', style: TextStyle(color: AppTheme.white)),
            subtitle: const Text('Recurring meals and macros', style: TextStyle(color: AppTheme.grey)),
            onTap: () => _open(context, const FoodConfigListScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center_outlined, color: AppTheme.white),
            title: const Text('Exercise presets', style: TextStyle(color: AppTheme.white)),
            subtitle: const Text('Templates for strength and cardio', style: TextStyle(color: AppTheme.grey)),
            onTap: () => _open(context, const ExerciseConfigListScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.view_list_outlined, color: AppTheme.white),
            title: const Text('Workout templates', style: TextStyle(color: AppTheme.white)),
            subtitle: const Text('Named workouts built from exercises', style: TextStyle(color: AppTheme.grey)),
            onTap: () => _open(context, const WorkoutConfigListScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.monitor_weight_outlined, color: AppTheme.white),
            title: const Text('Daily log profiles', style: TextStyle(color: AppTheme.white)),
            subtitle: const Text('BMR and baseline presets', style: TextStyle(color: AppTheme.grey)),
            onTap: () => _open(context, const DailyLogConfigListScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.construction_outlined, color: AppTheme.white),
            title: const Text('Debug menu', style: TextStyle(color: AppTheme.white)),
            subtitle: const Text('Options for investigation', style: TextStyle(color: AppTheme.grey)),
            onTap: () => _open(context, const DebugScreen()),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}

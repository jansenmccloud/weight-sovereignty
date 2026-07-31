import 'package:flutter/material.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/dailylog_config_list_screen.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/debug_screen.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/export_screen.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/import_screen.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/exercise_config_list_screen.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/food_config_list_screen.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/stats_screen.dart';
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
            leading: const Icon(Icons.file_upload_outlined, color: AppTheme.white),
            title: const Text('Data export', style: TextStyle(color: AppTheme.white)),
            subtitle: const Text('Export DailyLog, Food, Workout as CSV', style: TextStyle(color: AppTheme.grey)),
            onTap: () => _open(context, const ExportScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.file_download_outlined, color: AppTheme.white),
            title: const Text('Import config presets', style: TextStyle(color: AppTheme.white)),
            subtitle: const Text('Import presets from JSON backup', style: TextStyle(color: AppTheme.grey)),
            onTap: () => _open(context, const ImportScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.stacked_bar_chart_sharp, color: AppTheme.white),
            title: const Text('Stats', style: TextStyle(color: AppTheme.white)),
            subtitle: const Text('Statistics about daily logs', style: TextStyle(color: AppTheme.grey)),
            onTap: () => _open(context, const StatsScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.construction_outlined, color: AppTheme.surface),
            title: const Text('Debug menu', style: TextStyle(color: AppTheme.surface)),
            subtitle: const Text('Options for investigation', style: TextStyle(color: AppTheme.surface)),
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

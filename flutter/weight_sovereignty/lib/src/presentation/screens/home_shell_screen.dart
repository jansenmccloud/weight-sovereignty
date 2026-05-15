import 'package:flutter/material.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/settings_hub_screen.dart';

class HomeShellScreen extends StatelessWidget {
  const HomeShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weight Sovereignty')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Presets & settings'),
            subtitle: const Text('Food, exercises, workouts, daily profiles'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SettingsHubScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weight_sovereignty/src/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/settings_hub_screen.dart';

class HomeShellScreen extends StatelessWidget {
  const HomeShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight Sovereignty', style:TextStyle(color: Colors.deepPurple)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Presets & settings',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SettingsHubScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: const DashboardScreen(),
    );
  }
}

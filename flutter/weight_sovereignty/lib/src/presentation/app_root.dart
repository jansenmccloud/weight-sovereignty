import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/isar_provider.dart';
import 'package:weight_sovereignty/src/presentation/screens/home_shell_screen.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isarAsync = ref.watch(isarProvider);

    return isarAsync.when(
      loading: () => MaterialApp(
        theme: AppTheme.dark(),
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, _) => MaterialApp(
        theme: AppTheme.dark(),
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Failed to open database: $error'),
            ),
          ),
        ),
      ),
      data: (_) => MaterialApp(
        title: 'Weight Sovereignty',
        theme: AppTheme.dark(),
        home: const HomeShellScreen(),
      ),
    );
  }
}

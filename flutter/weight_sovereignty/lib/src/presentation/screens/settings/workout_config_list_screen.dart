import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/workout_config/workout_config_list_notifier.dart';
import 'package:weight_sovereignty/src/domain/config/workout_config.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/workout_config_edit_screen.dart';
import 'package:weight_sovereignty/src/presentation/widgets/async_list_scaffold.dart';
import 'package:weight_sovereignty/src/presentation/widgets/config_list_tile.dart';
import 'package:weight_sovereignty/src/presentation/widgets/confirm_delete_dialog.dart';

class WorkoutConfigListScreen extends ConsumerWidget {
  const WorkoutConfigListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(workoutConfigListProvider);

    return AsyncListScaffold<WorkoutConfig>(
      title: 'Workout templates',
      asyncValue: asyncList,
      onRetry: () => ref.invalidate(workoutConfigListProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEdit(context),
        child: const Icon(Icons.add),
      ),
      itemBuilder: (context, item) {
        final count = item.exercisePresetIds?.whereType<String>().length ?? 0;
        return ConfigListTile(
          title: item.name ?? '—',
          subtitle: '$count exercise(s)',
          onTap: () => _openEdit(context, item.id),
          onDelete: () => _delete(context, ref, item),
        );
      },
    );
  }

  void _openEdit(BuildContext context, [int? id]) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WorkoutConfigEditScreen(configId: id),
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    WorkoutConfig item,
  ) async {
    if (!await confirmDelete(context, itemName: item.name)) return;
    await ref.read(workoutConfigListProvider.notifier).delete(item.id);
  }
}

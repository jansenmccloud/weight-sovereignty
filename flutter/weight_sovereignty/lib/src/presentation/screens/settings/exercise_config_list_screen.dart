import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/exercise_config/exercise_config_list_notifier.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/exercise_config_edit_screen.dart';
import 'package:weight_sovereignty/src/presentation/widgets/async_list_scaffold.dart';
import 'package:weight_sovereignty/src/presentation/widgets/config_list_tile.dart';
import 'package:weight_sovereignty/src/presentation/widgets/confirm_delete_dialog.dart';

class ExerciseConfigListScreen extends ConsumerWidget {
  const ExerciseConfigListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(exerciseConfigListProvider);

    return AsyncListScaffold<ExerciseConfig>(
      title: 'Exercise presets',
      asyncValue: asyncList,
      onRetry: () => ref.invalidate(exerciseConfigListProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEdit(context),
        child: const Icon(Icons.add),
      ),
      itemBuilder: (context, item) => ConfigListTile(
        title: item.name ?? '—',
        subtitle: '${item.type.name} · ${item.category.name}',
        onTap: () => _openEdit(context, item.id),
        onDelete: () => _delete(context, ref, item),
      ),
    );
  }

  void _openEdit(BuildContext context, [int? id]) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExerciseConfigEditScreen(configId: id),
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    ExerciseConfig item,
  ) async {
    if (!await confirmDelete(context, itemName: item.name)) return;
    await ref.read(exerciseConfigListProvider.notifier).delete(item.id);
  }
}

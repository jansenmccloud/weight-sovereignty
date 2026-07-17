import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/dailylog_config/dailylog_config_list_notifier.dart';
import 'package:weight_sovereignty/src/domain/config/dailylog_config.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/dailylog_config_edit_screen.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';
import 'package:weight_sovereignty/src/presentation/widgets/settings/async_list_scaffold.dart';
import 'package:weight_sovereignty/src/presentation/widgets/settings/config_list_tile.dart';
import 'package:weight_sovereignty/src/presentation/widgets/settings/confirm_delete_dialog.dart';

class DailyLogConfigListScreen extends ConsumerWidget {
  const DailyLogConfigListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(dailyLogConfigListProvider);

    return AsyncListScaffold<DailyLogConfig>(
      title: 'Daily log profiles',
      asyncValue: asyncList,
      onRetry: () => ref.invalidate(dailyLogConfigListProvider),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.yellow,
        foregroundColor: AppTheme.purple,
        onPressed: () => _openEdit(context),
        child: const Icon(Icons.add),
      ),
      itemBuilder: (context, item) => ConfigListTile(
        title: item.name ?? '—',
        subtitle: item.bmrCaloriesKcal != null
            ? 'BMR ${item.bmrCaloriesKcal} kcal'
            : null,
        onTap: () => _openEdit(context, item.id),
        onDelete: () => _delete(context, ref, item),
      ),
    );
  }

  void _openEdit(BuildContext context, [int? id]) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DailyLogConfigEditScreen(configId: id),
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    DailyLogConfig item,
  ) async {
    if (!await confirmDelete(context, itemName: item.name)) return;
    await ref.read(dailyLogConfigListProvider.notifier).delete(item.id);
  }
}

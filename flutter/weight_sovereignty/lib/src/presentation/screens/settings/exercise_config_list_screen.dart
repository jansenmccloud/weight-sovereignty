import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/exercise_config/exercise_config_list_notifier.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/exercise_config_edit_screen.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';
import 'package:weight_sovereignty/src/presentation/widgets/settings/async_list_scaffold.dart';
import 'package:weight_sovereignty/src/presentation/widgets/settings/config_list_tile.dart';
import 'package:weight_sovereignty/src/presentation/widgets/settings/confirm_delete_dialog.dart';

enum ExerciseSortOrder { nameAsc, nameDesc }

class ExerciseConfigListScreen extends ConsumerStatefulWidget {
  const ExerciseConfigListScreen({super.key});

  @override
  ConsumerState<ExerciseConfigListScreen> createState() => _ExerciseConfigListScreenState();
}

class _ExerciseConfigListScreenState extends ConsumerState<ExerciseConfigListScreen> {
  bool _sortAsc = true;
  ExerciseCategory? _categoryFilter;

  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(exerciseConfigListProvider);

    // Build category FilterChips
    final categoryChips = <Widget>[];
    var spacer = const SizedBox(width: 8);
    for (final category in ExerciseCategory.values) {
      if (category == ExerciseCategory.none) continue;
      categoryChips.add(
        FilterChip(
          label: Text(_categoryDisplayName(category)),
          selected: _categoryFilter == category,
          showCheckmark: false,
          selectedColor: AppTheme.purple,
          onSelected: (selected) {
            setState(() {
              _categoryFilter = selected ? category : null;
            });
          },
        ),
      );
      categoryChips.add(spacer);
    }

    // Build the header row with category chips and clear button
    Widget headerContent = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: categoryChips),
    );

    return AsyncListScaffold<ExerciseConfig>(
      title: 'Exercise presets',
      asyncValue: asyncList,
      onRetry: () => ref.invalidate(exerciseConfigListProvider),
      comparator: (a, b) => (a.name ?? '').compareTo(b.name ?? ''),
      filter: _categoryFilter != null ? (e) => e.categoryName == _categoryFilter!.name : null,
      reversed: !_sortAsc,
      header: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), child: headerContent),
      appBarActions: [
        IconButton(icon: Icon(Icons.sort_by_alpha), tooltip: _sortAsc ? 'Sort A→Z' : 'Sort Z→A', onPressed: () => setState(() => _sortAsc = !_sortAsc)),
      ],
      floatingActionButton: FloatingActionButton(backgroundColor: AppTheme.yellow, foregroundColor: AppTheme.purple, onPressed: () => _openEdit(context), child: const Icon(Icons.add)),
      itemBuilder: (context, item) =>
          ConfigListTile(title: item.name ?? '—', subtitle: '${item.type.name} · ${item.category.name}', onTap: () => _openEdit(context, item.id), onDelete: () => _delete(context, item)),
    );
  }

  String _categoryDisplayName(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.back:
        return 'Back';
      case ExerciseCategory.arms:
        return 'Arms';
      case ExerciseCategory.chest:
        return 'Chest';
      case ExerciseCategory.legs:
        return 'Legs';
      case ExerciseCategory.shoulders:
        return 'Shoulders';
      case ExerciseCategory.none:
        return '';
    }
  }

  void _openEdit(BuildContext context, [int? id]) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ExerciseConfigEditScreen(configId: id)));
  }

  Future<void> _delete(BuildContext context, ExerciseConfig item) async {
    if (!await confirmDelete(context, itemName: item.name)) return;
    await ref.read(exerciseConfigListProvider.notifier).delete(item.id);
  }
}

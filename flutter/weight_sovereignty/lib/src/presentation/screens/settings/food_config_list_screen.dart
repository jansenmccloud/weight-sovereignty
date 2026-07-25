import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/food_config/food_config_list_notifier.dart';
import 'package:weight_sovereignty/src/domain/config/food_config.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/food_config_edit_screen.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';
import 'package:weight_sovereignty/src/presentation/widgets/settings/async_list_scaffold.dart';
import 'package:weight_sovereignty/src/presentation/widgets/settings/config_list_tile.dart';
import 'package:weight_sovereignty/src/presentation/widgets/settings/confirm_delete_dialog.dart';

class FoodConfigListScreen extends ConsumerStatefulWidget {
  const FoodConfigListScreen({super.key});

  @override
  ConsumerState<FoodConfigListScreen> createState() => _FoodConfigListScreenState();
}

enum FoodSortOrder { nameAsc, nameDesc }

class _FoodConfigListScreenState extends ConsumerState<FoodConfigListScreen> {
  bool _favoritesOnly = false;
  FoodSortOrder _sortOrder = FoodSortOrder.nameAsc;

  List<FoodConfig> visible(List<FoodConfig> all) {
    List<FoodConfig> filtered = _favoritesOnly ? all.where((f) => f.favorite == true).toList() : all;
    
    // Apply sorting
    filtered = List.from(filtered)..sort((a, b) {
      int result = (a.name ?? '').compareTo(b.name ?? '');
      return _sortOrder == FoodSortOrder.nameDesc ? -result : result;
    });
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(foodConfigListProvider);

    return AsyncListScaffold<FoodConfig>(
      title: 'Food presets',
      asyncValue: asyncList,
      onRetry: () => ref.invalidate(foodConfigListProvider),
      header: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: _buildHeader(),
      ),
      appBarActions: [
        PopupMenuButton<FoodSortOrder>(
          icon: const Icon(Icons.sort),
          itemBuilder: (_) => [
            PopupMenuItem(
              value: FoodSortOrder.nameAsc,
              child: Row(
                children: [
                  Icon(Icons.check, size: 18, color: _sortOrder == FoodSortOrder.nameAsc ? Theme.of(context).colorScheme.primary : Colors.transparent),
                  const SizedBox(width: 8),
                  const Text('Name A→Z'),
                ],
              ),
            ),
            PopupMenuItem(
              value: FoodSortOrder.nameDesc,
              child: Row(
                children: [
                  Icon(Icons.check, size: 18, color: _sortOrder == FoodSortOrder.nameDesc ? Theme.of(context).colorScheme.primary : Colors.transparent),
                  const SizedBox(width: 8),
                  const Text('Name Z→A'),
                ],
              ),
            ),
          ],
          onSelected: (v) => setState(() => _sortOrder = v),
        ),
      ],
      floatingActionButton: FloatingActionButton(backgroundColor: AppTheme.yellow, foregroundColor: AppTheme.purple, onPressed: () => _openEdit(context), child: const Icon(Icons.add)),
      itemBuilder: (context, item) => ConfigListTile(title: _foodTitle(item), subtitle: _foodSubtitle(item), onTap: () => _openEdit(context, item.id), onDelete: () => _delete(context, item)),
    );
  }

  Widget _buildHeader() {
    final chip = FilterChip(label: const Text('Favorites only'), selected: _favoritesOnly, onSelected: (v) => setState(() => _favoritesOnly = v));
    
    final hasActiveFilters = _favoritesOnly || _sortOrder != FoodSortOrder.nameAsc;
    if (!hasActiveFilters) {
      return chip;
    }
    
    return Column(
      children: [
        Row(children: [chip, const SizedBox(width: 8)]),
        FilledButton.tonal(
          onPressed: () => setState(() { _favoritesOnly = false; _sortOrder = FoodSortOrder.nameAsc; }),
          child: const Text('Clear filters'),
        ),
      ],
    );
  }

  String _foodTitle(FoodConfig item) {
    final parts = <String>[];
    if (item.favorite == true) parts.add('★');
    if (item.name != null) parts.add(item.name!);
    return parts.isEmpty ? '—' : parts.join(' ');
  }

  String? _foodSubtitle(FoodConfig item) {
    final parts = <String>[];
    if (item.amountG != null) parts.add('${item.amountG}g');
    if (item.intakeCaloriesKcal != null) parts.add('${item.intakeCaloriesKcal} kcal');
    if (item.intakeProteinG != null) parts.add('P ${item.intakeProteinG}g');
    if (item.intakeCarbsG != null) parts.add('C ${item.intakeCarbsG}g');
    if (item.intakeFatG != null) parts.add('F ${item.intakeFatG}g');
    return parts.isEmpty ? null : parts.join(' · ');
  }

  void _openEdit(BuildContext context, [int? id]) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => FoodConfigEditScreen(configId: id)));
  }

  Future<void> _delete(BuildContext context, FoodConfig item) async {
    if (!await confirmDelete(context, itemName: item.name)) return;
    await ref.read(foodConfigListProvider.notifier).delete(item.id);
  }
}
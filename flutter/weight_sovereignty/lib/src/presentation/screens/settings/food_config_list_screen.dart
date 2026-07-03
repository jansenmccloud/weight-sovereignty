import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/food_config/food_config_list_notifier.dart';
import 'package:weight_sovereignty/src/domain/config/food_config.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/food_config_edit_screen.dart';
import 'package:weight_sovereignty/src/presentation/widgets/async_list_scaffold.dart';
import 'package:weight_sovereignty/src/presentation/widgets/config_list_tile.dart';
import 'package:weight_sovereignty/src/presentation/widgets/confirm_delete_dialog.dart';

class FoodConfigListScreen extends ConsumerStatefulWidget {
  const FoodConfigListScreen({super.key});

  @override
  ConsumerState<FoodConfigListScreen> createState() =>
      _FoodConfigListScreenState();
}

class _FoodConfigListScreenState extends ConsumerState<FoodConfigListScreen> {
  bool _favoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(foodConfigListProvider);

    List<FoodConfig> visible(List<FoodConfig> all) {
      if (!_favoritesOnly) return all;
      return all.where((f) => f.favorite == true).toList();
    }

    return AsyncListScaffold<FoodConfig>(
      title: 'Food presets',
      asyncValue: asyncList.whenData(visible),
      onRetry: () => ref.invalidate(foodConfigListProvider),
      header: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: FilterChip(
          label: const Text('Favorites only'),
          selected: _favoritesOnly,
          onSelected: (v) => setState(() => _favoritesOnly = v),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEdit(context),
        child: const Icon(Icons.add),
      ),
      itemBuilder: (context, item) => ConfigListTile(
        title: _foodTitle(item),
        subtitle: _foodSubtitle(item),
        onTap: () => _openEdit(context, item.id),
        onDelete: () => _delete(context, item),
      ),
    );
  }

  String _foodTitle(FoodConfig item) {
    final parts = <String>[];
    if (item.favorite == true) parts.add('★');
    if (item.name != null) parts.add('${item.name}');
    return parts.isEmpty ? '—' : parts.join(' ');
  }

  String? _foodSubtitle(FoodConfig item) {
    final parts = <String>[];
    if (item.amount != null) parts.add('${item.amount}${item.unit}');
    if (item.intakeCaloriesKcal != null) {
      parts.add('${item.intakeCaloriesKcal} kcal');
    }
    if (item.intakeProteinG != null) parts.add('P ${item.intakeProteinG}g');
    if (item.intakeCarbsG != null) parts.add('C ${item.intakeCarbsG}g');
    if (item.intakeFatG != null) parts.add('F ${item.intakeFatG}g');
    return parts.isEmpty ? null : parts.join(' · ');
  }

  void _openEdit(BuildContext context, [int? id]) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FoodConfigEditScreen(configId: id),
      ),
    );
  }

  Future<void> _delete(BuildContext context, FoodConfig item) async {
    if (!await confirmDelete(context, itemName: item.name)) return;
    await ref.read(foodConfigListProvider.notifier).delete(item.id);
  }
}

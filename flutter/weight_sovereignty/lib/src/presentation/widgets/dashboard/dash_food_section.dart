import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/providers.dart';
import 'package:weight_sovereignty/src/domain/entity/food.dart';
import 'package:weight_sovereignty/src/presentation/screens/food/add_food_screen.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

/// Section showing logged food items for the selected date.
/// Queries foods directly by targetDate (decoupled from DailyLog).
class FoodSection extends ConsumerWidget {
  final DateTime targetDate;

  const FoodSection({super.key, required this.targetDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Food',
                  style: text.titleLarge?.copyWith(color: AppTheme.white),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: AppTheme.yellow,
                  onPressed: () async {
                    await Navigator.push<void>(
                      context,
                      AddFoodScreen.route(targetDate: targetDate),
                    );
                    // Refresh food list and daily log for the selected date after returning from add food
                    ref.invalidate(foodListProvider);
                    await ref.read(dailyLogServiceProvider).refreshForDay(targetDate);
                    await ref.read(dailyLogListProvider.notifier).refresh();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            FutureBuilder<List<Food>>(
              future: ref
                  .read(foodListProvider.notifier)
                  .listByCalendarDay(targetDate),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text(
                    'Error loading food: ${snapshot.error}',
                    style: text.bodyMedium?.copyWith(color: AppTheme.red),
                  );
                }
                final foods = snapshot.data ?? <Food>[];
                if (foods.isEmpty) {
                  return Text(
                    'No food logged yet',
                    style: text.bodyMedium?.copyWith(color: AppTheme.grey),
                  );
                }
                return Column(
                  children: [
                    for (final food in foods)
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          '${food.foodBase?.name ?? 'Unknown'} · ${food.foodBase?.amountG ?? 100}g',
                          style: TextStyle(color: AppTheme.white),
                        ),
                        subtitle: Text(
                          'Kcal: ${food.foodBase?.intakeCaloriesKcal ?? 0}, P: ${food.foodBase?.intakeProteinG ?? 0}g, C: ${food.foodBase?.intakeCarbsG ?? 0}g, F: ${food.foodBase?.intakeFatG ?? 0}g',
                          style: TextStyle(color: AppTheme.grey),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Delete button for this food entry
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: AppTheme.purple,
                              iconSize: 18.0,
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete food entry?'),
                                    content: Text('Remove "${food.foodBase?.name}" from ${targetDate.day}/${targetDate.month}/${targetDate.year}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        style: TextButton.styleFrom(foregroundColor: AppTheme.red),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed == true) {
                                  final service = ref.read(dailyLogServiceProvider);
                                  await service.deleteFoodByDate(food, targetDate);
                                  await service.refreshForDay(targetDate);
                                  await ref.read(dailyLogListProvider.notifier).refresh();
                                  ref.invalidate(foodListProvider);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 6),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
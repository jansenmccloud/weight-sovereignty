import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/food/food_list_notifier.dart';
import 'package:weight_sovereignty/src/application/dailylog/daily_log_service.dart';
import 'package:weight_sovereignty/src/application/providers/service_providers.dart';
import 'package:weight_sovereignty/src/domain/entity/food.dart';
import 'package:weight_sovereignty/src/presentation/screens/food/add_food_screen.dart';

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
                  style: text.titleLarge?.copyWith(color: Colors.white70),
                ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () async {
                        await Navigator.push<int>(
                          context,
                          AddFoodScreen.route(targetDate: targetDate),
                        );
                        // Refresh food list and daily log after returning from add food
                        ref.invalidate(foodListProvider);
                        ref.read(dailyLogServiceProvider.notifier).refreshToday();
                      },
                    ),
              ],
            ),
            const SizedBox(height: 12),

            FutureBuilder<List<Food>>(
              future: ref
                  .read(foodListProvider.notifier)
                  .listByDate(targetDate),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text(
                    'Error loading food: ${snapshot.error}',
                    style: text.bodyMedium?.copyWith(color: Colors.redAccent),
                  );
                }
                final foods = snapshot.data ?? <Food>[];
                if (foods.isEmpty) {
                  return Text(
                    'No food logged yet',
                    style: text.bodyMedium?.copyWith(color: Colors.white38),
                  );
                }
                return Column(
                  children: [
                    for (final food in foods)
                      ListTile(
                        title: Text(food.foodBase?.name ?? 'Unknown'),
                        subtitle: Text(
                          'Kcal: ${food.foodBase?.intakeCaloriesKcal ?? 0}, P: ${food.foodBase?.intakeProteinG ?? 0}g, C: ${food.foodBase?.intakeCarbsG ?? 0}g, F: ${food.foodBase?.intakeFatG ?? 0}g',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Delete button for this food entry
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.redAccent,
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
                                        style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed == true) {
                                  // Delete the food entry by date
                                  await ref.read(dailyLogServiceProvider).deleteFoodByDate(food, targetDate);
                                   // Refresh food list and daily log
                                   ref.invalidate(foodListProvider);
                                   ref.read(dailyLogServiceProvider.notifier).refreshToday();
                                }
                              },
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
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
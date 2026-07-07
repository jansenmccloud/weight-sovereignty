import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/food/food_list_notifier.dart';
import 'package:weight_sovereignty/src/application/dailylog/dailylog_list_notifier.dart' show dailyLogListProvider;
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/domain/entity/food.dart';
import 'package:weight_sovereignty/src/presentation/screens/food/add_food_screen.dart';

/// Section showing logged food items for the selected date.
class FoodSection extends ConsumerWidget {
  final List<int?>? foodIds;

  const FoodSection({super.key, required this.foodIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final foodIdsList = foodIds?.whereType<int>().toList() ?? [];

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
                    final result = await Navigator.push<DailyLog?>(
                      context,
                      AddFoodScreen.route(targetDate: DateTime.now()),
                    );
                    if (result != null) {
                      // Trigger a refresh of the daily log provider to update the dashboard
                      ref.invalidate(dailyLogListProvider);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (foodIdsList.isEmpty)
              Text(
                'No food logged yet',
                style: text.bodyMedium?.copyWith(color: Colors.white38),
              )
            else
              FutureBuilder<List<Food>>(
                future: ref
                    .read(foodListProvider.notifier)
                    .listByIds(foodIdsList),
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
                          trailing: const Icon(Icons.chevron_right),
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

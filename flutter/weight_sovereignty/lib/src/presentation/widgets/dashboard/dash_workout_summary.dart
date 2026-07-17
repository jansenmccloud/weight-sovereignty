import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/providers.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/presentation/screens/workout/add_workout_screen.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

/// Section showing logged workouts for the selected date.
class WorkoutSummary extends ConsumerWidget {
  final DateTime targetDate;

  const WorkoutSummary({super.key, required this.targetDate});

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
                  'Workout',
                  style: text.titleLarge?.copyWith(color: AppTheme.white),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: AppTheme.yellow,
                  onPressed: () async {
                    await Navigator.push<void>(
                      context,
                      AddWorkoutScreen.route(targetDate: targetDate),
                    );
                    // Refresh workout list and daily log for the selected date after returning from add workout
                    ref.invalidate(workoutListProvider);
                    await ref
                        .read(dailyLogServiceProvider)
                        .refreshForDay(targetDate);
                    await ref.read(dailyLogListProvider.notifier).refresh();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            FutureBuilder<List<Workout>>(
              future: ref
                  .read(workoutListProvider.notifier)
                  .listByCalendarDay(targetDate),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text(
                    'Error loading workouts: ${snapshot.error}',
                    style: text.bodyMedium?.copyWith(color: AppTheme.red),
                  );
                }
                final workouts = snapshot.data ?? <Workout>[];
                if (workouts.isEmpty) {
                  return Text(
                    'No workouts logged yet',
                    style: text.bodyMedium?.copyWith(color: AppTheme.grey),
                  );
                }
                return Column(
                  children: [
                    for (final workout in workouts)
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          workout.workoutBase?.name ?? 'Unknown Workout',
                          style: TextStyle(color: AppTheme.white),
                        ),
                        subtitle: Text(
                          'Burn: ${_sumWorkoutBurn(workout.exercises)} kcal',
                          style: TextStyle(color: AppTheme.grey),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Edit button
                            IconButton(
                              icon: const Icon(Icons.fitness_center_sharp),
                              color: AppTheme.yellow,
                              iconSize: 22.0,
                              onPressed: () {}, // TODO open edit screen
                            ),
                            const SizedBox(height: 60),
                            // Delete button for this workout entry
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: AppTheme.purple,
                              iconSize: 18.0,
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete workout entry?'),
                                    content: Text(
                                      'Remove "${workout.workoutBase?.name}" from ${targetDate.day}/${targetDate.month}/${targetDate.year}?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppTheme.red,
                                        ),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed == true) {
                                  final service = ref.read(
                                    dailyLogServiceProvider,
                                  );
                                  await service.deleteWorkoutByDate(
                                    workout,
                                    targetDate,
                                  );
                                  await service.refreshForDay(targetDate);
                                  await ref
                                      .read(dailyLogListProvider.notifier)
                                      .refresh();
                                  ref.invalidate(foodListProvider);
                                }
                              },
                            ),
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

/// Helper to sum burned calories from a list of ExerciseBase.
int _sumWorkoutBurn(List<ExerciseBase?>? exercises) {
  int total = 0;
  if (exercises == null) return total;
  for (final ex in exercises) {
    total += ex?.burnedCaloriesKcal ?? 0;
  }
  return total;
}

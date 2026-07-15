import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/providers.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/presentation/screens/workout/add_workout_screen.dart';

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
                  style: text.titleLarge?.copyWith(color: Colors.white70),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: Colors.deepPurple,
                  onPressed: () async {
                    await Navigator.push<void>(
                      context,
                      AddWorkoutScreen.route(targetDate: targetDate),
                    );
                    // Refresh workout list and daily log for the selected date after returning from add workout
                    ref.invalidate(workoutListProvider);
                    await ref.read(dailyLogServiceProvider).refreshForDay(targetDate);
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
                    style: text.bodyMedium?.copyWith(color: Colors.redAccent),
                  );
                }
                final workouts = snapshot.data ?? <Workout>[];
                if (workouts.isEmpty) {
                  return Text(
                    'No workouts logged yet',
                    style: text.bodyMedium?.copyWith(color: Colors.white38),
                  );
                }
                return Column(
                  children: [
                    for (final workout in workouts)
                      ListTile(
                        title: Text(
                          workout.workoutBase?.name ?? 'Unknown Workout',
                        ),
                        subtitle: Text(
                          'Burn: ${_sumWorkoutBurn(workout.exercises)} kcal',
                        ),
                        // TODO add missing operation buttons delete and edit
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

/// Helper to sum burned calories from a list of ExerciseBase.
int _sumWorkoutBurn(List<ExerciseBase?>? exercises) {
  int total = 0;
  if (exercises == null) return total;
  for (final ex in exercises) {
    total += ex?.burnedCaloriesKcal ?? 0;
  }
  return total;
}
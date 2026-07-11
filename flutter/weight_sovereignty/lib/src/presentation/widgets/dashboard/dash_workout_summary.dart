import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/providers.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';

/// Section showing logged workouts for the selected date.
class WorkoutSummary extends ConsumerWidget {
  final List<int?>? workoutIds;

  const WorkoutSummary({super.key, required this.workoutIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final workoutIdsList = workoutIds?.whereType<int>().toList() ?? [];

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
                  onPressed: () {
                    // TODO: open workout session / add existing workout
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (workoutIdsList.isEmpty)
              Text(
                'No workouts logged yet',
                style: text.bodyMedium?.copyWith(color: Colors.white38),
              )
            else
              FutureBuilder<List<Workout>>(
                future: ref
                    .read(workoutListProvider.notifier)
                    .listByIds(workoutIdsList),
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
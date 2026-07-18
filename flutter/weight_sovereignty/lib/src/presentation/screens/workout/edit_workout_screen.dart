import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/presentation/widgets/workout/exercise_item_edit_widget.dart';

/// Screen to edit workouts
class EditWorkoutScreen extends ConsumerStatefulWidget {
  final DateTime targetDate;
  final Workout targetWorkout;

  const EditWorkoutScreen({super.key, required this.targetDate, required this.targetWorkout});

  static Route<void> route({required DateTime targetDate, required Workout targetWorkout}) {
    return MaterialPageRoute(
      builder: (_) => EditWorkoutScreen(targetDate: targetDate, targetWorkout: targetWorkout),
      settings: const RouteSettings(name: 'edit_workout'),
    );
  }

  @override
  ConsumerState<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends ConsumerState<EditWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    final currentWorkout = widget.targetWorkout;

    return Scaffold(
      appBar: AppBar(title: Text('Workout ${currentWorkout.workoutBase?.name ?? 'Unknown'}')),
      body: Column(
        children: [
          // exercise list
          Expanded(
            child: ListView.builder(
              itemCount: currentWorkout.exercises?.length ?? 0,
              itemBuilder: (context, index) {
                  return ExerciseItemEditWidget(
                    workout: currentWorkout,
                    exerciseIndex: index,
                  );
                },
            ),
          ),
          // TODO add button to open exercise selection screen to select an extra exercise for current workout
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/providers.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/presentation/screens/workout/add_exercise_screen.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';
import 'package:weight_sovereignty/src/presentation/widgets/workout/exercise_item_edit_widget.dart';

/// Screen to edit workouts
class EditWorkoutScreen extends ConsumerStatefulWidget {
  final DateTime targetDate;
  final Workout targetWorkout;
  final double bodyWeight;

  const EditWorkoutScreen({super.key, required this.targetDate, required this.targetWorkout, required this.bodyWeight});

  static Route<void> route({required DateTime targetDate, required Workout targetWorkout, required double bodyWeight}) {
    return MaterialPageRoute(
      builder: (_) => EditWorkoutScreen(targetDate: targetDate, targetWorkout: targetWorkout, bodyWeight: bodyWeight),
      settings: const RouteSettings(name: 'edit_workout'),
    );
  }

  @override
  ConsumerState<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends ConsumerState<EditWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    Workout currentWorkout = widget.targetWorkout;
    final bodyWeight = widget.bodyWeight;

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout ${currentWorkout.workoutBase?.name ?? 'Unknown'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppTheme.purple),
            tooltip: 'Add Exercise',
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AddExerciseScreen(workout: currentWorkout)));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // exercise list
          Expanded(
            child: ListView.builder(
              itemCount: currentWorkout.exercises?.length ?? 0,
              itemBuilder: (context, index) {
                return ExerciseItemEditWidget(workout: currentWorkout, exerciseIndex: index, bodyWeight: bodyWeight);
              },
            ),
          ),
        ],
      ),
    );
  }
}

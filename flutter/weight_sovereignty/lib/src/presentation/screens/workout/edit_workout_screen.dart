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
  final int targetWorkoutId;
  final double bodyWeight;

  const EditWorkoutScreen({super.key, required this.targetDate, required this.targetWorkoutId, required this.bodyWeight});

  static Route<void> route({required DateTime targetDate, required int targetWorkoutId, required double bodyWeight}) {
    return MaterialPageRoute(
      builder: (_) => EditWorkoutScreen(targetDate: targetDate, targetWorkoutId: targetWorkoutId, bodyWeight: bodyWeight),
      settings: const RouteSettings(name: 'edit_workout'),
    );
  }

  @override
  ConsumerState<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends ConsumerState<EditWorkoutScreen> {
  late Workout currentWorkout;
  late double bodyWeight;

  @override
  Future<void> initState() async {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    try {
      final w = await ref.read(workoutRepositoryProvider).getById(widget.targetWorkoutId);

      if (!mounted) return;

      setState(() {
        currentWorkout = w!;
        bodyWeight = widget.bodyWeight;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout ${currentWorkout.workoutBase?.name ?? 'Unknown'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppTheme.purple),
            tooltip: 'Add Exercise',
            onPressed: () async {
              final result = await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AddExerciseScreen(workout: currentWorkout)));
              if(mounted){
                setState(() {
                  currentWorkout = result as Workout;
                });
              }
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

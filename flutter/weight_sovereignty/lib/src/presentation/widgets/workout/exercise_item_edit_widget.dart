import 'package:flutter/material.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

/// Widget for editing a workout exercise
class ExerciseItemEditWidget extends StatefulWidget {
  final Workout workout;
  final int exerciseIndex;

  const ExerciseItemEditWidget({super.key, required this.workout, required this.exerciseIndex});

  @override
  State<ExerciseItemEditWidget> createState() => _ExerciseItemEditWidgetState();
}

class _ExerciseItemEditWidgetState extends State<ExerciseItemEditWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final Workout workout = widget.workout;
    final int index = widget.exerciseIndex;
    final ExerciseBase? exercise = workout.exercises![index];

    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.surfaceContainerHighest.withAlpha((255 * 0.3).round());

    return Container(
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Material(
        color: AppTheme.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exercise?.name ?? 'Unnamed Exercise', 
                      style: theme.textTheme.titleMedium?.copyWith(color: AppTheme.white)),
                      // TODO print category, itensity, type, burnedCalories
                      // TODO if type == cardio => show distance input, duration input
                      // TODO if type == lifting => show sets input combined with weight and reps input and finished flag
                      // TODO calculate burned calories and save on flag finished + add up all burned +  save workout
                      // TODO add set button
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

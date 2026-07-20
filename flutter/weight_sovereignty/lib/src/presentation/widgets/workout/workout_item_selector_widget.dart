import 'package:flutter/material.dart';
import 'package:weight_sovereignty/src/domain/config/workout_config.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

/// Widget for selecting workout
class WorkoutItemSelectorWidget extends StatefulWidget {
  final WorkoutConfig workoutConfig;
  final VoidCallback onSelect;
  final VoidCallback onDeselect;

  const WorkoutItemSelectorWidget({super.key, required this.workoutConfig, required this.onSelect, required this.onDeselect});

  @override
  State<WorkoutItemSelectorWidget> createState() => _WorkoutItemSelectorWidgetState();
}

class _WorkoutItemSelectorWidgetState extends State<WorkoutItemSelectorWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final WorkoutConfig workoutConfig = widget.workoutConfig;
    final VoidCallback onSelect = widget.onSelect;
    final VoidCallback onDeselect = widget.onDeselect;
    final theme = Theme.of(context);

    Color getColor(Set<WidgetState> states) {
      return AppTheme.purple;
    }

    final backgroundColor = theme.colorScheme.surfaceContainerHighest.withAlpha((255 * 0.3).ceil());

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
                    children: [Text(workoutConfig.name ?? 'Unnamed Workout', style: theme.textTheme.titleMedium?.copyWith(color: AppTheme.white))],
                  ),
                ),
                // Checkbox
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Checkbox(
                    side: BorderSide(color: AppTheme.grey),
                    checkColor: AppTheme.yellow,
                    fillColor: WidgetStateProperty.resolveWith(getColor),
                    focusColor: AppTheme.yellow,
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                      if (value!) {
                        onSelect();
                      } else {
                        onDeselect();
                      }
                    },
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

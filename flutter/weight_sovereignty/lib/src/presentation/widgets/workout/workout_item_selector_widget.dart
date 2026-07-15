import 'package:flutter/material.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';

/// A selectable card widget for picking an ExerciseConfig preset on AddWorkoutScreen.
class WorkoutItemSelectorWidget extends StatelessWidget { // TODO why stateless?
  final ExerciseConfig exerciseConfig;
  final int selectedCount;
  // TODO see food callbacks
  final VoidCallback onTap;

  const WorkoutItemSelectorWidget({
    super.key,
    required this.exerciseConfig,
    required this.selectedCount,
    required this.onTap,
  });

  bool get isSelected => selectedCount > 0;

  /// Build a short detail string like "3x12 · 80kg" or "5km · 30min".
  String _detailText() {
    final parts = <String>[];
    if (exerciseConfig.reps != null && exerciseConfig.sets != null) {
      parts.add('${exerciseConfig.sets}x${exerciseConfig.reps}');
    }
    if (exerciseConfig.weightKg != null) {
      parts.add('${exerciseConfig.weightKg}kg');
    }
    if (exerciseConfig.distanceKm != null && exerciseConfig.distanceKm! > 0) {
      parts.add('${exerciseConfig.distanceKm}km');
    }
    if (exerciseConfig.durationMin != null && exerciseConfig.durationMin! > 0) {
      parts.add('${exerciseConfig.durationMin}min');
    }
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withAlpha((255 * 0.15).round())
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Selection checkbox
            Checkbox(
              value: isSelected,
              onChanged: (_) => onTap(),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exerciseConfig.name ?? 'Unknown Exercise',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _detailText(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: (theme.textTheme.bodySmall?.color ?? Colors.black).withAlpha((255 * 0.7).round()),
                    ),
                  ),
                ],
              ),
            ),
            // Burned calories badge
            if (exerciseConfig.burnedCaloriesKcal != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withAlpha((255 * 0.15).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${exerciseConfig.burnedCaloriesKcal} kcal',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:weight_sovereignty/src/domain/config/food_config.dart';

/// Widget for selecting a food and adjusting its amount.
/// When [amount] is 0, the food is considered deselected.
class FoodItemSelectorWidget extends StatelessWidget {
  final FoodConfig foodConfig;
  final double amount;
  final ValueChanged<double> onAmountChanged;
  final VoidCallback? onDelete;

  const FoodItemSelectorWidget({
    super.key,
    required this.foodConfig,
    required this.amount,
    required this.onAmountChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // FoodConfig stores macros directly (no foodBase getter)
    final cal =
        ((foodConfig.intakeCaloriesKcal ?? 0).toDouble() *
                amount /
                (foodConfig.amount?.toDouble() ?? 100.0))
            .round();
    final protein =
        (foodConfig.intakeProteinG ?? 0) *
        amount /
        (foodConfig.amount?.toDouble() ?? 100.0);
    final fat =
        (foodConfig.intakeFatG ?? 0) *
        amount /
        (foodConfig.amount?.toDouble() ?? 100.0);
    final carbs =
        (foodConfig.intakeCarbsG ?? 0) *
        amount /
        (foodConfig.amount?.toDouble() ?? 100.0);

    // Visual state: dimmed when deselected
    final isDeselected = amount <= 0;
    final opacity = isDeselected ? 0.4 : 1.0;
    final backgroundColor = isDeselected
        ? Colors.transparent
        : theme.colorScheme.surfaceContainerHighest.withAlpha(
            (255 * 0.3).round(),
          );

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: !isDeselected
              ? () {
                  // Tap body toggles to minimum if currently at 0
                  if (amount <= 0) {
                    onAmountChanged(foodConfig.amount?.toDouble() ?? 100.0);
                  }
                }
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                // Food icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isDeselected
                        ? theme.colorScheme.onSurface.withAlpha(
                            (255 * 0.1).round(),
                          )
                        : theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.restaurant_menu,
                    color: isDeselected
                        ? theme.colorScheme.onSurface.withAlpha(
                            (255 * 0.3).round(),
                          )
                        : theme.colorScheme.onPrimaryContainer,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodConfig.name ?? 'Unnamed Food',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          decoration: isDeselected
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (isDeselected)
                        Text(
                          'Tapped to deselect — set amount > 0 to add',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      else
                        Text(
                          '${cal.toStringAsFixed(0)} kcal · P:${protein.toStringAsFixed(1)}g F:${fat.toStringAsFixed(1)}g C:${carbs.toStringAsFixed(1)}g',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(
                              (255 * 0.7).round(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Amount controls (only when selected)
                if (!isDeselected)
                  SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        Text(
                          '${amount.toStringAsFixed(0)}g',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Slider(
                          value: amount,
                          min: 0.0,
                          max: (foodConfig.amount?.toDouble() ?? 100.0) * 3,
                          divisions: 30,
                          label: '${amount.toStringAsFixed(0)}g',
                          onChanged: onAmountChanged,
                        ),
                      ],
                    ),
                  ),
                // Delete button
                if (onDelete != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDeselected
                            ? theme.colorScheme.onSurface.withAlpha(
                                (255 * 0.2).round(),
                              )
                            : theme.colorScheme.error,
                        size: 24,
                      ),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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

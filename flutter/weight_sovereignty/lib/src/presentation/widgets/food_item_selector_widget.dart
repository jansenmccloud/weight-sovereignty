import 'package:flutter/material.dart';
import 'package:weight_sovereignty/src/domain/config/food_config.dart';

/// Widget for selecting a food and adjusting its amount.
class FoodItemSelectorWidget extends StatelessWidget {
  final FoodConfig foodConfig;
  final double amount;
  final ValueChanged<double> onAmountChanged;

  const FoodItemSelectorWidget({
    super.key,
    required this.foodConfig,
    required this.amount,
    required this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // FoodConfig stores macros directly (no foodBase getter)
    final cal = (foodConfig.intakeCaloriesKcal ?? 0).toDouble() * amount;
    final protein = (foodConfig.intakeProteinG ?? 0) * amount;
    final fat = (foodConfig.intakeFatG ?? 0) * amount;
    final carbs = (foodConfig.intakeCarbsG ?? 0) * amount;

    return InkWell(
      onTap: () {
        // Allow amount adjustment via dialog or inline
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            // Food icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.restaurant_menu,
                color: theme.colorScheme.onPrimaryContainer,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Food name and macros
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodConfig.name ?? 'Unnamed Food',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${cal.toStringAsFixed(0)} kcal · P:${protein.toStringAsFixed(1)}g F:${fat.toStringAsFixed(1)}g C:${carbs.toStringAsFixed(1)}g',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha((255 * 0.7).round()),
                    ),
                  ),
                ],
              ),
            ),
            // Amount slider
            SizedBox(
              width: 120,
              child: Column(
                children: [
                  // Display amount
                  Text(
                    '${amount.toStringAsFixed(1)}x',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Slider(
                    value: amount,
                    min: 0.0,
                    max: 3.0,
                    divisions: 30,
                    label: amount.toStringAsFixed(1),
                    onChanged: onAmountChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
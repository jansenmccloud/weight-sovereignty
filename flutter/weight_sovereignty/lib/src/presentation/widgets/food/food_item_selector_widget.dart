import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weight_sovereignty/src/domain/config/food_config.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

/// Widget for selecting a food and adjusting its amount.
class FoodItemSelectorWidget extends StatefulWidget {
  final FoodConfig foodConfig;
  final int amount;
  final ValueChanged<int> onAmountChanged;
  final VoidCallback onSelect;
  final VoidCallback onDeselect;

  const FoodItemSelectorWidget({super.key, required this.foodConfig, required this.amount, required this.onAmountChanged, required this.onSelect, required this.onDeselect});

  @override
  State<FoodItemSelectorWidget> createState() => _FoodItemSelectorWidgetState();
}

class _FoodItemSelectorWidgetState extends State<FoodItemSelectorWidget> {
  final digitsOnly = FilteringTextInputFormatter.digitsOnly;
  late TextEditingController _amountController;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.amount.toString());
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FoodConfig foodConfig = widget.foodConfig;
    final int amount = widget.amount;
    final ValueChanged<int> onAmountChanged = widget.onAmountChanged;
    final VoidCallback onSelect = widget.onSelect;
    final VoidCallback onDeselect = widget.onDeselect;
    final theme = Theme.of(context);

    Color getColor(Set<WidgetState> states) {
      return AppTheme.purple;
    }

    // FoodConfig stores macros directly (no foodBase getter)
    final cal = ((foodConfig.intakeCaloriesKcal ?? 0).toDouble() * amount / (foodConfig.amountG ?? 100)).ceil();
    final protein = (foodConfig.intakeProteinG ?? 0) * amount / (foodConfig.amountG ?? 100);
    final fat = (foodConfig.intakeFatG ?? 0) * amount / (foodConfig.amountG ?? 100);
    final carbs = (foodConfig.intakeCarbsG ?? 0) * amount / (foodConfig.amountG ?? 100);

    final backgroundColor = theme.colorScheme.surfaceContainerHighest.withAlpha((255 * 0.3).ceil());

    return Container(
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Material(
        color: AppTheme.transparent,
        child: InkWell(
          onTap: () {
            if (amount <= 0) {
              onAmountChanged(foodConfig.amountG ?? 100);
            }
          },
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
                      Text(foodConfig.name ?? 'Unnamed Food', style: theme.textTheme.titleMedium?.copyWith(color: AppTheme.white)),
                      const SizedBox(height: 2),
                      Text(
                        '${cal.toStringAsFixed(0)} kcal\nP: ${protein.toStringAsFixed(0)}g\nF: ${fat.toStringAsFixed(0)}g\nC: ${carbs.toStringAsFixed(0)}g',
                        style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [digitsOnly],
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null && parsed >= 0) {
                        onAmountChanged(parsed);
                      }
                    },
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge?.copyWith(color: AppTheme.white),
                    decoration: const InputDecoration(
                      labelText: 'g',
                      labelStyle: TextStyle(color: AppTheme.white),
                    ),
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

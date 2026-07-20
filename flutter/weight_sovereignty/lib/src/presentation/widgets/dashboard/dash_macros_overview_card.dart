import 'package:flutter/material.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

/// Card displaying macros overview.
class MacrosOverviewCard extends StatelessWidget {
  final int intakeProtein;
  final int intakeFat;
  final int intakeCarbs;
  final int plannedProtein;
  final int plannedFat;
  final int plannedCarbs;

  const MacrosOverviewCard({
    super.key,
    required this.intakeProtein,
    required this.intakeFat,
    required this.intakeCarbs,
    required this.plannedProtein,
    required this.plannedFat,
    required this.plannedCarbs,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Macros', style: text.titleMedium?.copyWith(color: AppTheme.white)),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Protein', style: text.bodyMedium?.copyWith(color: AppTheme.white)),
                    Text('Fat    ', style: text.bodyMedium?.copyWith(color: AppTheme.white)),
                    Text('Carbs  ', style: text.bodyMedium?.copyWith(color: AppTheme.white)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${plannedProtein}g', style: text.bodyMedium?.copyWith(color: AppTheme.white)),
                    Text('${plannedFat}g', style: text.bodyMedium?.copyWith(color: AppTheme.white)),
                    Text('${plannedCarbs}g', style: text.bodyMedium?.copyWith(color: AppTheme.white)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('- ${intakeProtein}g', style: text.bodyMedium?.copyWith(color: AppTheme.purple)),
                    Text('- ${intakeFat}g', style: text.bodyMedium?.copyWith(color: AppTheme.purple)),
                    Text('- ${intakeCarbs}g', style: text.bodyMedium?.copyWith(color: AppTheme.purple)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${plannedProtein - intakeProtein}g', style: text.bodyMedium?.copyWith(color: AppTheme.yellow)),
                    Text('${plannedFat - intakeFat}g', style: text.bodyMedium?.copyWith(color: AppTheme.yellow)),
                    Text('${plannedCarbs - intakeCarbs}g', style: text.bodyMedium?.copyWith(color: AppTheme.yellow)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

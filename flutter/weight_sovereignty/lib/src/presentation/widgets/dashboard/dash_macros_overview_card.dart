import 'package:flutter/material.dart';

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
            Text(
              'Macros',
              style: text.titleMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Protein', style: text.bodyMedium),
                    Text('Fat    ', style: text.bodyMedium),
                    Text('Carbs  ', style: text.bodyMedium),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${plannedProtein}g', style: text.bodyMedium),
                    Text('${plannedFat}g', style: text.bodyMedium),
                    Text('${plannedCarbs}g', style: text.bodyMedium),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('- ${intakeProtein}g', style: text.bodyMedium?.copyWith(color: Colors.deepPurple)),
                    Text('- ${intakeFat}g', style: text.bodyMedium?.copyWith(color: Colors.deepPurple)),
                    Text('- ${intakeCarbs}g', style: text.bodyMedium?.copyWith(color: Colors.deepPurple)),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${plannedProtein-intakeProtein}g', style: text.bodyMedium?.copyWith(color: Colors.yellowAccent)),
                    Text('${plannedFat-intakeFat}g', style: text.bodyMedium?.copyWith(color: Colors.yellowAccent)),
                    Text('${plannedCarbs-intakeCarbs}g', style: text.bodyMedium?.copyWith(color: Colors.yellowAccent)),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

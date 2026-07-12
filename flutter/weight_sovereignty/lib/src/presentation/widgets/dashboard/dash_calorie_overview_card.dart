import 'package:flutter/material.dart';

/// Card displaying calorie overview (BMR, intake, burn, net surplus/deficit).
class CalorieOverviewCard extends StatelessWidget {
  final int bmr;
  final int intake;
  final int burn;
  final int deficit;
  final int netSurplus;

  const CalorieOverviewCard({
    super.key,
    required this.bmr,
    required this.intake,
    required this.burn,
    required this.deficit,
    required this.netSurplus,
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
              'Calories',
              style: text.titleMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 12),

            // BMR baseline
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('BMR Baseline', style: text.bodyMedium),
                Text('$bmr kcal', style: text.bodyMedium),
              ],
            ),
            const SizedBox(height: 4),

            // Intake
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text( 'Intake', style: text.bodyMedium),
                Text('$intake kcal', style: text.bodyMedium),
              ],
            ),
            const Divider(height: 24),

            // Burned
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Burned', 
                  style: text.bodyMedium?.copyWith(color: Colors.redAccent),
                  ),
                Text('$burn kcal', style: text.bodyMedium?.copyWith(color: Colors.redAccent)),
              ],
            ),
            const SizedBox(height: 4),

            // Deficit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deficit', 
                  style: text.bodyMedium?.copyWith(color: Colors.redAccent),
                  ),
                Text('$deficit kcal', style: text.bodyMedium?.copyWith(color: Colors.redAccent)),
              ],
            ),
            const Divider(height: 24),

            // Net Surplus/Deficit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Net',
                  style: text.bodyMedium?.copyWith(fontWeight: FontWeight.bold,color: Colors.yellowAccent),
                ),
                Text(
                  '$netSurplus kcal',
                  style: text.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: netSurplus > 0
                        ? Colors.yellowAccent
                        : netSurplus < 0
                        ? Colors.redAccent
                        : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

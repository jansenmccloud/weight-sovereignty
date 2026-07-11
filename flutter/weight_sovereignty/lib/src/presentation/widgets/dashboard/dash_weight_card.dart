import 'package:flutter/material.dart';

/// Card displaying daily weight with entry option.
class WeightCard extends StatelessWidget {
  final double? weight;
  final VoidCallback onPressEntry;

  const WeightCard({
    super.key,
    required this.weight,
    required this.onPressEntry,
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
              'Weight',
              style: text.titleMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            if (weight != null)
              GestureDetector(
                onTap: onPressEntry,
                child: Text(
                  '${weight!.toStringAsFixed(1)} kg',
                  style: text.displaySmall?.copyWith(fontSize: 32),
                ),
              )
            else
              GestureDetector(
                onTap: onPressEntry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Tap to enter weight',
                    style: text.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

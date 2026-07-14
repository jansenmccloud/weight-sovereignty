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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Weight', style: text.titleMedium?.copyWith(color: Colors.white70)),
            const SizedBox(height: 8),
              GestureDetector(
                onTap: onPressEntry,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('<<'),
                    Text('${weight!.toStringAsFixed(1)} kg', style: text.bodyMedium?.copyWith(fontSize: 32)),
                    Text('>>'),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/providers.dart';

// TODO delete screen after transferred to dashboard view

/// Screen for entering morning body weight.
class MorningWeightScreen extends ConsumerStatefulWidget {
  const MorningWeightScreen({super.key});

  @override
  ConsumerState<MorningWeightScreen> createState() =>
      _MorningWeightScreenState();
}

class _MorningWeightScreenState extends ConsumerState<MorningWeightScreen> {
  late TextEditingController _controller;
  double? _previousWeight;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadCurrentDailyLog();
  }

  Future<void> _loadCurrentDailyLog() async {
    final now = DateTime.now();
    final logListNotifier = ref.read(dailyLogListProvider.notifier);
    final todayLog = await logListNotifier.getByCalendarDay(now);

    if (todayLog != null && todayLog.bodyWeight != null) {
      _controller.text = todayLog.bodyWeight!.toString();

      final yesterdayLog = await logListNotifier.getByCalendarDay(now.subtract(const Duration(days:1)));
      if (yesterdayLog != null){
        _previousWeight = yesterdayLog.bodyWeight ?? 0.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveWeight() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final weight = double.tryParse(text);
    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid weight')),
      );
      return;
    }

    final now = DateTime.now();
    final service = ref.read(dailyLogServiceProvider);

    var todayLog = await service.getOrCreateForDay(now);


    // Save via service (handles weight + recalculation)
    await service.saveBodyWeight(todayLog, weight);

    // Invalidate provider to refresh dashboard
    ref.invalidate(dailyLogListProvider);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Weight saved: ${weight.toStringAsFixed(1)} kg'),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Morning Weight')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Large numeric input
            Text(
              'Enter your weight',
              style: text.headlineMedium?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _controller,
              focusNode: FocusNode()..requestFocus(),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: text.displayLarge?.copyWith(fontSize: 48),
              decoration: const InputDecoration(
                hintText: '0.0',
                hintStyle: TextStyle(color: Colors.white24),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _saveWeight(),
            ),

            const SizedBox(height: 16),

            // Delta display
            if (_previousWeight != null)
              Text(
                'Delta: ${(_getWeight() - _previousWeight!).toStringAsFixed(1)} kg',
                style: text.titleLarge?.copyWith(
                  color: _getWeight() > _previousWeight!
                      ? Colors.redAccent
                      : _getWeight() < _previousWeight!
                      ? Colors.greenAccent
                      : Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

            const Spacer(),

            // Save button (large tap target)
            FilledButton(
              onPressed: _saveWeight,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              child: const Text('Save Weight'),
            ),
          ],
        ),
      ),
    );
  }

  double _getWeight() {
    final text = _controller.text.trim();
    if (text.isEmpty) return 0;
    return double.tryParse(text) ?? 0;
  }
}

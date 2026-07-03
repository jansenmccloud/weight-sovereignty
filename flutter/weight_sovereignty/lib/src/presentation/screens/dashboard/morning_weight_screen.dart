import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/providers.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';

/// Screen for entering morning body weight.
class MorningWeightScreen extends ConsumerStatefulWidget {
  const MorningWeightScreen({super.key});

  @override
  ConsumerState<MorningWeightScreen> createState() => _MorningWeightScreenState();
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
    final logsAsync = ref.read(dailyLogListProvider);
    final logs = logsAsync.value;

    if (logs != null) {
      // Find today's log
      final now = DateTime.now();
      final todayLog = logs.firstWhere(
        (log) => log.date?.year == now.year &&
            log.date?.month == now.month &&
            log.date?.day == now.day,
        orElse: () => DailyLog(),
      );

      if (todayLog.bodyWeight != null) {
        _controller.text = todayLog.bodyWeight!.toString();
        // Find previous weight for delta
        for (int i = 0; i < logs.length; i++) {
          final prev = logs[i];
          if (prev.date != null && prev.bodyWeight != null) {
            final diff = prev.date!.difference(now);
            if (diff.inDays > 0 && diff.inDays <= 365 * 10) {
              _previousWeight = prev.bodyWeight;
              break;
            }
          }
        }
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
    final logsAsync = ref.read(dailyLogListProvider);
    final logs = logsAsync.value;

    DailyLog? todayLog;
    if (logs != null) {
      todayLog = logs.firstWhere(
        (log) => log.date?.year == now.year &&
            log.date?.month == now.month &&
            log.date?.day == now.day,
        orElse: () => DailyLog(),
      );
    }

    if (todayLog.id == null) {
      todayLog = DailyLog()
        ..date = now
        ..dailyLogBase = DailyLogBase();
    }

    final updatedLog = await ref.read(dailyLogRepositoryProvider).save(
      todayLog..bodyWeight = weight,
    );

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
      appBar: AppBar(
        title: const Text('Morning Weight'),
      ),
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
              keyboardType: const TextInputType.numberWithOptions(decimal: '.'),
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
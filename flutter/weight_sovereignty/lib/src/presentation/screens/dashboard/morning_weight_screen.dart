import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/providers.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

/// Screen for entering morning body weight.
class MorningWeightScreen extends ConsumerStatefulWidget {
  const MorningWeightScreen({super.key, this.selectedDate});

  final DateTime? selectedDate;

  @override
  ConsumerState<MorningWeightScreen> createState() => _MorningWeightScreenState();
}

class _MorningWeightScreenState extends ConsumerState<MorningWeightScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadCurrentDailyLog(widget.selectedDate ?? DateTime.now());
  }

  Future<List<DailyLog>> _loadCurrentDailyLog(DateTime d) async {
    final todayLog = await ref.read(dailyLogServiceProvider).getOrCreateForDay(d);
    if (todayLog.bodyWeight != null) {
      _controller.text = todayLog.bodyWeight!.toString();
    } else {
      final yesterdayLog = await ref.read(dailyLogServiceProvider).getForDay(d.subtract(const Duration(days: 1)));
      if (yesterdayLog != null && yesterdayLog.bodyWeight != null) {
        _controller.text = yesterdayLog.bodyWeight!.toString();
      }
    }
    return await ref.refresh(dailyLogListProvider.future);
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid weight')));
      return;
    }

    final targetDate = widget.selectedDate ?? DateTime.now();
    final service = ref.read(dailyLogServiceProvider);

    var targetLog = await service.getOrCreateForDay(targetDate);

    // Save via service (handles weight + recalculation)
    await service.saveBodyWeight(targetLog, weight);

    // Invalidate provider to refresh dashboard
    ref.invalidate(dailyLogListProvider);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Body Weight')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Large numeric input
            Text(
              'Enter your weight',
              style: text.headlineSmall?.copyWith(color: AppTheme.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _controller,
              focusNode: FocusNode()..requestFocus(),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: text.displayMedium?.copyWith(fontSize: 48),
              decoration: const InputDecoration(
                hintText: '0.0',
                hintStyle: TextStyle(color: AppTheme.white),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _saveWeight(),
            ),

            const SizedBox(height: 16),

            // Save button (large tap target)
            FilledButton(
              onPressed: _saveWeight,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
              child: const Text('Save Weight'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/providers.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/presentation/screens/dashboard/morning_weight_screen.dart';
import 'package:weight_sovereignty/src/presentation/widgets/dash_calorie_overview_card.dart';
import 'package:weight_sovereignty/src/presentation/widgets/dash_food_section.dart';
import 'package:weight_sovereignty/src/presentation/widgets/dash_weight_card.dart';
import 'package:weight_sovereignty/src/presentation/widgets/dash_workout_summary.dart';

/// Main dashboard screen showing today's DailyLog summary.
/// Shows weight, calorie overview, food list, and workout summary.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadCurrentDailyLog();
  }

  Future<List<DailyLog>> _loadCurrentDailyLog() async {
    final now = DateTime.now();
    await ref.read(dailyLogServiceProvider).getOrCreateForDay(now);
    return await ref.refresh(dailyLogListProvider.future); // force refresh
  }

  void _navigateToWeightEntry() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => const MorningWeightScreen()),
    );
  }

  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    final todayLogAsync = ref.watch(dailyLogListProvider);
    return todayLogAsync.when(
      data: (logs) => _buildDashboard(logs),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildDashboard(List<DailyLog> logs) {
    // Filter logs for selected date
    final filteredLogs = logs.where((log) {
      if (log.date == null) return false;
      return log.date!.year == _selectedDate.year &&
          log.date!.month == _selectedDate.month &&
          log.date!.day == _selectedDate.day;
    }).toList();

    final todayLog = filteredLogs.isEmpty ? null : filteredLogs.first;

    // Get weight from selected date
    double? dayWeight;
    int? bmr;
    Calculation? calc;

    if (todayLog != null && todayLog.dailyLogBase != null) {
      dayWeight = todayLog.bodyWeight;
      bmr = todayLog.dailyLogBase!.bmrCaloriesKcal;
      calc = todayLog.calculation;
    }

    // Calculate net surplus/deficit
    final intake = calc?.totalIntakeCaloriesKcal ?? 0;
    final burn = calc?.totalBurnedCaloriesKcal ?? 0;
    final netSurplus = (bmr ?? 0) + burn - (intake);

    return CustomScrollView(
      slivers: [
        // Date navigation header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousDay,
                ),
                Expanded(
                  child: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextDay,
                ),
              ],
            ),
          ),
        ),

        // Weight Card
        SliverToBoxAdapter(
          child: WeightCard(
            weight: dayWeight,
            onPressEntry: _navigateToWeightEntry,
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: 8)),

        // Calories Overview Card
        SliverToBoxAdapter(
          child: CalorieOverviewCard(
            bmr: bmr ?? 0,
            intake: intake,
            burn: burn,
            netSurplus: netSurplus,
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: 8)),

        // Food List Section
        SliverToBoxAdapter(child: FoodSection(foodIds: todayLog?.foodIds)),
        SliverToBoxAdapter(child: const SizedBox(height: 8)),

        // Workout Summary Section
        SliverToBoxAdapter(
          child: WorkoutSummary(workoutIds: todayLog?.workoutIds),
        ),
      ],
    );
  }
}

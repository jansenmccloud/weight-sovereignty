import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/providers.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/presentation/screens/dashboard/morning_weight_screen.dart';
import 'package:weight_sovereignty/src/presentation/widgets/dashboard/dash_calorie_overview_card.dart';
import 'package:weight_sovereignty/src/presentation/widgets/dashboard/dash_food_section.dart';
import 'package:weight_sovereignty/src/presentation/widgets/dashboard/dash_macros_overview_card.dart';
import 'package:weight_sovereignty/src/presentation/widgets/dashboard/dash_weight_card.dart';
import 'package:weight_sovereignty/src/presentation/widgets/dashboard/dash_workout_summary.dart';

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
    _loadCurrentDailyLog(_selectedDate);
  }

  /// Loads (or creates) the DailyLog for [_selectedDate] and triggers a dashboard refresh.
  Future<void> _loadCurrentDailyLog(DateTime d) async {
    await ref.read(dailyLogServiceProvider).getOrCreateForDay(d);
    // Refresh only the list provider (filters by selected date); keep the service fresh too.
    await ref.refresh(dailyLogListProvider.future);
  }

  void _navigateToWeightEntry(DateTime selDate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MorningWeightScreen(selectedDate: selDate),
      ),
    );
  }

  void _previousDay() async {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
    await _loadCurrentDailyLog(_selectedDate);
  }

  void _nextDay() async {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
    await _loadCurrentDailyLog(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    // Trigger load when _selectedDate changes (date navigation or navigate-back refresh).
    final todayLogAsync = ref.watch(dailyLogListProvider);
    return todayLogAsync.when(
      data: (logs) => _buildDashboard(logs),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }

  /// Builds the dashboard UI with filtered logs for [_selectedDate].
  Widget _buildDashboard(List<DailyLog> logs) {
    // Filter logs for selected date
    final filteredLogs = logs.where((log) {
      if (log.date == null) return false;
      return log.date!.year == _selectedDate.year &&
          log.date!.month == _selectedDate.month &&
          log.date!.day == _selectedDate.day;
    }).toList();

    // If no logs for the selected date, show an empty dashboard with a button to create one.
    if (filteredLogs.isEmpty) {
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  await _loadCurrentDailyLog(_selectedDate);
                },
                child: const Text('Create entry for this date'),
              ),
            ),
          ),
        ],
      );
    }

    final todayLog = filteredLogs.isEmpty ? null : filteredLogs.first;

    // Get weight from selected date
    double? dayWeight;
    int? bmr;
    int? deficit;
    int? plannedProtein;
    int? plannedFat;
    int? plannedCarbs;
    Calculation? calc;

    if (todayLog != null && todayLog.dailyLogBase != null) {
      dayWeight = todayLog.bodyWeight;
      bmr = todayLog.dailyLogBase!.bmrCaloriesKcal;
      deficit = todayLog.dailyLogBase!.plannedDeficitKcal;
      plannedProtein = todayLog.dailyLogBase!.plannedProteinG;
      plannedFat = todayLog.dailyLogBase!.plannedFatG;
      plannedCarbs = todayLog.dailyLogBase!.plannedCarbsG;
      calc = todayLog.calculation;
    }

    // Calculate net surplus/deficit
    final intake = calc?.totalIntakeCaloriesKcal ?? 0;
    final burn = calc?.totalBurnedCaloriesKcal ?? 0;
    final netSurplus = (bmr ?? 0) - (deficit ?? 0) + burn - (intake);
    final intakeProtein = calc?.totalIntakeProteinG ?? 0;
    final intakeFat = calc?.totalIntakeFatG ?? 0;
    final intakeCarbs = calc?.totalIntakeCarbsG ?? 0;

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

        SliverToBoxAdapter(
          child: PageView(
            scrollDirection: Axis.horizontal,

            children: [
              // Page 0 - Monitor
              Column(
                children: [
                  // Weight Card
                  WeightCard(
                    weight: dayWeight,
                    onPressEntry: () {
                      return _navigateToWeightEntry(_selectedDate);
                    },
                  ),
                  SizedBox(height: 8),

                  // Calories Overview Card
                  CalorieOverviewCard(
                    bmr: bmr ?? 0,
                    intake: intake,
                    burn: burn,
                    deficit: deficit ?? 0,
                    netSurplus: netSurplus,
                  ),
                  SizedBox(height: 8),

                  // Macros Overview Card
                  MacrosOverviewCard(
                    plannedProtein: plannedProtein ?? 0,
                    plannedFat: plannedFat ?? 0,
                    plannedCarbs: plannedCarbs ?? 0,
                    intakeProtein: intakeProtein.round(),
                    intakeFat: intakeFat.round(),
                    intakeCarbs: intakeCarbs.round(),
                  ),
                ],
              ),

              // Page 1 - Food List Section - pass targetDate instead of foodIds
              Column(
                children: [
                  FoodSection(targetDate: _selectedDate),
                ],
              ),

              // Page 2 - Workout Summary Section (placeholder for future implementation)
              Column(
                children: [
                  WorkoutSummary(targetDate: _selectedDate),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

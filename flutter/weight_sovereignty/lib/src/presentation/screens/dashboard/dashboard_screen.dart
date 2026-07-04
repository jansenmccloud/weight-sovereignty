import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/providers.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/domain/entity/food.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/presentation/screens/dashboard/morning_weight_screen.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/food_config_list_screen.dart';

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
          child: _WeightCard(
            weight: dayWeight,
            onPressEntry: _navigateToWeightEntry,
          ),
        ),

        const SizedBox(height: 8),

        // Calories Overview Card
        SliverToBoxAdapter(
          child: _CalorieOverviewCard(
            bmr: bmr ?? 0,
            intake: intake,
            burn: burn,
            netSurplus: netSurplus,
          ),
        ),

        const SizedBox(height: 8),

        // Food List Section
        SliverToBoxAdapter(
          child: _FoodSection(
            foodIds: todayLog?.foodIds,
          ),
        ),

        // Workout Summary Section
        SliverToBoxAdapter(
          child: _WorkoutSummary(
            workoutIds: todayLog?.workoutIds,
          ),
        ),
      ],
    );
  }
}

// ─── Widgets ─────────────────────────────────────────────────────────────────

/// Card displaying daily weight with entry option.
class _WeightCard extends StatelessWidget {
  final double? weight;
  final VoidCallback onPressEntry;

  const _WeightCard({required this.weight, required this.onPressEntry});

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
              Text(
                '${weight!.toStringAsFixed(1)} kg',
                style: text.displaySmall?.copyWith(fontSize: 32),
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

/// Card displaying calorie overview (BMR, intake, burn, net surplus/deficit).
class _CalorieOverviewCard extends StatelessWidget {
  final int bmr;
  final int intake;
  final int burn;
  final int netSurplus;

  const _CalorieOverviewCard({
    required this.bmr,
    required this.intake,
    required this.burn,
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
                Text('Intake', style: text.bodyMedium),
                Text('$intake kcal', style: text.bodyMedium),
              ],
            ),
            const SizedBox(height: 4),

            // Burned
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Burned', style: text.bodyMedium),
                Text('$burn kcal', style: text.bodyMedium),
              ],
            ),
            const Divider(height: 24),

            // Net Surplus/Deficit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Net',
                  style: text.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$netSurplus kcal',
                  style: text.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: netSurplus > 0
                        ? Colors.redAccent
                        : netSurplus < 0
                            ? Colors.blueAccent
                            : Colors.white,
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

/// Section showing logged food items for the selected date.
class _FoodSection extends ConsumerWidget {
  final List<int?>? foodIds;

  const _FoodSection({required this.foodIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final foodIdsList = foodIds?.whereType<int>().toList() ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Food',
                  style: text.titleLarge?.copyWith(color: Colors.white70),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const FoodConfigListScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (foodIdsList.isEmpty)
              Text(
                'No food logged yet',
                style: text.bodyMedium?.copyWith(color: Colors.white38),
              )
            else
              FutureBuilder<List<Food>>(
                future: ref
                    .read(foodListProvider.notifier)
                    .listByIds(foodIdsList),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text(
                      'Error loading food: ${snapshot.error}',
                      style: text.bodyMedium?.copyWith(color: Colors.redAccent),
                    );
                  }
                  final foods = snapshot.data ?? <Food>[];
                  if (foods.isEmpty) {
                    return Text(
                      'No food logged yet',
                      style: text.bodyMedium?.copyWith(color: Colors.white38),
                    );
                  }
                  return Column(
                    children: [
                      for (final food in foods)
                        ListTile(
                          title: Text(food.foodBase?.name ?? 'Unknown'),
                          subtitle: Text(
                            'Kcal: ${food.foodBase?.intakeCaloriesKcal ?? 0}, P: ${food.foodBase?.intakeProteinG ?? 0}g, C: ${food.foodBase?.intakeCarbsG ?? 0}g, F: ${food.foodBase?.intakeFatG ?? 0}g',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),

            // Add food button → FoodConfigListScreen (favorites/pick)
            FilledButton.tonalIcon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const FoodConfigListScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add food'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper to sum burned calories from a list of ExerciseBase.
int _sumWorkoutBurn(List<ExerciseBase?>? exercises) {
  int total = 0;
  if (exercises == null) return total;
  for (final ex in exercises) {
    total += ex?.burnedCaloriesKcal ?? 0;
  }
  return total;
}

/// Section showing logged workouts for the selected date.
class _WorkoutSummary extends ConsumerWidget {
  final List<int?>? workoutIds;

  const _WorkoutSummary({required this.workoutIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final workoutIdsList = workoutIds?.whereType<int>().toList() ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Workout',
                  style: text.titleLarge?.copyWith(color: Colors.white70),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    // TODO: open workout session / add existing workout
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (workoutIdsList.isEmpty)
              Text(
                'No workouts logged yet',
                style: text.bodyMedium?.copyWith(color: Colors.white38),
              )
            else
              FutureBuilder<List<Workout>>(
                future: ref
                    .read(workoutListProvider.notifier)
                    .listByIds(workoutIdsList),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text(
                      'Error loading workouts: ${snapshot.error}',
                      style: text.bodyMedium?.copyWith(color: Colors.redAccent),
                    );
                  }
                  final workouts = snapshot.data ?? <Workout>[];
                  if (workouts.isEmpty) {
                    return Text(
                      'No workouts logged yet',
                      style: text.bodyMedium?.copyWith(color: Colors.white38),
                    );
                  }
                  return Column(
                    children: [
                      for (final workout in workouts)
                        ListTile(
                          title: Text(
                            workout.workoutBase?.name ?? 'Unknown Workout',
                          ),
                          subtitle: Text(
                            'Burn: ${_sumWorkoutBurn(workout.exercises)} kcal',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),

            FilledButton.tonalIcon(
              onPressed: () async {
                // TODO: open workout session
              },
              icon: const Icon(Icons.add),
              label: const Text('Start workout'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/domain/config/food_config.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/domain/entity/food.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart'
    show foodConfigRepositoryProvider, foodRepositoryProvider;
import 'package:weight_sovereignty/src/application/dailylog/daily_log_service.dart' show dailyLogServiceProvider;
import 'package:weight_sovereignty/src/presentation/widgets/food_item_selector_widget.dart';

/// Screen to add eaten food to the current day's DailyLog.
/// Shows a searchable list of FoodConfig presets. User adjusts amount before adding.
class AddFoodScreen extends ConsumerStatefulWidget {
  final DateTime targetDate;

  const AddFoodScreen({super.key, required this.targetDate});

  static Route<DailyLog?> route({required DateTime targetDate}) {
    return MaterialPageRoute(
      builder: (_) => AddFoodScreen(targetDate: targetDate),
      settings: const RouteSettings(name: 'add_food'),
    );
  }

  @override
  ConsumerState<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends ConsumerState<AddFoodScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  /// All configured foods
  List<FoodConfig> _foods = [];
  DailyLog? _dailyLog;
  bool _isLoading = true;

  /// Map of FoodConfig.id -> user-entered amount in grams (0 means not selected, >0 means selected).
  final Map<int, double> _amountOverrides = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    try {
      final foodsRepo = ref.read(foodConfigRepositoryProvider);
      final allFoods = await foodsRepo.getAll();
      
      final dailyLogService = ref.read(dailyLogServiceProvider);
      // getOrCreate handles the "no log today" case silently per requirements
      final dailyLog = await dailyLogService.getOrCreateForDay(widget.targetDate);
      
      if (!mounted) return;

      // Initialize amount overrides to FoodConfig.amount (default serving size) for new foods
      final newFoods = allFoods.where((f) => !_amountOverrides.containsKey(f.id)).toList();
      for (final food in newFoods) {
        _amountOverrides[food.id] = (food.amount?.toDouble() ?? 100.0);
      }
      
      setState(() {
        _foods = allFoods;
        _dailyLog = dailyLog;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }

  /// Filtered food list based on search query.
  List<FoodConfig> get _filteredFoods {
    if (_searchQuery.isEmpty) return _foods;
    final query = _searchQuery.toLowerCase();
    return _foods.where((food) {
      final name = food.name?.toLowerCase() ?? '';
      return name.contains(query);
    }).toList();
  }

  /// List of foods that are selected (amount > 0).
  List<(FoodConfig, double)> get _selectedFoods {
    final result = <(FoodConfig, double)>[];
    for (final food in _foods) {
      final amount = _amountOverrides[food.id] ?? 0.0;
      if (amount > 0) {
        result.add((food, amount));
      }
    }
    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _dailyLog == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food'),
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search foods...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          // Food list or empty state
          if (_filteredFoods.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  _searchQuery.isEmpty
                      ? 'No foods configured yet.'
                      : 'No foods found.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: _filteredFoods.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha((255 * 0.1).round()),
                ),
                itemBuilder: (context, index) {
                  final food = _filteredFoods[index];
                  final amount = _amountOverrides[food.id] ?? (food.amount?.toDouble() ?? 100.0);
                   return FoodItemSelectorWidget(
                     foodConfig: food,
                     amount: amount,
                     onAmountChanged: (value) {
                       setState(() {
                         _amountOverrides[food.id] = value;
                       });
                     },
                     onDelete: () {
                       setState(() {
                         _amountOverrides[food.id] = 0.0;
                       });
                     },
                   );
                },
              ),
            ),
        ],
      ),
      // Summary bar showing selected foods and totals
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final selected = _selectedFoods;
    if (selected.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Text(
          'Select food to add',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    // Calculate totals from selected foods using config.amount as base unit
    double totalCal = 0, totalProtein = 0, totalFat = 0, totalCarbs = 0;
    for (final (food, userAmount) in selected) {
      final ratio = userAmount / (food.amount?.toDouble() ?? 1.0);
      final cal = ((food.intakeCaloriesKcal ?? 0).toDouble() * ratio).round();
      final protein = (food.intakeProteinG ?? 0) * ratio;
      final fat = (food.intakeFatG ?? 0) * ratio;
      final carbs = (food.intakeCarbsG ?? 0) * ratio;
      totalCal += cal;
      totalProtein += protein;
      totalFat += fat;
      totalCarbs += carbs;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${selected.length} item${selected.length > 1 ? 's' : ''} selected',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          Text(
            '+${totalCal.round()} kcal · P:${totalProtein.round()}g F:${totalFat.round()}g C:${totalCarbs.round()}g',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Handle save: create Food entries for selected foods and link to DailyLog.
  /// Idempotent: recalculates totals from all foodIds on DailyLog after save.
  Future<void> _handleSave() async {
    if (_dailyLog == null) return;

    final dailyLog = _dailyLog!;
    final newEntries = <Food>[];
    
    for (final food in _foods) {
      final userAmount = _amountOverrides[food.id] ?? 0.0;
      if (userAmount <= 0) continue;

      // Skip if already in log to avoid duplicates on re-save
      if ((dailyLog.foodIds ?? []).contains(food.id)) continue;

      // Create Food entity with scaled macros and target date
      final foodEntity = _createFoodWithAmount(food, userAmount, widget.targetDate);
      newEntries.add(foodEntity);
    }

    if (newEntries.isEmpty) {
      Navigator.pop<DailyLog?>(context, dailyLog);
      return;
    }

    try {
      // Save new Food entries to Isar
      final foodRepo = ref.read(foodRepositoryProvider);
      final newIds = <int?>[];
      for (final foodEntity in newEntries) {
        final savedId = await foodRepo.save(foodEntity);
        newIds.add(savedId);
      }

      // Update DailyLog: merge existing IDs with new ones, then recalculate
      final mergedIds = [...?dailyLog.foodIds, ...newIds];
      final updatedLog = DailyLog()
        ..date = dailyLog.date
        ..foodIds = mergedIds
        ..workoutIds = dailyLog.workoutIds;

      // Trigger idempotent recalculation
      final recalculatedLog = await ref.read(dailyLogServiceProvider).recalculateAndSave(updatedLog);
      
      if (mounted) {
        Navigator.pop<DailyLog?>(context, recalculatedLog);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save food: $e')),
      );
    }
  }

  /// Create a Food entity from a FoodConfig preset with scaled macros and target date.
  /// The multiplier is computed as userAmount / config.amount (e.g., 200g / 100g = 2.0).
  Food _createFoodWithAmount(FoodConfig config, double userAmount, DateTime targetDate) {
    final ratio = userAmount / (config.amount?.toDouble() ?? 1.0);
    return Food()
      ..date = targetDate
      ..setBase = config
      ..foodBase!.intakeCaloriesKcal = ((config.intakeCaloriesKcal ?? 0).toDouble() * ratio).round()
      ..foodBase!.intakeProteinG = ((config.intakeProteinG ?? 0).toDouble() * ratio).round()
      ..foodBase!.intakeFatG = ((config.intakeFatG ?? 0).toDouble() * ratio).round()
      ..foodBase!.intakeCarbsG = ((config.intakeCarbsG ?? 0).toDouble() * ratio).round();
  }
}
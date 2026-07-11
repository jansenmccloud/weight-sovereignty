import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/domain/config/food_config.dart';
import 'package:weight_sovereignty/src/domain/entity/food.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart'
    show foodConfigRepositoryProvider, foodRepositoryProvider;
import 'package:weight_sovereignty/src/domain/util/date_only.dart';
import 'package:weight_sovereignty/src/presentation/widgets/food/food_item_selector_widget.dart';



/// Screen to add eaten food to the current day's DailyLog.
/// Shows a searchable list of FoodConfig presets. User adjusts amount before adding.
class AddFoodScreen extends ConsumerStatefulWidget {
  final DateTime targetDate;

  const AddFoodScreen({super.key, required this.targetDate});

  static Route<void> route({required DateTime targetDate}) {
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
  bool _isLoading = true;

  /// Map of FoodConfig.id -> user-entered amount in grams (0 means not selected, >0 means selected).
  final Map<int, int> _amountOverrides = {};
  final Map<int, int> _selectedFoodIds = {};

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
      
      if (!mounted) return;

      // Initialize amount overrides to FoodConfig.amount (default serving size) for new foods
      final newFoods = allFoods.where((f) => !_amountOverrides.containsKey(f.id)).toList();
      for (final food in newFoods) {
        _amountOverrides[food.id] = (food.amountG ?? 100);
      }
      
      setState(() {
        _foods = allFoods;
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food'),
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.deepPurple),
              ),
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
                  height: 0,
                  thickness: 0,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha((255 * 0.1).round()),
                ),
                itemBuilder: (context, index) {
                  final food = _filteredFoods[index];
                  final amount = _amountOverrides[food.id] ?? (food.amountG ?? 100);
                   return FoodItemSelectorWidget(
                     foodConfig: food,
                     amount: amount,
                     onAmountChanged: (value) {
                       setState(() {
                         _amountOverrides[food.id] = value;
                       });
                     },
                     onSelect: () {
                       setState(() {
                         _selectedFoodIds[food.id] = 1;
                       });
                     },
                     onDeselect: () {
                       setState(() {
                         _selectedFoodIds[food.id] = 0;
                       });
                     },
                   );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Handle save: create Food entries for selected foods. 
  /// Completely decoupled from DailyLog — no writes to DailyLog, returns count of added foods.
  Future<void> _handleSave() async {
    final newEntries = <Food>[];
    
    for (final food in _foods) {
      if (!_selectedFoodIds.containsKey(food.id) || _selectedFoodIds[food.id] == 0) continue;
      final userAmount = _amountOverrides[food.id] ?? 0;
      if (userAmount <= 0) continue;

      // Create Food entity with scaled macros and target date
      final foodEntity = _createFoodWithAmount(food, userAmount, widget.targetDate);
      newEntries.add(foodEntity);
    }

    if (newEntries.isEmpty) {
      Navigator.pop(context);
      return;
    }

    try {
      // Save new Food entries to Isar (no DailyLog linking needed anymore)
      final foodRepo = ref.read(foodRepositoryProvider);
      for (final foodEntity in newEntries) {
        await foodRepo.save(foodEntity);
      }
      
      if (mounted) {
        Navigator.pop(context);
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
  Food _createFoodWithAmount(FoodConfig config, int userAmount, DateTime targetDate) {
    final ratio = userAmount / (config.amountG?.toDouble() ?? 100.0);
    return Food()
      ..date = toCalendarDay(targetDate)
      ..setBase = config
      ..foodBase!.intakeCaloriesKcal = ((config.intakeCaloriesKcal ?? 0).toDouble() * ratio).round()
      ..foodBase!.intakeProteinG = ((config.intakeProteinG ?? 0).toDouble() * ratio).round()
      ..foodBase!.intakeFatG = ((config.intakeFatG ?? 0).toDouble() * ratio).round()
      ..foodBase!.intakeCarbsG = ((config.intakeCarbsG ?? 0).toDouble() * ratio).round()
      ..foodBase!.amountG = userAmount;
  }

}

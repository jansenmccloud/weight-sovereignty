import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/providers.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';
import 'package:weight_sovereignty/src/domain/config/workout_config.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart'
    show exerciseConfigRepositoryProvider, workoutRepositoryProvider;
import 'package:weight_sovereignty/src/domain/util/date_only.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';
import 'package:weight_sovereignty/src/presentation/widgets/workout/workout_item_selector_widget.dart';

/// Screen to add exercises from ExerciseConfig presets.
/// Shows a searchable list of ExerciseConfig presets. User selects multiple before saving.
class AddWorkoutScreen extends ConsumerStatefulWidget {
  final DateTime targetDate;

  const AddWorkoutScreen({super.key, required this.targetDate});

  static Route<void> route({required DateTime targetDate}) {
    return MaterialPageRoute(
      builder: (_) => AddWorkoutScreen(targetDate: targetDate),
      settings: const RouteSettings(name: 'add_workout'),
    );
  }

  @override
  ConsumerState<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends ConsumerState<AddWorkoutScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<WorkoutConfig> _workouts = [];
  bool _isLoading = true;
  final Map<int, int> _selectedWorkoutIds = {};

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
      final workoutsRepo = ref.read(workoutConfigRepositoryProvider);
      final allWorkouts = await workoutsRepo.getAll();

      if (!mounted) return;

      setState(() {
        _workouts = allWorkouts;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
    }
  }

  /// Filtered workout list based on search query.
  List<WorkoutConfig> get _filteredWorkouts {
    if (_searchQuery.isEmpty) return _workouts;
    final query = _searchQuery.toLowerCase();
    return _workouts.where((w) {
      final name = w.name?.toLowerCase() ?? '';
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
        title: const Text('Add Workout'),
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: const Text(
              'Save',
              style: TextStyle(color: AppTheme.purple),
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
              style: TextStyle(color: AppTheme.grey),
              decoration: InputDecoration(
                hintText: 'Search workouts...',
                hintStyle: TextStyle(color: AppTheme.grey),
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: AppTheme.grey,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.grey),
                ),
                filled: true,
                fillColor: AppTheme.surface,
                iconColor: AppTheme.grey,
              ),
            ),
          ),
          // workout list or empty state
          if (_filteredWorkouts.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  _searchQuery.isEmpty
                      ? 'No workouts configured yet.'
                      : 'No workout found.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _filteredWorkouts.length,
                itemBuilder: (context, index) {
                  final workout = _filteredWorkouts[index];
                  return WorkoutItemSelectorWidget(
                    workoutConfig: workout,
                    onSelect: () {
                      setState(() {
                        _selectedWorkoutIds[workout.id] = 1;
                      });
                    },
                    onDeselect: () {
                      setState(() {
                        _selectedWorkoutIds[workout.id] = 0;
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

  Future<void> _handleSave() async {
    final newEntries = <Workout>[];

    for (final workout in _workouts) {
      if (!_selectedWorkoutIds.containsKey(workout.id) || _selectedWorkoutIds[workout.id] == 0) continue;
      final foodEntity = _createWorkout(workout, widget.targetDate);
      newEntries.add(foodEntity);
    }

    if (newEntries.isEmpty) {
      Navigator.pop(context);
      return;
    }

    try {
      final workoutRepo = ref.read(workoutRepositoryProvider);
      for (final workoutEntity in newEntries) {
        await workoutRepo.save(workoutEntity);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save workout: $e')),
      );
    }
  }

  Workout _createWorkout(WorkoutConfig config, DateTime targetDate) {
    return Workout()
      ..date = toCalendarDay(targetDate)
      ..setBase = config;
  }
}

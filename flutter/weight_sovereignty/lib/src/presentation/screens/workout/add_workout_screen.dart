import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart'
    show exerciseConfigRepositoryProvider, workoutRepositoryProvider;
import 'package:weight_sovereignty/src/domain/util/date_only.dart';
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

  // TODO exerciseConfig list is not the list we want to work with here ... lol
  /// All configured exercises
  List<ExerciseConfig> _exercises = [];
  bool _isLoading = true;

  /// Selected ExerciseConfig ids.
  final Set<int> _selectedIds = {};

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
      // TODO workout repo needed 
      final exercisesRepo = ref.read(exerciseConfigRepositoryProvider);
      final allExercises = await exercisesRepo.getAll();
      
      if (!mounted) return;

      setState(() {
        _exercises = allExercises;
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

  /// Filtered exercise list based on search query.
  List<ExerciseConfig> get _filteredExercises {
    if (_searchQuery.isEmpty) return _exercises;
    final query = _searchQuery.toLowerCase();
    return _exercises.where((exercise) {
      final name = exercise.name?.toLowerCase() ?? '';
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
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          // Exercise list or empty state
          if (_filteredExercises.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  _searchQuery.isEmpty
                      ? 'No exercises configured yet.'
                      : 'No exercises found.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: _filteredExercises.length,
                separatorBuilder: (context, index) => Divider(
                  height: 0,
                  thickness: 0,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha((255 * 0.1).round()),
                ),
                itemBuilder: (context, index) {
                  final exercise = _filteredExercises[index];
                  return WorkoutItemSelectorWidget(
                    exerciseConfig: exercise,
                    selectedCount: _selectedIds.contains(exercise.id) ? 1 : 0,
                    onTap: () {
                      setState(() {
                        if (_selectedIds.contains(exercise.id)) {
                          _selectedIds.remove(exercise.id);
                        } else {
                          _selectedIds.add(exercise.id);
                        }
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

  /// Handle save: create a Workout entity from selected ExerciseConfig presets.
  Future<void> _handleSave() async {
    if (_selectedIds.isEmpty) {
      Navigator.pop(context);
      return;
    }

    try {
      final workoutRepo = ref.read(workoutRepositoryProvider);

      // Collect selected exercise configs in order
      final selectedConfigs = <ExerciseConfig>[];
      for (final ex in _exercises) {
        if (_selectedIds.contains(ex.id)) {
          selectedConfigs.add(ex);
        }
      }

      // Create a single Workout with all selected exercises
      final workout = Workout()
        ..date = toCalendarDay(widget.targetDate)
        ..setExercises = selectedConfigs;

      await workoutRepo.save(workout);
      
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
}
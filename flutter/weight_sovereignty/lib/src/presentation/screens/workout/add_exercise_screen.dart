import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/providers.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

class AddExerciseScreen extends ConsumerStatefulWidget {
  final Workout workout;

  const AddExerciseScreen({super.key, required this.workout});

  @override
  ConsumerState<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

enum ExerciseSortOrder { nameAsc, nameDesc }

class _AddExerciseScreenState extends ConsumerState<AddExerciseScreen> {
  final Set<String> _selectedExerciseNames = {};
  bool _loading = true;
  bool _saving = false;
  ExerciseSortOrder _sortOrder = ExerciseSortOrder.nameAsc;
  ExerciseCategory? _categoryFilter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final exNames = <String>[];
    widget.workout.exercises!.forEach(((element) => exNames.add(element!.name ?? '')));
    if (mounted) {
      _selectedExerciseNames.addAll(exNames);
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    try {
      final allExercises = await ref.read(exerciseConfigRepositoryProvider).getAll();
      var allExMap = {for (var v in allExercises) v.name: v};

      final alreadyAdded = <String>[];
      widget.workout.exercises!.forEach(((element) => alreadyAdded.add(element!.name ?? '')));

      final newExercises = List<ExerciseBase>.from(widget.workout.exercises!);
      for (var e in _selectedExerciseNames) {
        if (alreadyAdded.contains(e)) continue;
        newExercises.add(ExerciseBase.fromConfig(allExMap[e]!));
      }

      widget.workout.exercises = newExercises;
      final workoutRepo = ref.read(workoutRepositoryProvider);
      await workoutRepo.save(widget.workout);
      setState(() {});

      if (mounted) Navigator.of(context).pop(widget.workout);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final exercisesAsync = ref.watch(exerciseConfigListProvider);

    return exercisesAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (exercises) => _buildScreenWithExercises(context, exercises),
    );
  }

  Widget _buildScreenWithExercises(BuildContext context, List<ExerciseConfig> exercises) {
    final displayExercises = exercises
        .where((e) => _categoryFilter == null || e.categoryName == _categoryFilter!.name)
        .toList()
      ..sort((a, b) {
        final cmp = (a.name ?? '').compareTo(b.name ?? '');
        return _sortOrder == ExerciseSortOrder.nameAsc ? cmp : -cmp;
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add exercise'),
        actions: [
          PopupMenuButton<ExerciseSortOrder>(
            icon: const Icon(Icons.sort),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: ExerciseSortOrder.nameAsc,
                child: Row(
                  children: [
                    Icon(Icons.check, size: 18, color: _sortOrder == ExerciseSortOrder.nameAsc ? Theme.of(context).colorScheme.primary : Colors.transparent),
                    const SizedBox(width: 8),
                    const Text('Name A→Z'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ExerciseSortOrder.nameDesc,
                child: Row(
                  children: [
                    Icon(Icons.check, size: 18, color: _sortOrder == ExerciseSortOrder.nameDesc ? Theme.of(context).colorScheme.primary : Colors.transparent),
                    const SizedBox(width: 8),
                    const Text('Name Z→A'),
                  ],
                ),
              ),
            ],
            onSelected: (v) => setState(() => _sortOrder = v),
          ),
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppTheme.purple)))
                : const Text('Save', style: TextStyle(color: AppTheme.purple)),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilterHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Exercises', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.white)),
                ...displayExercises.map(_exerciseCheckbox),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilterHeader() {
    final chips = <Widget>[];
    var spacer = const SizedBox(width: 8);
    for (final category in ExerciseCategory.values) {
      if (category == ExerciseCategory.none) continue;
      chips.addAll([
        FilterChip(
          label: Text(_categoryDisplayName(category)),
          selected: _categoryFilter == category,
          showCheckmark: false,
          selectedColor: AppTheme.purple,
          onSelected: (selected) => setState(() => _categoryFilter = selected ? category : null),
        ),
        spacer,
      ]);
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(children: chips),
    );
  }

  String _categoryDisplayName(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.back:
        return 'Back';
      case ExerciseCategory.arms:
        return 'Arms';
      case ExerciseCategory.chest:
        return 'Chest';
      case ExerciseCategory.legs:
        return 'Legs';
      case ExerciseCategory.shoulders:
        return 'Shoulders';
      case ExerciseCategory.none:
        return '';
    }
  }

  Widget _exerciseCheckbox(ExerciseConfig exercise) {
    final name = exercise.name;
    if (name == null || name.isEmpty) return const SizedBox.shrink();

    return CheckboxListTile(
      title: Text(name, style: TextStyle(color: AppTheme.white)),
      subtitle: Text('${exercise.type.name} · ${exercise.category.name}', style: TextStyle(color: AppTheme.grey)),
      value: _selectedExerciseNames.contains(name),
      onChanged: (checked) {
        setState(() {
          if (checked == true) {
            _selectedExerciseNames.add(name);
          } else {
            _selectedExerciseNames.remove(name);
          }
        });
      },
    );
  }
}

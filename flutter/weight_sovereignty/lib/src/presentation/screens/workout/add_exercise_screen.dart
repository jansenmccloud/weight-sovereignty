import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/providers/providers.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';
import 'package:weight_sovereignty/src/presentation/widgets/settings/config_form_scaffold.dart';

class AddExerciseScreen extends ConsumerStatefulWidget {
  final Workout workout;

  const AddExerciseScreen({super.key, required this.workout});

  @override
  ConsumerState<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends ConsumerState<AddExerciseScreen> {
  final Set<String> _selectedExerciseNames = {};
  bool _loading = true;
  bool _saving = false;

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
      if (mounted) showConfigError(context, e);
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

    return ConfigFormScaffold(
      title: 'Add exercise',
      isSaving: _saving,
      onSave: _save,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Exercises', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.white)),
          exercisesAsync.when(
            loading: () => const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()),
            error: (e, _) => Text('Error loading exercises: $e'),
            data: (exercises) {
              return Column(children: exercises.map(_exerciseCheckbox).toList());
            },
          ),
        ],
      ),
    );
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

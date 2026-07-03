import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/config/config_validation.dart';
import 'package:weight_sovereignty/src/application/exercise_config/exercise_config_list_notifier.dart';
import 'package:weight_sovereignty/src/application/workout_config/workout_config_list_notifier.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';
import 'package:weight_sovereignty/src/domain/config/workout_config.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/exercise_config_list_screen.dart';
import 'package:weight_sovereignty/src/presentation/widgets/config_form_scaffold.dart';

class WorkoutConfigEditScreen extends ConsumerStatefulWidget {
  const WorkoutConfigEditScreen({super.key, this.configId});

  final int? configId;

  @override
  ConsumerState<WorkoutConfigEditScreen> createState() =>
      _WorkoutConfigEditScreenState();
}

class _WorkoutConfigEditScreenState
    extends ConsumerState<WorkoutConfigEditScreen> {
  final _nameController = TextEditingController();
  final Set<String> _selectedExerciseNames = {};
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.configId != null) {
      final existing = await ref
          .read(workoutConfigListProvider.notifier)
          .read(widget.configId!);
      if (existing != null && mounted) {
        _nameController.text = existing.name ?? '';
        _selectedExerciseNames.addAll(
          existing.exercisePresetIds?.whereType<String>() ?? [],
        );
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nameError = validateConfigName(_nameController.text);
    if (nameError != null) {
      showConfigError(context, nameError);
      return;
    }

    final exercises = ref.read(exerciseConfigListProvider).valueOrNull ?? [];
    if (exercises.isEmpty) {
      showConfigError(context, 'Create at least one exercise preset first.');
      return;
    }

    setState(() => _saving = true);
    try {
      final config = WorkoutConfig()
        ..name = _nameController.text.trim()
        ..exercisePresetIds = _selectedExerciseNames.toList();
      if (widget.configId != null) config.id = widget.configId!;

      final notifier = ref.read(workoutConfigListProvider.notifier);
      if (widget.configId == null) {
        await notifier.create(config);
      } else {
        await notifier.updateItem(config);
      }
      if (mounted) Navigator.pop(context);
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
      title: widget.configId == null ? 'New template' : 'Edit template',
      isSaving: _saving,
      onSave: _save,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 12),
          Text('Exercises', style: Theme.of(context).textTheme.titleMedium),
          exercisesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            ),
            error: (e, _) => Text('Error loading exercises: $e'),
            data: (exercises) {
              if (exercises.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('No exercise presets yet.'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const ExerciseConfigListScreen(),
                          ),
                        );
                      },
                      child: const Text('Add exercise presets'),
                    ),
                  ],
                );
              }
              return Column(
                children: exercises.map(_exerciseCheckbox).toList(),
              );
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
      title: Text(name),
      subtitle: Text('${exercise.type.name} · ${exercise.category.name}'),
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

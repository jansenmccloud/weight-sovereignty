import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/config/config_validation.dart';
import 'package:weight_sovereignty/src/application/config/exercise_config_save.dart';
import 'package:weight_sovereignty/src/application/exercise_config/exercise_config_list_notifier.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';
import 'package:weight_sovereignty/src/presentation/widgets/config_form_scaffold.dart';

class ExerciseConfigEditScreen extends ConsumerStatefulWidget {
  const ExerciseConfigEditScreen({super.key, this.configId});

  final int? configId;

  @override
  ConsumerState<ExerciseConfigEditScreen> createState() =>
      _ExerciseConfigEditScreenState();
}

class _ExerciseConfigEditScreenState extends ConsumerState<ExerciseConfigEditScreen> {
  final digitsOnly = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  final _setsController = TextEditingController();
  final _distanceController = TextEditingController();
  final _durationController = TextEditingController();
  final _burnController = TextEditingController();

  ExerciseCategory _category = ExerciseCategory.none;
  ExerciseType _type = ExerciseType.cardio;
  IntensityLevel _intensity = IntensityLevel.moderate;
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
          .read(exerciseConfigListProvider.notifier)
          .read(widget.configId!);
      if (existing != null && mounted) _apply(existing);
    }
    if (mounted) setState(() => _loading = false);
  }

  void _apply(ExerciseConfig c) {
    _nameController.text = c.name ?? '';
    _category = c.category;
    _type = c.type;
    _intensity = c.intensityLevel;
    _weightController.text = c.weightKg?.toString() ?? '';
    _repsController.text = c.reps?.toString() ?? '';
    _setsController.text = c.sets?.toString() ?? '';
    _distanceController.text = c.distanceKm?.toString() ?? '';
    _durationController.text = c.durationMin?.toString() ?? '';
    _burnController.text = c.burnedCaloriesKcal?.toString() ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _repsController.dispose();
    _setsController.dispose();
    _distanceController.dispose();
    _durationController.dispose();
    _burnController.dispose();
    super.dispose();
  }

  ExerciseConfig _buildConfig() {
    final config = ExerciseConfig()
      ..name = _nameController.text.trim()
      ..weightKg = parseOptionalInt(_weightController.text)
      ..reps = parseOptionalInt(_repsController.text)
      ..sets = parseOptionalInt(_setsController.text)
      ..distanceKm = parseOptionalDouble(_distanceController.text)
      ..durationMin = parseOptionalInt(_durationController.text)
      ..burnedCaloriesKcal = parseOptionalInt(_burnController.text);
    if (widget.configId != null) config.id = widget.configId!;

    config.categoryName = _category.name;
    config.typeName = _type.name;
    config.intensityLevelName = _intensity.name;
    applyExerciseEnumsForSave(config);
    return config;
  }

  Future<void> _save() async {
    final nameError = validateConfigName(_nameController.text);
    if (nameError != null) {
      showConfigError(context, nameError);
      return;
    }

    setState(() => _saving = true);
    try {
      final config = _buildConfig();
      final notifier = ref.read(exerciseConfigListProvider.notifier);
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

    return ConfigFormScaffold(
      title: widget.configId == null ? 'New exercise' : 'Edit exercise',
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
          _enumDropdown(
            label: 'Type',
            value: _type,
            items: ExerciseType.values,
            labelOf: (v) => v.name,
            onChanged: (v) => setState(() => _type = v!),
          ),
          _enumDropdown(
            label: 'Category',
            value: _category,
            items: ExerciseCategory.values,
            labelOf: (v) => v.name,
            onChanged: (v) => setState(() => _category = v!),
          ),
          _enumDropdown(
            label: 'Intensity',
            value: _intensity,
            items: IntensityLevel.values,
            labelOf: (v) => v.name,
            onChanged: (v) => setState(() => _intensity = v!),
          ),
          TextField(
            controller: _weightController,
            decoration: const InputDecoration(labelText: 'Weight (kg)'),
            keyboardType: TextInputType.number,
            inputFormatters: [digitsOnly],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _repsController,
            decoration: const InputDecoration(labelText: 'Reps'),
            keyboardType: TextInputType.number,
            inputFormatters: [digitsOnly],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _setsController,
            decoration: const InputDecoration(labelText: 'Sets'),
            keyboardType: TextInputType.number,
            inputFormatters: [digitsOnly],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _distanceController,
            decoration: const InputDecoration(labelText: 'Distance (km)'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _durationController,
            decoration: const InputDecoration(labelText: 'Duration (min)'),
            keyboardType: TextInputType.number,
            inputFormatters: [digitsOnly],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _burnController,
            decoration: const InputDecoration(labelText: 'Burn (kcal)'),
            keyboardType: TextInputType.number,
            inputFormatters: [digitsOnly],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _enumDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) labelOf,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(labelOf(e))))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

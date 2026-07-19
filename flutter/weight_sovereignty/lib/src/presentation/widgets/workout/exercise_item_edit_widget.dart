import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weight_sovereignty/src/application/config/config_validation.dart';
import 'package:weight_sovereignty/src/domain/config/exercise_config.dart';
import 'package:weight_sovereignty/src/domain/entity/workout.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

/// Widget for editing a workout exercise
class ExerciseItemEditWidget extends StatefulWidget {
  final Workout workout;
  final int exerciseIndex;
  final double bodyWeight;

  const ExerciseItemEditWidget({super.key, required this.workout, required this.exerciseIndex, required this.bodyWeight});

  @override
  State<ExerciseItemEditWidget> createState() => _ExerciseItemEditWidgetState();
}

class _ExerciseItemEditWidgetState extends State<ExerciseItemEditWidget> {
  final digitsOnly = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  final _weightController = initTenTextEditControllers();
  final _repsController = initTenTextEditControllers();
  final _distanceController = TextEditingController();
  final _durationController = TextEditingController();
  bool _loading = true;
  bool isChecked = false;

  static List<TextEditingController> initTenTextEditControllers() {
    final l = <TextEditingController>[];
    for (var i = 0; i < 10; i++) {
      l.add(TextEditingController());
    }
    return l;
  }

  @override
  void dispose() {
    _weightController.forEach((e) => e.dispose());
    _repsController.forEach((e) => e.dispose());
    _distanceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final Workout workout = widget.workout;
    final int index = widget.exerciseIndex;
    final ExerciseBase exercise = workout.exercises![index]!;

    if (mounted) {
      if (exercise.sets != null) {
        for (var i = 0; i < exercise.sets!.length; i++) {
          _weightController[i].text = exercise.sets![i]!.weightKg?.toString() ?? '';
          _repsController[i].text = exercise.sets![i]!.reps?.toString() ?? '';
        }
      }
      _distanceController.text = exercise.distanceKm?.toString() ?? '';
      _durationController.text = exercise.durationMin?.toString() ?? '';
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final Workout workout = widget.workout;
    final int index = widget.exerciseIndex;
    final ExerciseBase exercise = workout.exercises![index]!;
    final bodyWeight = widget.bodyWeight;

    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.surfaceContainerHighest.withAlpha((255 * 0.3).round());

    return Container(
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Material(
        color: AppTheme.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: _createItemWidgets(bodyWeight, workout, index, exercise, context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _createItemWidgets(double bodyWeight, Workout workout, int index, ExerciseBase exercise, BuildContext context) {
    final theme = Theme.of(context);

    final widgets = <Widget>[];
    widgets.addAll({
      Text(exercise.name ?? 'Unnamed Exercise', style: theme.textTheme.titleMedium?.copyWith(color: AppTheme.white)),
      const SizedBox(height: 2),
      Text('${exercise.typeName}: ${exercise.intensityLevelName} ${exercise.categoryName}: ${exercise.burnedCaloriesKcal ?? 0} kcal', style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.grey)),
      const SizedBox(height: 4),
    });

    if (ExerciseType.getTypeFromString(exercise.typeName) == ExerciseType.lifting) {
      widgets.addAll(_createLiftingItemWidgets(bodyWeight, workout, index, exercise));
    } else {
      widgets.addAll(_createCardioItemWidgets(bodyWeight, workout, index, exercise));
    }
    return widgets;
  }

  List<Widget> _createLiftingItemWidgets(double bodyWeight, Workout workout, int index, ExerciseBase exercise) {
    if (exercise.sets == null) {
      return [];
    }

    Color getColor(Set<WidgetState> states) {
      return AppTheme.purple;
    }

    final setWidgets = <Widget>[];
    for (var i = 0; i < exercise.sets!.length; i++) {
      bool finished = exercise.sets![i]!.finished;
      setWidgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                onSubmitted: (value) {
                  exercise.sets![i]!.weightKg = parseOptionalInt(value);
                  _recalculateLiftingAndSave(bodyWeight, workout, index, exercise);
                },
                controller: _weightController[i],
                style: TextStyle(color: AppTheme.white),
                decoration: const InputDecoration(labelText: 'kg'),
                keyboardType: TextInputType.number,
                inputFormatters: [digitsOnly],
              ),
            ),
            Expanded(
              child: TextField(
                onSubmitted: (value) {
                  exercise.sets![i]!.reps = parseOptionalInt(value);
                  _recalculateLiftingAndSave(bodyWeight, workout, index, exercise);
                },
                controller: _repsController[i],
                style: TextStyle(color: AppTheme.white),
                decoration: const InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                inputFormatters: [digitsOnly],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Checkbox(
                side: BorderSide(color: AppTheme.grey),
                checkColor: AppTheme.yellow,
                fillColor: WidgetStateProperty.resolveWith(getColor),
                focusColor: AppTheme.yellow,
                value: finished,
                onChanged: (bool? value) {
                  setState(() {
                    finished = value!;
                  });
                  if (value!) {
                    exercise.sets![i]!.finished = true;
                  } else {
                    exercise.sets![i]!.finished = false;
                  }
                  _recalculateLiftingAndSave(bodyWeight, workout, index, exercise);
                },
              ),
            ),
          ],
        ),
      );
    }

    final widgets = <Widget>[];
    widgets.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: setWidgets,
    ));

    // TODO add set button
    return widgets;
  }

  List<Widget> _createCardioItemWidgets(double bodyWeight, Workout workout, int index, ExerciseBase exercise) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              maxLength: 80,
              onSubmitted: (value) {
                exercise.distanceKm = parseOptionalDouble(value);
                _recalculateAndSave(bodyWeight, workout, index, exercise);
              },
              controller: _distanceController,
              style: TextStyle(color: AppTheme.white),
              decoration: const InputDecoration(labelText: 'km'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          Expanded(
            child: TextField(
              maxLength: 80,
              onSubmitted: (value) {
                exercise.durationMin = parseOptionalInt(value);
                _recalculateAndSave(bodyWeight, workout, index, exercise);
              },
              controller: _durationController,
              style: TextStyle(color: AppTheme.white),
              decoration: const InputDecoration(labelText: 'min'),
              keyboardType: TextInputType.number,
              inputFormatters: [digitsOnly],
            ),
          ),
        ],
      ),
    ];
  }

  void _recalculateLiftingAndSave(double bodyWeight, Workout workout, int index, ExerciseBase exercise) {
    // update duration through sets and reps
    int durationSec = 0;
    for (var s in exercise.sets!) {
      if (s == null || s.reps == null || !s.finished) continue;
      durationSec += s.reps! * 3;
    }
    exercise.durationMin = (durationSec / 60.0).round();

    return _recalculateAndSave(bodyWeight, workout, index, exercise);
  }

  void _recalculateAndSave(double bodyWeight, Workout workout, int index, ExerciseBase exercise) {
    exercise.calcAndSetBurnedCalories(bodyWeight);
    // TODO save
    return;
  }
}

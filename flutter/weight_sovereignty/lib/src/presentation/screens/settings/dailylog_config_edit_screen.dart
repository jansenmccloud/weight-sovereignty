import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/config/config_validation.dart';
import 'package:weight_sovereignty/src/application/dailylog_config/dailylog_config_list_notifier.dart';
import 'package:weight_sovereignty/src/domain/config/dailylog_config.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';
import 'package:weight_sovereignty/src/presentation/widgets/settings/config_form_scaffold.dart';

class DailyLogConfigEditScreen extends ConsumerStatefulWidget {
  const DailyLogConfigEditScreen({super.key, this.configId});

  final int? configId;

  @override
  ConsumerState<DailyLogConfigEditScreen> createState() => _DailyLogConfigEditScreenState();
}

class _DailyLogConfigEditScreenState extends ConsumerState<DailyLogConfigEditScreen> {
  final digitsOnly = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  final _nameController = TextEditingController();
  final _bmrController = TextEditingController();
  final _deficitController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();
  final _carbsController = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.configId != null) {
      final existing = await ref.read(dailyLogConfigListProvider.notifier).read(widget.configId!);
      if (existing != null && mounted) {
        _nameController.text = existing.name ?? '';
        _bmrController.text = existing.bmrCaloriesKcal?.toString() ?? '';
        _deficitController.text = existing.plannedDeficitKcal?.toString() ?? '';
        _proteinController.text = existing.plannedProteinG?.toString() ?? '';
        _fatController.text = existing.plannedFatG?.toString() ?? '';
        _carbsController.text = existing.plannedCarbsG?.toString() ?? '';
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bmrController.dispose();
    _deficitController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nameError = validateConfigName(_nameController.text);
    if (nameError != null) {
      showConfigError(context, nameError);
      return;
    }

    setState(() => _saving = true);
    try {
      final config = DailyLogConfig()
        ..name = _nameController.text.trim()
        ..bmrCaloriesKcal = parseOptionalInt(_bmrController.text)
        ..plannedDeficitKcal = parseOptionalInt(_deficitController.text)
        ..plannedProteinG = parseOptionalInt(_proteinController.text)
        ..plannedFatG = parseOptionalInt(_fatController.text)
        ..plannedCarbsG = parseOptionalInt(_carbsController.text);
      if (widget.configId != null) config.id = widget.configId!;

      final notifier = ref.read(dailyLogConfigListProvider.notifier);
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
      title: widget.configId == null ? 'New profile' : 'Edit profile',
      isSaving: _saving,
      onSave: _save,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameController,
            style: TextStyle(color: AppTheme.white),
            decoration: const InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: AppTheme.white)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bmrController,
            style: TextStyle(color: AppTheme.white),
            decoration: const InputDecoration(labelText: 'BMR (kcal)', labelStyle: TextStyle(color: AppTheme.white)),
            keyboardType: TextInputType.number,
            inputFormatters: [digitsOnly],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _deficitController,
            style: TextStyle(color: AppTheme.white),
            decoration: const InputDecoration(labelText: 'Planned Deficit (kcal)', labelStyle: TextStyle(color: AppTheme.white)),
            keyboardType: TextInputType.number,
            inputFormatters: [digitsOnly],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _proteinController,
            style: TextStyle(color: AppTheme.white),
            decoration: const InputDecoration(labelText: 'Planned Protein (g)', labelStyle: TextStyle(color: AppTheme.white)),
            keyboardType: TextInputType.number,
            inputFormatters: [digitsOnly],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _fatController,
            style: TextStyle(color: AppTheme.white),
            decoration: const InputDecoration(labelText: 'Planned Fat (g)', labelStyle: TextStyle(color: AppTheme.white)),
            keyboardType: TextInputType.number,
            inputFormatters: [digitsOnly],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _carbsController,
            style: TextStyle(color: AppTheme.white),
            decoration: const InputDecoration(labelText: 'Planned Carbs (g)', labelStyle: TextStyle(color: AppTheme.white)),
            keyboardType: TextInputType.number,
            inputFormatters: [digitsOnly],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

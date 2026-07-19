import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/config/config_validation.dart';
import 'package:weight_sovereignty/src/application/food_config/food_config_list_notifier.dart';
import 'package:weight_sovereignty/src/domain/config/food_config.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';
import 'package:weight_sovereignty/src/presentation/widgets/settings/config_form_scaffold.dart';

class FoodConfigEditScreen extends ConsumerStatefulWidget {
  const FoodConfigEditScreen({super.key, this.configId});

  final int? configId;

  @override
  ConsumerState<FoodConfigEditScreen> createState() =>
      _FoodConfigEditScreenState();
}

class _FoodConfigEditScreenState extends ConsumerState<FoodConfigEditScreen> {
  final digitsOnly = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  final _nameController = TextEditingController();
  final _kcalController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _amountController = TextEditingController();
  bool _favorite = false;
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
          .read(foodConfigListProvider.notifier)
          .read(widget.configId!);
      if (existing != null && mounted) {
        _apply(existing);
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  void _apply(FoodConfig c) {
    _nameController.text = c.name ?? '';
    _favorite = c.favorite ?? false;
    _kcalController.text = c.intakeCaloriesKcal?.toString() ?? '';
    _proteinController.text = c.intakeProteinG?.toString() ?? '';
    _carbsController.text = c.intakeCarbsG?.toString() ?? '';
    _fatController.text = c.intakeFatG?.toString() ?? '';
    _amountController.text = c.amountG?.toString() ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _kcalController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  FoodConfig _buildConfig() {
    final config = FoodConfig()
      ..name = _nameController.text.trim()
      ..favorite = _favorite
      ..intakeCaloriesKcal = parseOptionalInt(_kcalController.text)
      ..intakeProteinG = parseOptionalInt(_proteinController.text)
      ..intakeCarbsG = parseOptionalInt(_carbsController.text)
      ..intakeFatG = parseOptionalInt(_fatController.text)
      ..amountG = parseOptionalInt(_amountController.text);
    if (widget.configId != null) config.id = widget.configId!;
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
      final notifier = ref.read(foodConfigListProvider.notifier);
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
      title: widget.configId == null ? 'New food preset' : 'Edit food preset',
      isSaving: _saving,
      onSave: _save,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          Text('Duplicate names replace the existing preset.',
            style: TextStyle(color: AppTheme.grey),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Favorite'),
            value: _favorite,
            onChanged: (v) => setState(() => _favorite = v),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _kcalController,
            decoration: const InputDecoration(labelText: 'Calories (kcal)'),
            keyboardType: TextInputType.number,
            inputFormatters: [digitsOnly],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _proteinController,
            decoration: const InputDecoration(labelText: 'Protein (g)'),
            keyboardType: TextInputType.number,
            inputFormatters: [digitsOnly],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _carbsController,
            decoration: const InputDecoration(labelText: 'Carbs (g)'),
            keyboardType: TextInputType.number,
            inputFormatters: [digitsOnly],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _fatController,
            decoration: const InputDecoration(labelText: 'Fat (g)'),
            keyboardType: TextInputType.number,
            inputFormatters: [digitsOnly],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Amount (g)'),
            keyboardType: TextInputType.number,
            inputFormatters: [digitsOnly],
          ),
        ],
      ),
    );
  }
}

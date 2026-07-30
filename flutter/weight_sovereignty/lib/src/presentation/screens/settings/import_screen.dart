import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/export_service.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

/// Import screen — 3-step vertical flow: pick file → preview → confirm import.
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

enum _Step { pick, preview, result }

class _ImportScreenState extends ConsumerState<ImportScreen> {
  _Step _step = _Step.pick;
  String? _fileName;
  List<int>? _fileBytes;
  Map<String, dynamic>? _preview;
  String? _statusMessage;
  bool _busy = false;

  /// Pick a JSON config file.
  Future<void> _pickFile() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result != null && result.files.single.bytes != null && mounted) {
        setState(() {
          _fileName = result.files.first.name;
          _fileBytes = result.files.first.bytes;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Parse the picked file and preview counts.
  Future<void> _previewImport() async {
    if (_fileBytes == null || _busy) return;
    setState(() => _busy = true);

    try {
      final jsonStr = utf8.decode(_fileBytes!);
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;

      if (data['exportFormat'] != 'weight_sovereignty_config') {
        throw FormatException('Invalid export format: expected weight_sovereignty_config');
      }

      _preview = {
        'food': List<dynamic>.from(data['foodConfigs'] ?? []).length,
        'exercise': List<dynamic>.from(data['exerciseConfigs'] ?? []).length,
        'workout': List<dynamic>.from(data['workoutConfigs'] ?? []).length,
        'dailyLog': List<dynamic>.from(data['dailyLogConfigs'] ?? []).length,
      };

      if (mounted) setState(() => _step = _Step.preview);
    } catch (e) {
      if (mounted) {
        setState(() => _statusMessage = 'Preview error: $e');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Execute the actual import.
  Future<void> _doImport() async {
    if (_fileBytes == null || _busy) return;
    setState(() => _busy = true);

    try {
      final jsonStr = utf8.decode(_fileBytes!);

      final service = ExportService(
        dailyLogRepo: ref.read(dailyLogRepositoryProvider),
        foodRepo: ref.read(foodRepositoryProvider),
        workoutRepo: ref.read(workoutRepositoryProvider),
        foodConfigRepo: ref.read(foodConfigRepositoryProvider),
        exerciseConfigRepo: ref.read(exerciseConfigRepositoryProvider),
        workoutConfigRepo: ref.read(workoutConfigRepositoryProvider),
        dailyLogConfigRepo: ref.read(dailyLogConfigRepositoryProvider),
      );

      final summary = await service.fromConfigJson(jsonStr);

      if (mounted) {
        setState(() {
          _statusMessage = 'Imported ${summary['total']} entries total.';
          _step = _Step.result;
          _busy = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Import error: $e';
          _step = _Step.result;
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import config presets')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Step indicator
            _stepIndicator(),
            const SizedBox(height: 24),

            // Step content
            switch (_step) {
              _Step.pick => _pickStep(),
              _Step.preview => _previewStep(),
              _Step.result => _resultStep(),
            },

            const Spacer(),

            // Status message
            if (_statusMessage != null) ...[
              SelectableText(_statusMessage!, style: TextStyle(color: AppTheme.red)),
              const SizedBox(height: 16),
            ],

            // Back button (not on first step)
            if (_step != _Step.pick)
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _step = _Step.pick;
                    _preview = null;
                    _statusMessage = null;
                  });
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _stepIndicator() {
    final labels = ['Pick file', 'Preview', 'Imported'];
    final currentIdx = _step.index;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(labels.length, (i) {
        final isActive = i == currentIdx;
        final isDone = i < currentIdx;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: isActive ? AppTheme.accent : (isDone ? AppTheme.grey : AppTheme.surface),
              child: Text(
                '${i + 1}',
                style: TextStyle(fontSize: 10, color: isActive || isDone ? AppTheme.white : AppTheme.grey),
              ),
            ),
            if (i < labels.length - 1) ...[
              Container(width: 40, height: 2, color: i < currentIdx ? AppTheme.accent : AppTheme.surface),
            ],
          ],
        );
      }),
    );
  }

  Widget _pickStep() {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: _busy ? null : _pickFile,
          icon: const Icon(Icons.file_upload_outlined),
          label: Text(_fileName != null ? 'Selected: $_fileName (tap to change)' : 'Select config file (.json)'),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20)),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _fileBytes == null || _busy ? null : _previewImport,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Preview'),
        ),
      ],
    );
  }

  Widget _previewStep() {
    final p = _preview ?? {};
    return Column(
      children: [
        Card(
          color: AppTheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Will import:', style: TextStyle(color: AppTheme.white)),
                const SizedBox(height: 8),
                _countRow('Food presets', p['food'] ?? 0),
                _countRow('Exercise presets', p['exercise'] ?? 0),
                _countRow('Workout presets', p['workout'] ?? 0),
                _countRow('Daily log configs', p['dailyLog'] ?? 0),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Imported entries will overwrite existing entries with the same name.',
          style: TextStyle(color: AppTheme.grey, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        FilledButton.icon(
          onPressed: _busy ? null : _doImport,
          icon: _busy
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.cloud_upload_outlined),
          label: Text(_busy ? 'Importing…' : 'Import all'),
        ),
      ],
    );
  }

  Widget _resultStep() {
    return Card(
      color: AppTheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline, size: 48, color: AppTheme.green),
            const SizedBox(height: 16),
            Text(_statusMessage ?? 'Import complete', style: const TextStyle(color: AppTheme.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _countRow(String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.white)),
          Text('$count', style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
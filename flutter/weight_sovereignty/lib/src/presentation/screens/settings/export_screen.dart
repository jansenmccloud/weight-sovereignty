import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/export_service.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

/// Export screen — lets the user export time-series data as CSV or config presets as JSON.
class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

enum ExportDataType { dailyLog, food, workout }

enum ExportType { timeSeries, configPresets }

class _ExportScreenState extends ConsumerState<ExportScreen> {
  ExportType _exportType = ExportType.timeSeries;
  ExportDataType _dataType = ExportDataType.dailyLog;
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();
  String _statusMessage = 'Select data type and date range.';
  bool _exporting = false;

  void _onExportTypeChanged(ExportType value) {
    setState(() => _exportType = value);
  }

  void _onDataTypeChanged(ExportDataType value) {
    setState(() => _dataType = value);
  }

  Future<void> _pickStartDate() async {
    final date = await showDatePicker(context: context, initialDate: _startDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
    if (date != null) {
      setState(() => _startDate = date);
    }
  }

  Future<void> _pickEndDate() async {
    final date = await showDatePicker(context: context, initialDate: _endDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
    if (date != null) {
      setState(() => _endDate = date);
    }
  }

  /// Format a [DateTime] as 'yyyymmdd' for filenames.
  String _ymd(DateTime dt) {
    return '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}';
  }

  Future<void> _handleExport() async {
    // Config presets: no date range needed.
    if (_exportType == ExportType.configPresets) {
      if (_exporting) return;
      setState(() {
        _exporting = true;
        _statusMessage = 'Exporting…';
      });
      try {
        final service = ExportService(
          dailyLogRepo: ref.read(dailyLogRepositoryProvider),
          foodRepo: ref.read(foodRepositoryProvider),
          workoutRepo: ref.read(workoutRepositoryProvider),
          foodConfigRepo: ref.read(foodConfigRepositoryProvider),
          exerciseConfigRepo: ref.read(exerciseConfigRepositoryProvider),
          workoutConfigRepo: ref.read(workoutConfigRepositoryProvider),
          dailyLogConfigRepo: ref.read(dailyLogConfigRepositoryProvider),
        );
        final jsonContent = await service.toConfigJson();
        final fileName = 'weight_sovereignty_config_${_ymd(DateTime.now())}.json';
        final result = await FilePicker.platform.saveFile(fileName: fileName, bytes: utf8.encode(jsonContent));
        if (result != null && mounted) {
          setState(() => _statusMessage = 'Config export successful.');
        } else if (mounted) {
          setState(() => _statusMessage = 'Export cancelled or failed.');
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _exporting = false;
            _statusMessage = 'Export error: $e';
          });
        }
      } finally {
        if (mounted) setState(() => _exporting = false);
      }
      return;
    }

    // Time series: require date range.
    if (_startDate == null || _endDate == null) {
      setState(() => _statusMessage = 'Please select both start and end dates.');
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      setState(() => _statusMessage = 'End date must be on or after start date.');
      return;
    }

    setState(() {
      _exporting = true;
      _statusMessage = 'Exporting…';
    });

    try {
      final dailyLogRepo = ref.read(dailyLogRepositoryProvider);
      final foodRepo = ref.read(foodRepositoryProvider);
      final workoutRepo = ref.read(workoutRepositoryProvider);

      final service = ExportService(
        dailyLogRepo: dailyLogRepo,
        foodRepo: foodRepo,
        workoutRepo: workoutRepo,
        foodConfigRepo: ref.read(foodConfigRepositoryProvider),
        exerciseConfigRepo: ref.read(exerciseConfigRepositoryProvider),
        workoutConfigRepo: ref.read(workoutConfigRepositoryProvider),
        dailyLogConfigRepo: ref.read(dailyLogConfigRepositoryProvider),
      );

      final csvContent = switch (_dataType) {
        ExportDataType.dailyLog => await service.toDailyLogCsv(_startDate!, _endDate!),
        ExportDataType.food => await service.toFoodCsv(_startDate!, _endDate!),
        ExportDataType.workout => await service.toWorkoutCsv(_startDate!, _endDate!),
      };

      final fileName =
          'weight_sovereignty_${_dataType.name}'
          '_${_ymd(_startDate!)}'
          '_to_${_ymd(_endDate!)}.csv';

      final result = await FilePicker.platform.saveFile(fileName: fileName, bytes: utf8.encode(csvContent));

      if (result != null && mounted) {
        setState(() => _statusMessage = 'Exported successfully.');
      } else if (mounted) {
        setState(() => _statusMessage = 'Export cancelled or failed.');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _exporting = false;
          _statusMessage = 'Export error: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _exporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data export')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Export type selector (time series vs config presets)
            _sectionLabel('Export type'),
            const SizedBox(height: 8),
            _exportTypeSegmented(),
            const SizedBox(height: 12),

            // Time series section
            if (_exportType == ExportType.timeSeries) ...[
              _sectionLabel('Data type'),
              const SizedBox(height: 8),
              SegmentedList(value: _dataType, onChanged: _onDataTypeChanged),
              const SizedBox(height: 12),

              // Date range
              _sectionLabel('Date range'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _dateButton(_startDate ?? DateTime.now(), 'Start', _pickStartDate)),
                  const SizedBox(width: 12),
                  Expanded(child: _dateButton(_endDate ?? DateTime.now(), 'End', _pickEndDate)),
                ],
              ),
              const SizedBox(height: 32),

              // Export button (time series)
              FilledButton.icon(
                onPressed: _exporting ? null : _handleExport,
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), textStyle: const TextStyle(fontSize: 16)),
                icon: _exporting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.file_upload_outlined),
                label: Text(_exporting ? 'Exporting…' : 'Export & Save'),
              ),
              
            ] else ...[
              // Export button (config presets)
              FilledButton.icon(
                onPressed: _exporting ? null : _handleExport,
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), textStyle: const TextStyle(fontSize: 16)),
                icon: _exporting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.file_upload_outlined),
                label: Text(_exporting ? 'Exporting…' : 'Export config data'),
              ),
              const Spacer(),
            ],

            const SizedBox(height: 16),

            // Status message
            SelectableText(_statusMessage, style: TextStyle(color: _statusMessage.contains('error') || _statusMessage.contains('failed') ? AppTheme.red : AppTheme.grey)),
          ],
        ),
      ),
    );
  }

  /// Export type segmented control.
  Widget _exportTypeSegmented() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final type = index == 0 ? ExportType.timeSeries : ExportType.configPresets;
          final isSelected = type == _exportType;
          final label = type == ExportType.timeSeries ? 'Time Series Data' : 'Config Presets';
          return Material(
            color: isSelected ? AppTheme.accent : AppTheme.surface,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => _onExportTypeChanged(type),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  label,
                  style: TextStyle(color: isSelected ? AppTheme.white : AppTheme.grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _dateButton(DateTime date, String label, VoidCallback onTap) {
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppTheme.grey, fontSize: 12)),
              const SizedBox(height: 4),
              Text('${date.day}/${date.month}/${date.year}', style: const TextStyle(color: AppTheme.white, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: AppTheme.grey, fontSize: 13, fontWeight: FontWeight.w600),
    );
  }
}

/// Small segmented list for data type selection.
class SegmentedList extends StatelessWidget {
  const SegmentedList({super.key, required this.value, required this.onChanged});

  final ExportDataType value;
  final ValueChanged<ExportDataType> onChanged;

  static const _dataTypes = [ExportDataType.dailyLog, ExportDataType.food, ExportDataType.workout];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _dataTypes.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final dataType = _dataTypes[index];
          final isSelected = dataType == value;
          return Material(
            color: isSelected ? AppTheme.accent : AppTheme.surface,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => onChanged(dataType),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  SegmentedList.label(dataType),
                  style: TextStyle(color: isSelected ? AppTheme.white : AppTheme.grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static String label(ExportDataType dt) {
    switch (dt) {
      case ExportDataType.dailyLog:
        return 'DailyLog';
      case ExportDataType.food:
        return 'Food';
      case ExportDataType.workout:
        return 'Workout';
    }
  }
}

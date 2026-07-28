import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/application/export_service.dart';
import 'package:weight_sovereignty/src/application/providers/repository_providers.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

/// Export screen — lets the user export DailyLog, Food, or Workout data as CSV.
class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

enum _ExportDataType { dailyLog, food, workout }

class _ExportScreenState extends ConsumerState<ExportScreen> {
  _ExportDataType _dataType = _ExportDataType.dailyLog;
  DateTime? _startDate;
  DateTime? _endDate;
  String _statusMessage = 'Select data type and date range.';
  bool _exporting = false;

  Future<void> _pickStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _startDate = date);
    }
  }

  Future<void> _pickEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _endDate = date);
    }
  }

  Future<void> _handleExport() async {
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
      );

      final csvContent = switch (_dataType) {
        _ExportDataType.dailyLog => await service.toDailyLogCsv(_startDate!, _endDate!),
        _ExportDataType.food => await service.toFoodCsv(_startDate!, _endDate!),
        _ExportDataType.workout => await service.toWorkoutCsv(_startDate!, _endDate!),
      };

      final fileName = 'weight_sovereignty_${_dataType.name}'
          '_${_startDate!.toString().replaceAll('-', '')}_to_${_endDate!.toString().replaceAll('-', '')}.csv';

      final result = await FilePicker.platform.saveFile(
        fileName: fileName,
        bytes: utf8.encode(csvContent),
      );

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
            // Data type selector
            _sectionLabel('Data type'),
            const SizedBox(height: 8),
            SegmentedList(),
            const SizedBox(height: 24),

            // Date range
            _sectionLabel('Date range'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _dateButton(_startDate ?? DateTime.now(), 'Start', _pickStartDate),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dateButton(_endDate ?? DateTime.now(), 'End', _pickEndDate),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Export button
            FilledButton.icon(
              onPressed: _exporting ? null : _handleExport,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              icon: _exporting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.file_download_outlined),
              label: Text(_exporting ? 'Exporting…' : 'Export & Save'),
            ),
            const Spacer(),

            // Status message
            SelectableText(
              _statusMessage,
              style: TextStyle(
                color: _statusMessage.contains('error') || _statusMessage.contains('failed')
                    ? AppTheme.red
                    : AppTheme.grey,
              ),
            ),
          ],
        ),
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
              Text(
                label,
                style: const TextStyle(color: AppTheme.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                '${date.day}/${date.month}/${date.year}',
                style: const TextStyle(color: AppTheme.white, fontSize: 16),
              ),
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
class SegmentedList extends StatefulWidget {
  const SegmentedList({super.key});

  @override
  State<SegmentedList> createState() => _SegmentedListState();
}

class _SegmentedListState extends State<SegmentedList> {
  int _selected = 0;
  final List<String> _items = ['DailyLog', 'Food', 'Workout'];
  final List<_ExportDataType> _types = [_ExportDataType.dailyLog, _ExportDataType.food, _ExportDataType.workout];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == _selected;
          return Material(
            color: isSelected ? AppTheme.accent : AppTheme.surface,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => setState(() => _selected = index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  _items[index],
                  style: TextStyle(
                    color: isSelected ? AppTheme.white : AppTheme.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
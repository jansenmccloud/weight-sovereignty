import 'package:flutter/material.dart';
import 'package:weight_sovereignty/src/presentation/widgets/stats/calories_chart.dart';

/// StatefulWidget that owns resolution state for the calories chart.
class CaloriesChartSection extends StatefulWidget {
  const CaloriesChartSection({super.key, required this.dataPoints});

  final List<CaloriesChartDataPoint> dataPoints;

  @override
  State<CaloriesChartSection> createState() => _CaloriesChartSectionState();
}

class _CaloriesChartSectionState extends State<CaloriesChartSection> {
  ChartResolution _resolution = ChartResolution.daily;

  List<CaloriesChartDataPoint> get _resampledPoints {
    switch (_resolution) {
      case ChartResolution.daily:
        return widget.dataPoints;

      case ChartResolution.weekly:
        return _aggregateWeekly(widget.dataPoints);

      case ChartResolution.monthly:
        return _aggregateMonthly(widget.dataPoints);
    }
  }

  /// Aggregate daily points into 7-day rolling mean buckets.
  List<CaloriesChartDataPoint> _aggregateWeekly(List<CaloriesChartDataPoint> points) {
    if (points.isEmpty) return [];

    final Map<DateTime, List<CaloriesChartDataPoint>> buckets = <DateTime, List<CaloriesChartDataPoint>>{};

    for (final p in points) {
      final daysFromStart = p.date.difference(points.first.date).inDays;
      final bucketIndex = daysFromStart ~/ 7;
      final anchorDate = points.first.date.add(Duration(days: bucketIndex * 7));
      buckets.putIfAbsent(anchorDate, () => []).add(p);
    }

    final sortedAnchors = buckets.keys.toList()..sort();
    return sortedAnchors.map((anchor) {
      final bp = buckets[anchor]!;
      return _averagePoints(bp);
    }).toList();
  }

  /// Aggregate daily points into per-calendar-month buckets.
  List<CaloriesChartDataPoint> _aggregateMonthly(List<CaloriesChartDataPoint> points) {
    if (points.isEmpty) return [];

    final Map<String, List<CaloriesChartDataPoint>> buckets = <String, List<CaloriesChartDataPoint>>{};

    for (final p in points) {
      final key = '${p.date.year}-${p.date.month.toString().padLeft(2, '0')}';
      buckets.putIfAbsent(key, () => []).add(p);
    }

    final sortedKeys = buckets.keys.toList()..sort();
    return sortedKeys.map((key) {
      final bp = buckets[key]!;
      return _averagePoints(bp);
    }).toList();
  }

  /// Compute average CaloriesChartDataPoint from a bucket of points.
  CaloriesChartDataPoint _averagePoints(List<CaloriesChartDataPoint> points) {
    double? avgIntake, avgBmr, avgBurned, avgPlannedDeficit, avgActualDeficit;

    final nonNullIntake = points.where((p) => p.intake != null).toList();
    if (nonNullIntake.isNotEmpty) {
      avgIntake = nonNullIntake.fold<double>(0, (s, p) => s + p.intake!) / nonNullIntake.length;
    }

    final nonNullBmr = points.where((p) => p.bmr != null).toList();
    if (nonNullBmr.isNotEmpty) {
      avgBmr = nonNullBmr.fold<double>(0, (s, p) => s + p.bmr!) / nonNullBmr.length;
    }

    final nonNullBurned = points.where((p) => p.burned != null).toList();
    if (nonNullBurned.isNotEmpty) {
      avgBurned = nonNullBurned.fold<double>(0, (s, p) => s + p.burned!) / nonNullBurned.length;
    }

    final nonNullDeficit = points.where((p) => p.plannedDeficit != null).toList();
    if (nonNullDeficit.isNotEmpty) {
      avgPlannedDeficit = nonNullDeficit.fold<double>(0, (s, p) => s + p.plannedDeficit!) / nonNullDeficit.length;
    }

    final nonNullActualDeficit = points.where((p) => p.actualDeficit != null).toList();
    if (nonNullActualDeficit.isNotEmpty) {
      avgActualDeficit = nonNullActualDeficit.fold<double>(0, (s, p) => s + p.actualDeficit!) / nonNullActualDeficit.length;
    }

    // Use first date as anchor
    final anchorDate = points.first.date;

    return CaloriesChartDataPoint(
      date: anchorDate,
      intake: avgIntake,
      bmr: avgBmr,
      burned: avgBurned,
      plannedDeficit: avgPlannedDeficit,
      actualDeficit: avgActualDeficit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ResolutionPicker(
          resolution: _resolution,
          onChanged: (r) => setState(() => _resolution = r),
        ),
        const SizedBox(height: 8),
        CaloriesChart(dataPoints: _resampledPoints),
      ],
    );
  }
}
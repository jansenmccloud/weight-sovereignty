import 'package:flutter/material.dart';
import 'package:weight_sovereignty/src/domain/entity/dailylog.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

/// Data point for the calories chart
class CaloriesChartDataPoint {
  final DateTime date;
  final double? intake;
  final double? bmr;
  final double? burned;
  final double? plannedDeficit;
  final double? actualDeficit;

  const CaloriesChartDataPoint({required this.date, this.intake, this.bmr, this.burned, this.plannedDeficit, this.actualDeficit});

  /// Factory from a DailyLog (for daily resolution)
  factory CaloriesChartDataPoint.fromDailyLog(log) {
    final intake = log.calculation?.totalIntakeCaloriesKcal?.toDouble();
    final bmr = log.dailyLogBase?.bmrCaloriesKcal?.toDouble();
    final burned = log.calculation?.totalBurnedCaloriesKcal?.toDouble();
    final plannedDeficit = log.dailyLogBase?.plannedDeficitKcal?.toDouble();
    final actualDeficit = ((bmr ?? 0) + (burned ?? 0)) - (intake ?? 0);
    return CaloriesChartDataPoint(
      date: DateTime(log.date!.year, log.date!.month, log.date!.day),
      intake: intake,
      bmr: bmr,
      burned: burned,
      plannedDeficit: plannedDeficit,
      actualDeficit: actualDeficit.isFinite ? actualDeficit : null,
    );
  }

  /// Factory from a list of DailyLogs for weekly bucket (7-day)
  factory CaloriesChartDataPoint.fromWeeklyBucket(List<DailyLog> logs) {
    // Compute averages per bucket, then combine into final point
    final baseDate = logs.first.date!;
    return _bucketToDataPoint(logs, baseDate);
  }

  /// Factory from a list of DailyLogs for monthly bucket
  factory CaloriesChartDataPoint.fromMonthlyBucket(List<DailyLog> logs, String monthKey) {
    // Parse monthKey to get anchor date
    final parts = monthKey.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final baseDate = DateTime(year, month, 1);
    return _bucketToDataPoint(logs, baseDate);
  }

  static CaloriesChartDataPoint _bucketToDataPoint(List<DailyLog> logs, DateTime anchor) {
    double sumIntake = 0, countIntake = 0;
    double sumBmr = 0, countBmr = 0;
    double sumBurned = 0, countBurned = 0;
    double sumPlannedDeficit = 0, countPlannedDeficit = 0;

    for (final log in logs) {
      final intakeVal = log.calculation?.totalIntakeCaloriesKcal?.toDouble();
      if (intakeVal != null && intakeVal > 0) {
        sumIntake += intakeVal;
        countIntake++;
      }

      final bmrVal = log.dailyLogBase?.bmrCaloriesKcal?.toDouble();
      if (bmrVal != null && bmrVal > 0) {
        sumBmr += bmrVal;
        countBmr++;
      }

      final burnedVal = log.calculation?.totalBurnedCaloriesKcal?.toDouble();
      if (burnedVal != null && burnedVal > 0) {
        sumBurned += burnedVal;
        countBurned++;
      }

      final plannedVal = log.dailyLogBase?.plannedDeficitKcal?.toDouble();
      if (plannedVal != null && plannedVal > 0) {
        sumPlannedDeficit += plannedVal;
        countPlannedDeficit++;
      }
    }

    final avgIntake = countIntake > 0 ? sumIntake / countIntake : null;
    final avgBmr = countBmr > 0 ? sumBmr / countBmr : null;
    final avgBurned = countBurned > 0 ? sumBurned / countBurned : null;
    final avgPlannedDeficit = countPlannedDeficit > 0 ? sumPlannedDeficit / countPlannedDeficit : null;

    // For weekly/monthly: sum burned (cumulative), average BMR and planned deficit
    final effectiveBurned = avgBurned ?? 0;
    final actualDeficit = ((avgBmr ?? 0) + effectiveBurned) - (avgIntake ?? 0);

    return CaloriesChartDataPoint(
      date: anchor,
      intake: avgIntake,
      bmr: avgBmr,
      burned: effectiveBurned,
      plannedDeficit: avgPlannedDeficit,
      actualDeficit: actualDeficit.isFinite ? actualDeficit : null,
    );
  }
}

/// Resolution mode for the calories chart
enum ChartResolution { daily, weekly, monthly }

/// Custom paint chart showing multiple calorie-related curves.
class CaloriesChart extends StatefulWidget {
  final List<CaloriesChartDataPoint> dataPoints;
  final double height;

  const CaloriesChart({super.key, required this.dataPoints, this.height = 240.0});

  @override
  State<CaloriesChart> createState() => _CaloriesChartState();
}

class _CaloriesChartState extends State<CaloriesChart> {
  DateTime? _hoverDate;

  CaloriesChartDataPoint? _findNearestPoint(List<CaloriesChartDataPoint> points) {
    if (_hoverDate == null || points.isEmpty) return null;
    double closestDist = double.infinity;
    CaloriesChartDataPoint? closest;
    for (final p in points) {
      final dist = (p.date.millisecondsSinceEpoch - _hoverDate!.millisecondsSinceEpoch).abs();
      if (dist < closestDist) {
        closestDist = dist.toDouble();
        closest = p;
      }
    }
    return closest;
  }

  @override
  Widget build(BuildContext context) {
    final sorted = List<CaloriesChartDataPoint>.from(widget.dataPoints)..sort((a, b) => a.date.compareTo(b.date));

    if (sorted.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text('No calorie data available', style: TextStyle(color: AppTheme.white)),
        ),
      );
    }

    final accent = Theme.of(context).colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        return HoverInterceptor(
          onHover: (localPosition) {
            if (constraints.maxWidth <= 0) return;
            final ratio = localPosition.dx / constraints.maxWidth;
            final firstDate = sorted.first.date;
            final lastDate = sorted.last.date;
            final span = lastDate.difference(firstDate).inMilliseconds.toDouble();
            if (span <= 0) {
              setState(() => _hoverDate = firstDate);
              return;
            }
            final targetMs = firstDate.millisecondsSinceEpoch + ratio * span;
            setState(() => _hoverDate = DateTime.fromMillisecondsSinceEpoch(targetMs.toInt()));
          },
          child: SizedBox(
            height: widget.height,
            width: double.infinity,
            child: CustomPaint(
              size: Size(constraints.maxWidth, widget.height),
              painter: _CaloriesChartPainter(dataPoints: sorted, hoveredPoint: _findNearestPoint(sorted), accentColor: accent),
            ),
          ),
        );
      },
    );
  }
}

/// Intercepts pointer motion within the widget bounds.
class HoverInterceptor extends StatefulWidget {
  final Widget child;
  final void Function(Offset localPosition) onHover;

  const HoverInterceptor({super.key, required this.child, required this.onHover});

  @override
  State<HoverInterceptor> createState() => _HoverInterceptorState();
}

class _HoverInterceptorState extends State<HoverInterceptor> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final box = context.findRenderObject() as RenderBox;
        widget.onHover(box.globalToLocal(event.position));
      },
      child: widget.child,
    );
  }
}

class _CaloriesChartPainter extends CustomPainter {
  final List<CaloriesChartDataPoint> dataPoints;
  final CaloriesChartDataPoint? hoveredPoint;
  final Color accentColor;

  _CaloriesChartPainter({required this.dataPoints, required this.hoveredPoint, required this.accentColor});

  // Y-axis range for scaling (only non-null intake values)
  double _maxValue() {
    double max = 0;
    for (final p in dataPoints) {
      if (p.intake != null) max = p.intake! > max ? p.intake! : max;
      if (p.bmr != null) max = p.bmr! > max ? p.bmr! : max;
      if (p.burned != null) max = (p.bmr ?? 0) + (p.burned ?? 0) > max ? (p.bmr! + p.burned!) : max;
    }
    return max > 0 ? max * 1.15 : 2500.0; // 15% headroom
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final padding = const EdgeInsets.all(16.0);
    final chartWidth = size.width - padding.left - padding.right;
    final chartHeight = size.height - padding.top - padding.bottom;
    final maxY = _maxValue();

    double xForIndex(int index) => padding.left + (index / ((dataPoints.length > 1) ? dataPoints.length - 1 : 1)).clamp(0.0, 1.0) * chartWidth;
    double yForValue(double value) {
      final ratio = value / maxY;
      return padding.top + chartHeight - ratio * chartHeight;
    }

    // Paints
    final gridPaint = Paint()
      ..color = AppTheme.white.withAlpha(25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final intakePaint = Paint()
      ..color = AppTheme.white.withAlpha(200)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final bmrPaint = Paint()
      ..color = AppTheme.white.withAlpha(100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final burnedPaint = Paint()
      ..color = accentColor.withAlpha(180)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final deficitLinePaint = Paint()
      ..color = AppTheme.green.withAlpha(180)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Zero line (break-even reference)
    final zeroY = yForValue(0);
    canvas.drawLine(
      Offset(padding.left, zeroY),
      Offset(size.width - padding.right, zeroY),
      gridPaint
        ..color = AppTheme.white.withAlpha(50)
        ..strokeWidth = 1.0,
    );

    // Grid lines (Y-axis)
    final gridSteps = 5;
    for (int i = 0; i <= gridSteps; i++) {
      final value = maxY * (i / gridSteps);
      final y = yForValue(value);
      canvas.drawLine(Offset(padding.left, y), Offset(size.width - padding.right, y), gridPaint);

      // Y-axis labels
      final label = value.round().toString();
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(color: AppTheme.white, fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 5));
    }

    // X-axis labels (dates)
    // TODO following code needs simplification
    final dateSteps = dataPoints.length > 7 ? (dataPoints.length > 31 ? 6 : 5) : dataPoints.length;
    final step = (dataPoints.length - 1) / (dateSteps < 2 ? 1 : dateSteps);

    for (int i = 0; i <= dateSteps && i * step < dataPoints.length; i++) {
      final idx = (i * step).toInt().clamp(0, dataPoints.length - 1);
      final x = xForIndex(idx);
      final date = dataPoints[idx].date;

      // Tick mark
      canvas.drawLine(Offset(x, padding.top), Offset(x, padding.top + 4), gridPaint..strokeWidth = 0.5);

      // Label
      String label = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';

      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(color: AppTheme.white, fontSize: 8),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height - padding.bottom + 6));
    }

    // Area fill for actual deficit (green = deficit, red = surplus)
    if (dataPoints.length > 1) {
      final pathBelow = Path();
      final pathAbove = Path();
      bool started = false;

      for (int i = 0; i < dataPoints.length; i++) {
        final x = xForIndex(i);
        final actualDeficit = dataPoints[i].actualDeficit;
        if (actualDeficit == null) {
          started = false;
          continue;
        }

        final y = yForValue(actualDeficit);

        if (!started) {
          pathBelow.moveTo(x, zeroY);
          pathAbove.moveTo(x, zeroY);
          started = true;
        }

        pathBelow.lineTo(x, y);
        pathAbove.lineTo(x, y);

        if (i == dataPoints.length - 1) {
          pathBelow.lineTo(x, zeroY);
          pathAbove.lineTo(x, zeroY);
        }
      }

      // Deficit (positive = burning more than eating → green)
      final deficitPath = Path();
      for (int i = 0; i < dataPoints.length; i++) {
        final actualDeficit = dataPoints[i].actualDeficit;
        if (actualDeficit == null) continue;
        final x = xForIndex(i);
        final y = yForValue(actualDeficit);

        if (actualDeficit >= 0) {
          if (i == 0 || dataPoints[i - 1].actualDeficit == null || dataPoints[i - 1].actualDeficit! < 0) {
            deficitPath.moveTo(x, zeroY);
          }
          deficitPath.lineTo(x, y);
          if (i == dataPoints.length - 1 || dataPoints[i + 1].actualDeficit == null || dataPoints[i + 1].actualDeficit! < 0) {
            deficitPath.lineTo(x, zeroY);
          }
        }
      }

      final yellowPaint = Paint()
        ..shader = LinearGradient(
          colors: [AppTheme.yellow.withAlpha(5), AppTheme.yellow.withAlpha(60)],
          stops: const [0.3, 1.0],
        ).createShader(Rect.fromLTWH(padding.left, padding.top, chartHeight, chartHeight));

      // Surplus (negative actual deficit → red)
      final surplusPath = Path();
      for (int i = 0; i < dataPoints.length; i++) {
        final actualDeficit = dataPoints[i].actualDeficit;
        if (actualDeficit == null || actualDeficit >= 0) continue;
        final x = xForIndex(i);
        final y = yForValue(actualDeficit);

        if (i == 0 || dataPoints[i - 1].actualDeficit == null || dataPoints[i - 1].actualDeficit! > 0) {
          surplusPath.moveTo(x, zeroY);
        }
        surplusPath.lineTo(x, y);
        if (i == dataPoints.length - 1 || dataPoints[i + 1].actualDeficit == null || dataPoints[i + 1].actualDeficit! > 0) {
          surplusPath.lineTo(x, zeroY);
        }
      }

      final redPaint = Paint()
        ..shader = LinearGradient(
          colors: [AppTheme.red.withAlpha(0), AppTheme.red.withAlpha(60)],
          stops: const [0.3, 1.0],
        ).createShader(Rect.fromLTWH(padding.left, padding.top, chartHeight, chartHeight));

      canvas.drawPath(surplusPath, redPaint);
      canvas.drawPath(deficitPath, yellowPaint);
    }

    // BMR line (dashed)
    final bmrPoints = <Offset>[];
    for (int i = 0; i < dataPoints.length; i++) {
      final bmr = dataPoints[i].bmr;
      if (bmr == null) continue;
      bmrPoints.add(Offset(xForIndex(i), yForValue(bmr)));
    }
    if (bmrPoints.length > 1) {
      // Draw dashed BMR line
      final path = Path()..moveTo(bmrPoints.first.dx, bmrPoints.first.dy);
      for (int i = 1; i < bmrPoints.length; i++) {
        path.lineTo(bmrPoints[i].dx, bmrPoints[i].dy);
      }
      canvas.drawPath(path, bmrPaint..strokeCap = StrokeCap.round);

      // Dashed effect via draw points with gaps is hard; use a simpler approach: draw small circles instead
      for (int i = 0; i < bmrPoints.length; i++) {
        if (i % 3 == 0) {
          canvas.drawCircle(bmrPoints[i], 2.5, bmrPaint..style = PaintingStyle.fill);
        }
      }
    }

    // Burned calories line (BMR + burned)
    final burnedPoints = <Offset>[];
    for (int i = 0; i < dataPoints.length; i++) {
      final bmr = dataPoints[i].bmr;
      final burned = dataPoints[i].burned;
      if (bmr == null || burned == null) continue;
      burnedPoints.add(Offset(xForIndex(i), yForValue(bmr + burned)));
    }
    if (burnedPoints.length > 1) {
      final path = Path()..moveTo(burnedPoints.first.dx, burnedPoints.first.dy);
      for (int i = 1; i < burnedPoints.length; i++) {
        path.lineTo(burnedPoints[i].dx, burnedPoints[i].dy);
      }
      canvas.drawPath(path, burnedPaint);
    }

    // Intake calories line (solid white)
    final intakePoints = <Offset>[];
    for (int i = 0; i < dataPoints.length; i++) {
      final intake = dataPoints[i].intake;
      if (intake == null) continue;
      intakePoints.add(Offset(xForIndex(i), yForValue(intake)));
    }
    if (intakePoints.length > 1) {
      final path = Path()..moveTo(intakePoints.first.dx, intakePoints.first.dy);
      for (int i = 1; i < intakePoints.length; i++) {
        path.lineTo(intakePoints[i].dx, intakePoints[i].dy);
      }
      canvas.drawPath(path, intakePaint);
    }

    // Planned deficit line (dotted green)
    final plannedPoints = <Offset>[];
    for (int i = 0; i < dataPoints.length; i++) {
      final pd = dataPoints[i].plannedDeficit;
      if (pd == null) continue;
      plannedPoints.add(Offset(xForIndex(i), yForValue(pd)));
    }
    if (plannedPoints.length > 1) {
      // Dotted line: draw small circles at each point
      for (final p in plannedPoints) {
        canvas.drawCircle(p, 2.5, deficitLinePaint..style = PaintingStyle.fill);
      }
    }

    // Hover indicator
    if (hoveredPoint != null) {
      final idx = dataPoints.indexOf(hoveredPoint!);
      if (idx >= 0) {
        final x = xForIndex(idx);
        final actualDeficit = hoveredPoint!.actualDeficit;
        final hoverY = actualDeficit != null ? yForValue(actualDeficit) : zeroY;

        // Vertical line
        canvas.drawLine(
          Offset(x, padding.top),
          Offset(x, size.height - padding.bottom),
          Paint()
            ..color = accentColor.withAlpha(100)
            ..strokeWidth = 1.0,
        );

        // Highlight hovered point on actual deficit curve
        if (actualDeficit != null) {
          canvas.drawCircle(Offset(x, hoverY), 5.0, Paint()..color = AppTheme.green);
        }

        // Label with all values
        final lines = <TextSpan>[];
        lines.add(TextSpan(text: '${hoveredPoint!.date.day}/${hoveredPoint!.date.month}\n'));
        if (hoveredPoint!.intake != null) lines.add(TextSpan(text: 'Intake: ${hoveredPoint!.intake!.round()} kcal  '));
        if (hoveredPoint!.bmr != null) lines.add(TextSpan(text: 'BMR: ${hoveredPoint!.bmr!.round()} kcal  '));
        if (hoveredPoint!.burned != null) lines.add(TextSpan(text: 'Burned: ${hoveredPoint!.burned!.round()} kcal  '));
        if (hoveredPoint!.actualDeficit != null) {
          final color = hoveredPoint!.actualDeficit! >= 0 ? AppTheme.green : AppTheme.red;
          lines.add(
            TextSpan(
              text: '${hoveredPoint!.actualDeficit!.round()} kcal\n',
              style: TextStyle(color: color),
            ),
          );
        }

        // Build label text
        final labelParts = <String>[];
        if (hoveredPoint!.intake != null) labelParts.add('IN: ${hoveredPoint!.intake!.round()}');
        if (hoveredPoint!.bmr != null) labelParts.add('BMR: ${hoveredPoint!.bmr!.round()}');
        if (hoveredPoint!.burned != null) labelParts.add('BRN: ${hoveredPoint!.burned!.round()}');
        final ad = hoveredPoint!.actualDeficit;
        if (ad != null) {
          final color = ad >= 0 ? '🟢' : '🔴';
          labelParts.add('$color${ad.round()}');
        }

        final labelText = labelParts.join('\n');
        final textPainter = TextPainter(
          text: TextSpan(
            text: labelText,
            style: TextStyle(color: AppTheme.white, fontSize: 10),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        final labelOffset = Offset(x - textPainter.width / 2 - 6, hoverY - textPainter.height - 14);
        canvas.drawRRect(RRect.fromRectAndRadius(labelOffset & Size(textPainter.width + 12, textPainter.height + 8), const Radius.circular(6)), Paint()..color = AppTheme.background);
        textPainter.paint(canvas, labelOffset + const Offset(6, 4));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CaloriesChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints || oldDelegate.hoveredPoint != hoveredPoint;
  }
}

/// Pill-style resolution picker row
class ResolutionPicker extends StatelessWidget {
  final ChartResolution resolution;
  final ValueChanged<ChartResolution> onChanged;

  const ResolutionPicker({super.key, required this.resolution, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final options = [ChartResolution.daily, ChartResolution.weekly, ChartResolution.monthly];

    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final opt = options[index];
          final selected = opt == resolution;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => onChanged(opt),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: selected ? AppTheme.white.withAlpha(40) : AppTheme.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selected ? AppTheme.white.withAlpha(120) : AppTheme.white.withAlpha(30)),
                ),
                child: Text(
                  opt.label,
                  style: TextStyle(color: selected ? AppTheme.white : AppTheme.white.withAlpha(150), fontSize: 12, fontWeight: selected ? FontWeight.bold : FontWeight.normal),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

extension on ChartResolution {
  String get label {
    switch (this) {
      case ChartResolution.daily:
        return 'Daily';
      case ChartResolution.weekly:
        return 'Weekly';
      case ChartResolution.monthly:
        return 'Monthly';
    }
  }
}

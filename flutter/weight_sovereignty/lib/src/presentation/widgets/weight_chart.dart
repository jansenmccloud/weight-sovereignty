import 'package:flutter/material.dart';

/// Data point for the weight chart
class WeightDataPoint {
  final DateTime date;
  final double weight;

  const WeightDataPoint({required this.date, required this.weight});
}

/// Intercepts pointer motion within the widget bounds and calls [onHover] with local position.
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

/// Custom paint chart showing daily weight measurements.
class WeightChart extends StatefulWidget {
  final List<WeightDataPoint> dataPoints;
  final double height;

  const WeightChart({
    super.key,
    required this.dataPoints,
    this.height = 200.0,
  });

  @override
  State<WeightChart> createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {
  DateTime? _hoverDate;

  WeightDataPoint? _findNearestPoint(List<WeightDataPoint> points) {
    if (_hoverDate == null || points.isEmpty) return null;
    double closestDist = double.infinity;
    WeightDataPoint? closest;
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
    final sorted = List<WeightDataPoint>.from(widget.dataPoints)
      ..sort((a, b) => a.date.compareTo(b.date));

    if (sorted.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text('No weight data available', style: TextStyle(color: Colors.white54)),
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
              painter: _WeightChartPainter(
                dataPoints: sorted,
                hoveredPoint: _findNearestPoint(sorted),
                accentColor: accent,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  final List<WeightDataPoint> dataPoints;
  final WeightDataPoint? hoveredPoint;
  final Color accentColor;

  _WeightChartPainter({required this.dataPoints, required this.hoveredPoint, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final sorted = dataPoints;
    final firstDate = sorted.first.date;
    final lastDate = sorted.last.date;
    final minWeight = sorted.map((e) => e.weight).reduce((a, b) => a < b ? a : b);
    final maxWeight = sorted.map((e) => e.weight).reduce((a, b) => a > b ? a : b);

    // Avoid zero range
    final weightRange = maxWeight - minWeight == 0 ? 1.0 : maxWeight - minWeight;
    final padding = const EdgeInsets.all(12.0);
    final chartWidth = size.width - padding.left - padding.right;
    final chartHeight = size.height - padding.top - padding.bottom;

    // Coordinate helpers
    double xForIndex(int index) => padding.left + (index / (sorted.length - 1)).clamp(0.0, 1.0) * chartWidth;
    double yForWeight(double weight) {
      final ratio = (weight - minWeight + weightRange * 0.05) / (weightRange * 1.1);
      return padding.top + chartHeight - ratio * chartHeight;
    }

    // Paints
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final areaPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.15),
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.8, 1.0],
      ).createShader(Rect.fromLTWH(0, padding.top, chartWidth, chartHeight));

    final dotPaint = Paint()..color = Colors.white;
    final hoverLinePaint = Paint()
      ..color = accentColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
      //..strokeDash = [4.0, 4.0];

    // Grid lines (Y-axis)
    final gridSteps = 4;
    for (int i = 0; i <= gridSteps; i++) {
      final weight = minWeight + (weightRange * 1.1) * (i / gridSteps) - weightRange * 0.05;
      final y = yForWeight(weight);
      canvas.drawLine(
        Offset(padding.left, y),
        Offset(size.width - padding.right, y),
        gridPaint,
      );

      // Y-axis labels
      final label = weight.toStringAsFixed(1);
      final textPainter = TextPainter(
        text: TextSpan(text: label, style: TextStyle(color: Colors.white54, fontSize: 9)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 5));
    }

    // X-axis labels (dates)
    final dateSteps = sorted.length > 7 ? 6 : sorted.length;
    final step = (sorted.length - 1) / (dateSteps < 2 ? 1 : dateSteps);
    for (int i = 0; i <= dateSteps && i * step < sorted.length; i++) {
      final idx = (i * step).toInt().clamp(0, sorted.length - 1);
      final x = xForIndex(idx);
      final date = sorted[idx].date;

      // Tick mark
      canvas.drawLine(
        Offset(x, padding.top),
        Offset(x, padding.top + 4),
        gridPaint..strokeWidth = 0.5,
      );

      // Label
      final label = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
      final textPainter = TextPainter(
        text: TextSpan(text: label, style: TextStyle(color: Colors.white54, fontSize: 9)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height - padding.bottom + 6));
    }

    // Area fill
    if (sorted.length > 1) {
      final path = Path()
        ..addPolygon(
          List.generate(sorted.length, (i) => Offset(xForIndex(i), yForWeight(sorted[i].weight))),
          false,
        );
      final areaPath = Path();
      areaPath.addRect(Rect.fromLTWH(padding.left, padding.top, chartWidth, chartHeight));
      canvas.drawPath(path, areaPaint);
    }

    // Line
    if (sorted.length > 1) {
      final path = Path()..moveTo(xForIndex(0), yForWeight(sorted[0].weight));
      for (int i = 1; i < sorted.length; i++) {
        path.lineTo(xForIndex(i), yForWeight(sorted[i].weight));
      }
      canvas.drawPath(path, linePaint);
    }

    // Dots
    for (int i = 0; i < sorted.length; i++) {
      final isHovered = hoveredPoint == sorted[i];
      final r = isHovered ? 5.0 : 3.0;
      canvas.drawCircle(
        Offset(xForIndex(i), yForWeight(sorted[i].weight)),
        r,
        dotPaint..color = isHovered ? accentColor : Colors.white.withOpacity(0.8),
      );
    }

    // Hover indicator
    if (hoveredPoint != null) {
      final idx = sorted.indexOf(hoveredPoint!);
      if (idx >= 0) {
        final x = xForIndex(idx);
        final y = yForWeight(hoveredPoint!.weight);

        canvas.drawLine(
          Offset(x, padding.top),
          Offset(x, size.height - padding.bottom),
          hoverLinePaint,
        );

        // Label
        final label = '${hoveredPoint!.weight.toStringAsFixed(1)} kg';
        final textPainter = TextPainter(
          text: TextSpan(
            text: label,
            style: TextStyle(color: accentColor, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final labelOffset = Offset(x - textPainter.width / 2, y - textPainter.height - 8);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            labelOffset & Size(textPainter.width + 8, textPainter.height + 4),
            const Radius.circular(4),
          ),
          Paint()..color = Colors.black87,
        );
        textPainter.paint(canvas, labelOffset + const Offset(4, 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints || oldDelegate.hoveredPoint != hoveredPoint;
  }
}

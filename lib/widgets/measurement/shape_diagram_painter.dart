import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ShapeDiagramPainterWidget extends StatelessWidget {
  final String shapeId;
  final String? activeFieldKey;
  final double height;

  const ShapeDiagramPainterWidget({
    super.key,
    required this.shapeId,
    this.activeFieldKey,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkSurface : AppColors.divider,
          width: 1,
        ),
      ),
      child: CustomPaint(
        painter: ShapeCustomPainter(
          shapeId: shapeId,
          activeFieldKey: activeFieldKey,
          isDark: isDark,
        ),
      ),
    );
  }
}

class ShapeCustomPainter extends CustomPainter {
  final String shapeId;
  final String? activeFieldKey;
  final bool isDark;

  ShapeCustomPainter({
    required this.shapeId,
    this.activeFieldKey,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final baseColor = isDark ? Colors.blueGrey.shade300 : Colors.blueGrey.shade700;
    final fillColor = isDark ? AppColors.primary.withAlpha(40) : AppColors.primary.withAlpha(20);
    final highlightColor = isDark ? const Color(0xFFFFB74D) : const Color(0xFFE65100);
    final highlightStrokeWidth = 3.5;

    final defaultPaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final shapeFillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    switch (shapeId) {
      case 'square':
        final side = math.min(size.width, size.height) * 0.5;
        final rect = Rect.fromCenter(center: center, width: side, height: side);
        canvas.drawRect(rect, shapeFillPaint);
        canvas.drawRect(rect, defaultPaint);

        final isHighlighted = activeFieldKey == 's';
        _drawDimensionLine(
          canvas,
          start: rect.bottomLeft + const Offset(0, 15),
          end: rect.bottomRight + const Offset(0, 15),
          label: 's',
          isHighlighted: isHighlighted,
          baseColor: baseColor,
          highlightColor: highlightColor,
        );
        if (isHighlighted) {
          final highlightPaint = Paint()
            ..color = highlightColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = highlightStrokeWidth;
          canvas.drawRect(rect, highlightPaint);
        }
        break;

      case 'rectangle':
        final w = math.min(size.width * 0.6, 220.0);
        final h = math.min(size.height * 0.45, 120.0);
        final rect = Rect.fromCenter(center: center, width: w, height: h);
        canvas.drawRect(rect, shapeFillPaint);
        canvas.drawRect(rect, defaultPaint);

        _drawDimensionLine(
          canvas,
          start: rect.bottomLeft + const Offset(0, 15),
          end: rect.bottomRight + const Offset(0, 15),
          label: 'Length (l)',
          isHighlighted: activeFieldKey == 'l',
          baseColor: baseColor,
          highlightColor: highlightColor,
        );

        _drawDimensionLine(
          canvas,
          start: rect.topRight + const Offset(15, 0),
          end: rect.bottomRight + const Offset(15, 0),
          label: 'Width (w)',
          isHighlighted: activeFieldKey == 'w',
          baseColor: baseColor,
          highlightColor: highlightColor,
          vertical: true,
        );
        break;

      case 'circle':
        final radius = math.min(size.width, size.height) * 0.35;
        canvas.drawCircle(center, radius, shapeFillPaint);
        canvas.drawCircle(center, radius, defaultPaint);

        _drawDimensionLine(
          canvas,
          start: center,
          end: center + Offset(radius, 0),
          label: 'r',
          isHighlighted: activeFieldKey == 'r',
          baseColor: baseColor,
          highlightColor: highlightColor,
        );
        break;

      case 'semicircle':
        final radius = math.min(size.width, size.height) * 0.35;
        final rect = Rect.fromCircle(center: center + const Offset(0, 20), radius: radius);
        final path = Path()
          ..moveTo(rect.left, rect.center.dy)
          ..arcTo(rect, math.pi, math.pi, false)
          ..close();
        canvas.drawPath(path, shapeFillPaint);
        canvas.drawPath(path, defaultPaint);

        _drawDimensionLine(
          canvas,
          start: rect.center,
          end: rect.center + Offset(radius, 0),
          label: 'r',
          isHighlighted: activeFieldKey == 'r',
          baseColor: baseColor,
          highlightColor: highlightColor,
        );
        break;

      case 'ring':
        final rOuter = math.min(size.width, size.height) * 0.38;
        final rInner = rOuter * 0.55;
        final outerPath = Path()..addOval(Rect.fromCircle(center: center, radius: rOuter));
        final innerPath = Path()..addOval(Rect.fromCircle(center: center, radius: rInner));
        final ringPath = Path.combine(PathOperation.difference, outerPath, innerPath);

        canvas.drawPath(ringPath, shapeFillPaint);
        canvas.drawCircle(center, rOuter, defaultPaint);
        canvas.drawCircle(center, rInner, defaultPaint);

        _drawDimensionLine(
          canvas,
          start: center,
          end: center + Offset(rOuter, 0),
          label: 'R',
          isHighlighted: activeFieldKey == 'R',
          baseColor: baseColor,
          highlightColor: highlightColor,
        );
        _drawDimensionLine(
          canvas,
          start: center,
          end: center + Offset(0, -rInner),
          label: 'r',
          isHighlighted: activeFieldKey == 'r',
          baseColor: baseColor,
          highlightColor: highlightColor,
          vertical: true,
        );
        break;

      case 'trapezoid':
        final topW = size.width * 0.3;
        final botW = size.width * 0.6;
        final h = size.height * 0.45;

        final path = Path()
          ..moveTo(center.dx - topW / 2, center.dy - h / 2)
          ..lineTo(center.dx + topW / 2, center.dy - h / 2)
          ..lineTo(center.dx + botW / 2, center.dy + h / 2)
          ..lineTo(center.dx - botW / 2, center.dy + h / 2)
          ..close();

        canvas.drawPath(path, shapeFillPaint);
        canvas.drawPath(path, defaultPaint);

        _drawDimensionLine(
          canvas,
          start: Offset(center.dx - topW / 2, center.dy - h / 2 - 12),
          end: Offset(center.dx + topW / 2, center.dy - h / 2 - 12),
          label: 'Top Base (a)',
          isHighlighted: activeFieldKey == 'a',
          baseColor: baseColor,
          highlightColor: highlightColor,
        );
        _drawDimensionLine(
          canvas,
          start: Offset(center.dx - botW / 2, center.dy + h / 2 + 15),
          end: Offset(center.dx + botW / 2, center.dy + h / 2 + 15),
          label: 'Bottom Base (b)',
          isHighlighted: activeFieldKey == 'b',
          baseColor: baseColor,
          highlightColor: highlightColor,
        );
        _drawDimensionLine(
          canvas,
          start: Offset(center.dx + botW / 2 + 15, center.dy - h / 2),
          end: Offset(center.dx + botW / 2 + 15, center.dy + h / 2),
          label: 'Height (h)',
          isHighlighted: activeFieldKey == 'h',
          baseColor: baseColor,
          highlightColor: highlightColor,
          vertical: true,
        );
        break;

      case 'cylinder':
      case 'tube':
      case 'cylindrical_tube':
        final r = size.width * 0.22;
        final h = size.height * 0.5;
        final topCenter = center - Offset(0, h / 2);
        final botCenter = center + Offset(0, h / 2);

        final cylinderPath = Path()
          ..moveTo(topCenter.dx - r, topCenter.dy)
          ..lineTo(botCenter.dx - r, botCenter.dy)
          ..arcTo(Rect.fromCenter(center: botCenter, width: r * 2, height: 30), 0, math.pi, true)
          ..lineTo(topCenter.dx + r, topCenter.dy)
          ..arcTo(Rect.fromCenter(center: topCenter, width: r * 2, height: 30), 0, -math.pi, true)
          ..close();

        canvas.drawPath(cylinderPath, shapeFillPaint);
        canvas.drawOval(Rect.fromCenter(center: topCenter, width: r * 2, height: 30), defaultPaint);
        canvas.drawOval(Rect.fromCenter(center: botCenter, width: r * 2, height: 30), defaultPaint);
        canvas.drawLine(topCenter - Offset(r, 0), botCenter - Offset(r, 0), defaultPaint);
        canvas.drawLine(topCenter + Offset(r, 0), botCenter + Offset(r, 0), defaultPaint);

        _drawDimensionLine(
          canvas,
          start: topCenter,
          end: topCenter + Offset(r, 0),
          label: shapeId == 'cylindrical_tube' ? 'D' : 'r',
          isHighlighted: activeFieldKey == 'r' || activeFieldKey == 'R' || activeFieldKey == 'D',
          baseColor: baseColor,
          highlightColor: highlightColor,
        );
        _drawDimensionLine(
          canvas,
          start: topCenter + Offset(r + 15, 0),
          end: botCenter + Offset(r + 15, 0),
          label: 'Height (h/L)',
          isHighlighted: activeFieldKey == 'h' || activeFieldKey == 'L',
          baseColor: baseColor,
          highlightColor: highlightColor,
          vertical: true,
        );
        break;

      default:
        final rect = Rect.fromCenter(center: center, width: size.width * 0.5, height: size.height * 0.5);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)), shapeFillPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)), defaultPaint);

        _drawDimensionLine(
          canvas,
          start: rect.bottomLeft + const Offset(0, 15),
          end: rect.bottomRight + const Offset(0, 15),
          label: 'Primary Dimension',
          isHighlighted: activeFieldKey != null,
          baseColor: baseColor,
          highlightColor: highlightColor,
        );
        break;
    }
  }

  void _drawDimensionLine(
    Canvas canvas, {
    required Offset start,
    required Offset end,
    required String label,
    required bool isHighlighted,
    required Color baseColor,
    required Color highlightColor,
    bool vertical = false,
  }) {
    final color = isHighlighted ? highlightColor : baseColor;
    final strokeWidth = isHighlighted ? 2.5 : 1.2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);

    final tickLen = 5.0;
    if (!vertical) {
      canvas.drawLine(start - Offset(0, tickLen), start + Offset(0, tickLen), paint);
      canvas.drawLine(end - Offset(0, tickLen), end + Offset(0, tickLen), paint);
    } else {
      canvas.drawLine(start - Offset(tickLen, 0), start + Offset(tickLen, 0), paint);
      canvas.drawLine(end - Offset(tickLen, 0), end + Offset(tickLen, 0), paint);
    }

    final textSpan = TextSpan(
      text: label,
      style: TextStyle(
        color: color,
        fontSize: isHighlighted ? 13 : 11,
        fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final midPoint = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
    final textOffset = vertical
        ? midPoint + const Offset(8, -8)
        : midPoint - Offset(textPainter.width / 2, textPainter.height + 4);

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant ShapeCustomPainter oldDelegate) {
    return oldDelegate.shapeId != shapeId ||
        oldDelegate.activeFieldKey != activeFieldKey ||
        oldDelegate.isDark != isDark;
  }
}

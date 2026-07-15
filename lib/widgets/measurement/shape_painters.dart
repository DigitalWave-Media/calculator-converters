import 'package:flutter/material.dart';
import 'dart:math' as math;

class ShapeIcon extends StatelessWidget {
  final String shapeId;
  final Color color;
  final double size;

  const ShapeIcon({
    super.key,
    required this.shapeId,
    required this.color,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E2C) : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: _ShapeGeometryPainter(shapeId: shapeId, color: color, isDiagram: false),
      ),
    );
  }
}

class ShapeDiagram extends StatelessWidget {
  final String shapeId;
  final Color color;

  final double height;

  const ShapeDiagram({
    super.key,
    required this.shapeId,
    required this.color,
    this.height = 140,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E1E2C) : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: CustomPaint(
        size: Size(double.infinity, height),
        painter: _ShapeGeometryPainter(
          shapeId: shapeId, 
          color: color, 
          isDiagram: true,
          textColor: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }
}

class _ShapeGeometryPainter extends CustomPainter {
  final String shapeId;
  final Color color;
  final bool isDiagram;
  final Color textColor;

  _ShapeGeometryPainter({
    required this.shapeId,
    required this.color,
    required this.isDiagram,
    this.textColor = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = isDiagram ? 2.5 : 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final dashPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isDiagram ? 1.5 : 1.0;

    final center = Offset(size.width / 2, size.height / 2);
    final dimension = math.min(size.width, size.height);
    final w = dimension;
    final h = dimension;
    
    // Scale down slightly to fit strokes within bounds
    canvas.save();
    canvas.translate(center.dx, center.dy);
    final scale = isDiagram ? 0.75 : 0.8;
    canvas.scale(scale, scale);
    canvas.translate(-center.dx, -center.dy);

    _drawShape(canvas, size, center, w, h, paint, fillPaint, dashPaint, isDiagram);

    canvas.restore();
  }

  void _drawShape(Canvas canvas, Size size, Offset center, double w, double h, Paint paint, Paint fillPaint, Paint dashPaint, bool isDiagram) {
    // ---------------- AREA SHAPES ----------------
    if (shapeId == 'square') {
      final rect = Rect.fromCenter(center: center, width: w * 0.8, height: w * 0.8);
      canvas.drawRect(rect, fillPaint);
      canvas.drawRect(rect, paint);
      if (isDiagram) _drawLabel(canvas, center.dx, center.dy + w * 0.45, 's');
    } else if (shapeId == 'rectangle') {
      final rect = Rect.fromCenter(center: center, width: w * 0.9, height: w * 0.5);
      canvas.drawRect(rect, fillPaint);
      canvas.drawRect(rect, paint);
      if (isDiagram) {
        _drawLabel(canvas, center.dx, center.dy + w * 0.3, 'l');
        _drawLabel(canvas, center.dx + w * 0.5, center.dy, 'w');
      }
    } else if (shapeId == 'circle') {
      final r = w * 0.45;
      canvas.drawCircle(center, r, fillPaint);
      canvas.drawCircle(center, r, paint);
      canvas.drawLine(center, center + Offset(r, 0), dashPaint);
      if (isDiagram) _drawLabel(canvas, center.dx + r/2, center.dy - 15, 'r');
    } else if (shapeId == 'semicircle') {
      final r = w * 0.45;
      final rect = Rect.fromCenter(center: center, width: r * 2, height: r * 2);
      final path = Path()
        ..moveTo(center.dx - r, center.dy)
        ..arcTo(rect, math.pi, math.pi, false)
        ..lineTo(center.dx - r, center.dy);
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, paint);
      canvas.drawLine(center, center + Offset(r, 0), dashPaint);
      if (isDiagram) _drawLabel(canvas, center.dx + r/2, center.dy - 15, 'r');
    } else if (shapeId == 'ellipse') {
      final rect = Rect.fromCenter(center: center, width: w * 0.9, height: w * 0.6);
      canvas.drawOval(rect, fillPaint);
      canvas.drawOval(rect, paint);
      canvas.drawLine(center, center + Offset(w * 0.45, 0), dashPaint);
      canvas.drawLine(center, center - Offset(0, w * 0.3), dashPaint);
      if (isDiagram) {
        _drawLabel(canvas, center.dx + w * 0.2, center.dy + 15, 'a');
        _drawLabel(canvas, center.dx - 15, center.dy - w * 0.15, 'b');
      }
    } else if (shapeId == 'ring') {
      final rOut = w * 0.45;
      final rIn = w * 0.25;
      final path = Path()
        ..addOval(Rect.fromCenter(center: center, width: rOut*2, height: rOut*2))
        ..addOval(Rect.fromCenter(center: center, width: rIn*2, height: rIn*2));
      path.fillType = PathFillType.evenOdd;
      canvas.drawPath(path, fillPaint);
      canvas.drawCircle(center, rOut, paint);
      canvas.drawCircle(center, rIn, paint);
      canvas.drawLine(center, center - Offset(rIn, 0), dashPaint);
      canvas.drawLine(center, center + Offset(rOut, 0), dashPaint);
      if (isDiagram) {
        _drawLabel(canvas, center.dx - rIn/2, center.dy - 15, 'r');
        _drawLabel(canvas, center.dx + rOut/2, center.dy + 15, 'R');
      }
    } else if (shapeId == 'diamond' || shapeId == 'kite' || shapeId == 'quadrilateral') {
      final p1 = Offset(center.dx, center.dy - w * 0.4);
      final p2 = Offset(center.dx + w * 0.4, center.dy + (shapeId == 'kite' ? w*0.1 : 0));
      final p3 = Offset(center.dx, center.dy + w * 0.4);
      final p4 = Offset(center.dx - w * 0.4, center.dy + (shapeId == 'kite' ? w*0.1 : 0));
      final path = Path()..moveTo(p1.dx, p1.dy)..lineTo(p2.dx, p2.dy)..lineTo(p3.dx, p3.dy)..lineTo(p4.dx, p4.dy)..close();
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, paint);
      canvas.drawLine(p1, p3, dashPaint);
      canvas.drawLine(p2, p4, dashPaint);
      if (isDiagram) {
        _drawLabel(canvas, center.dx + 15, center.dy + w*0.2, 'd₁');
        _drawLabel(canvas, center.dx - w*0.2, center.dy - 15, 'd₂');
      }
    } else if (shapeId == 'sector') {
      final r = w * 0.45;
      final rect = Rect.fromCenter(center: center, width: r * 2, height: r * 2);
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(rect, -math.pi/4, -math.pi/2, false)
        ..close();
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, paint);
      if (isDiagram) {
        _drawLabel(canvas, center.dx + r*0.4, center.dy - r*0.4, 'r');
        _drawLabel(canvas, center.dx, center.dy - r*0.2, 'θ');
      }
    } else if (shapeId == 'trapezoid') {
      final p1 = Offset(center.dx - w * 0.25, center.dy - w * 0.3);
      final p2 = Offset(center.dx + w * 0.25, center.dy - w * 0.3);
      final p3 = Offset(center.dx + w * 0.45, center.dy + w * 0.3);
      final p4 = Offset(center.dx - w * 0.45, center.dy + w * 0.3);
      final path = Path()..moveTo(p1.dx, p1.dy)..lineTo(p2.dx, p2.dy)..lineTo(p3.dx, p3.dy)..lineTo(p4.dx, p4.dy)..close();
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, paint);
      canvas.drawLine(Offset(p1.dx, p1.dy), Offset(p1.dx, p4.dy), dashPaint);
      if (isDiagram) {
        _drawLabel(canvas, center.dx, center.dy - w * 0.35, 'a');
        _drawLabel(canvas, center.dx, center.dy + w * 0.35, 'b');
        _drawLabel(canvas, p1.dx - 15, center.dy, 'h');
      }
    }
    // ---------------- VOLUME SHAPES (ISOMETRIC / 3D) ----------------
    else if (shapeId == 'cube' || shapeId == 'rectangular_prism') {
      final isCube = shapeId == 'cube';
      final sx = isCube ? w * 0.3 : w * 0.4;
      final sy = w * 0.3;
      final depth = w * 0.2;
      
      final f1 = Offset(center.dx - sx, center.dy - sy);
      final f2 = Offset(center.dx + sx, center.dy - sy);
      final f3 = Offset(center.dx + sx, center.dy + sy);
      final f4 = Offset(center.dx - sx, center.dy + sy);
      
      final b1 = f1 + Offset(depth, -depth);
      final b2 = f2 + Offset(depth, -depth);
      final b3 = f3 + Offset(depth, -depth);
      final b4 = f4 + Offset(depth, -depth);

      // Back faces
      canvas.drawPath(Path()..moveTo(b1.dx, b1.dy)..lineTo(b2.dx, b2.dy)..lineTo(b3.dx, b3.dy)..lineTo(b4.dx, b4.dy)..close(), fillPaint);
      canvas.drawLine(b1, b2, paint);
      canvas.drawLine(b2, b3, paint);
      canvas.drawLine(b1, b4, dashPaint);
      canvas.drawLine(b4, b3, dashPaint);

      // Connecting lines
      canvas.drawLine(f1, b1, paint);
      canvas.drawLine(f2, b2, paint);
      canvas.drawLine(f3, b3, paint);
      canvas.drawLine(f4, b4, dashPaint);

      // Front face
      final frontPath = Path()..moveTo(f1.dx, f1.dy)..lineTo(f2.dx, f2.dy)..lineTo(f3.dx, f3.dy)..lineTo(f4.dx, f4.dy)..close();
      canvas.drawPath(frontPath, fillPaint);
      canvas.drawPath(frontPath, paint);

      if (isDiagram) {
        _drawLabel(canvas, center.dx, center.dy + sy + 15, 'l');
        _drawLabel(canvas, center.dx + sx + 15, center.dy, isCube ? 'l' : 'h');
        _drawLabel(canvas, center.dx + sx + depth/2 + 10, center.dy - sy - depth/2, isCube ? 'l' : 'w');
      }
    } else if (shapeId == 'parallelepiped') {
      final sx = w * 0.35;
      final sy = w * 0.25;
      final depth = w * 0.2;
      final skew = w * 0.15;
      
      final f1 = Offset(center.dx - sx + skew, center.dy - sy);
      final f2 = Offset(center.dx + sx + skew, center.dy - sy);
      final f3 = Offset(center.dx + sx - skew, center.dy + sy);
      final f4 = Offset(center.dx - sx - skew, center.dy + sy);
      
      final b1 = f1 + Offset(depth, -depth);
      final b2 = f2 + Offset(depth, -depth);
      final b3 = f3 + Offset(depth, -depth);
      final b4 = f4 + Offset(depth, -depth);

      canvas.drawPath(Path()..moveTo(b1.dx, b1.dy)..lineTo(b2.dx, b2.dy)..lineTo(b3.dx, b3.dy)..lineTo(b4.dx, b4.dy)..close(), fillPaint);
      canvas.drawLine(b1, b2, paint);
      canvas.drawLine(b2, b3, paint);
      canvas.drawLine(b1, b4, dashPaint);
      canvas.drawLine(b4, b3, dashPaint);

      canvas.drawLine(f1, b1, paint);
      canvas.drawLine(f2, b2, paint);
      canvas.drawLine(f3, b3, paint);
      canvas.drawLine(f4, b4, dashPaint);

      final frontPath = Path()..moveTo(f1.dx, f1.dy)..lineTo(f2.dx, f2.dy)..lineTo(f3.dx, f3.dy)..lineTo(f4.dx, f4.dy)..close();
      canvas.drawPath(frontPath, fillPaint);
      canvas.drawPath(frontPath, paint);

      if (isDiagram) {
        _drawLabel(canvas, center.dx, center.dy + sy + 15, 'a');
        _drawLabel(canvas, center.dx + sx + 15, center.dy, 'c');
        _drawLabel(canvas, center.dx + sx + depth/2 + 10, center.dy - sy - depth/2, 'b');
      }
    } else if (shapeId == 'hollow_rectangle') {
      final sx = w * 0.4;
      final sy = w * 0.3;
      final depth = w * 0.2;
      final th = w * 0.08; 
      
      final f1 = Offset(center.dx - sx, center.dy - sy);
      final f2 = Offset(center.dx + sx, center.dy - sy);
      final f3 = Offset(center.dx + sx, center.dy + sy);
      final f4 = Offset(center.dx - sx, center.dy + sy);
      
      final b1 = f1 + Offset(depth, -depth);
      final b2 = f2 + Offset(depth, -depth);
      final b3 = f3 + Offset(depth, -depth);
      final b4 = f4 + Offset(depth, -depth);

      canvas.drawLine(b1, b2, paint);
      canvas.drawLine(b2, b3, paint);
      canvas.drawLine(b1, b4, dashPaint);
      canvas.drawLine(b4, b3, dashPaint);

      canvas.drawLine(f1, b1, paint);
      canvas.drawLine(f2, b2, paint);
      canvas.drawLine(f3, b3, paint);
      canvas.drawLine(f4, b4, dashPaint);

      final frontOuterPath = Path()..moveTo(f1.dx, f1.dy)..lineTo(f2.dx, f2.dy)..lineTo(f3.dx, f3.dy)..lineTo(f4.dx, f4.dy)..close();
      
      final i1 = Offset(f1.dx + th, f1.dy + th);
      final i2 = Offset(f2.dx - th, f2.dy + th);
      final i3 = Offset(f3.dx - th, f3.dy - th);
      final i4 = Offset(f4.dx + th, f4.dy - th);
      final frontInnerPath = Path()..moveTo(i1.dx, i1.dy)..lineTo(i2.dx, i2.dy)..lineTo(i3.dx, i3.dy)..lineTo(i4.dx, i4.dy)..close();
      
      final rimPath = Path.combine(PathOperation.difference, frontOuterPath, frontInnerPath);
      canvas.drawPath(rimPath, fillPaint);
      canvas.drawPath(frontOuterPath, paint);
      canvas.drawPath(frontInnerPath, paint);

      final ib1 = i1 + Offset(depth, -depth);
      final ib2 = i2 + Offset(depth, -depth);
      final ib3 = i3 + Offset(depth, -depth);
      
      canvas.drawLine(i1, ib1, paint);
      canvas.drawLine(i2, ib2, paint);
      canvas.drawLine(i3, ib3, paint);
      canvas.drawLine(ib1, ib2, paint);
      canvas.drawLine(ib2, ib3, paint);

      final innerSidePath = Path()..moveTo(i2.dx, i2.dy)..lineTo(ib2.dx, ib2.dy)..lineTo(ib3.dx, ib3.dy)..lineTo(i3.dx, i3.dy)..close();
      canvas.drawPath(innerSidePath, fillPaint);
      final innerBotPath = Path()..moveTo(i1.dx, i1.dy)..lineTo(ib1.dx, ib1.dy)..lineTo(ib2.dx, ib2.dy)..lineTo(i2.dx, i2.dy)..close();
      canvas.drawPath(innerBotPath, fillPaint);

      if (isDiagram) {
        _drawLabel(canvas, center.dx, center.dy + sy + 15, 'L');
        _drawLabel(canvas, center.dx, center.dy - sy + th/2, 't');
      }
    } else if (shapeId == 'cylinder') {
      final rw = w * 0.35;
      final rh = w * 0.12;
      final height = w * 0.6;
      
      final topCenter = Offset(center.dx, center.dy - height/2);
      final bottomCenter = Offset(center.dx, center.dy + height/2);

      canvas.drawOval(Rect.fromCenter(center: bottomCenter, width: rw*2, height: rh*2), fillPaint);
      final bottomPath = Path()
        ..moveTo(bottomCenter.dx - rw, bottomCenter.dy)
        ..arcTo(Rect.fromCenter(center: bottomCenter, width: rw*2, height: rh*2), math.pi, math.pi, false);
      canvas.drawPath(bottomPath, paint);
      final bottomDashPath = Path()
        ..moveTo(bottomCenter.dx - rw, bottomCenter.dy)
        ..arcTo(Rect.fromCenter(center: bottomCenter, width: rw*2, height: rh*2), 0, math.pi, false);
      canvas.drawPath(bottomDashPath, dashPaint);
      
      canvas.drawRect(Rect.fromLTRB(topCenter.dx - rw, topCenter.dy, bottomCenter.dx + rw, bottomCenter.dy), fillPaint);
      canvas.drawLine(Offset(topCenter.dx - rw, topCenter.dy), Offset(bottomCenter.dx - rw, bottomCenter.dy), paint);
      canvas.drawLine(Offset(topCenter.dx + rw, topCenter.dy), Offset(bottomCenter.dx + rw, bottomCenter.dy), paint);

      canvas.drawOval(Rect.fromCenter(center: topCenter, width: rw*2, height: rh*2), fillPaint);
      canvas.drawOval(Rect.fromCenter(center: topCenter, width: rw*2, height: rh*2), paint);

      if (isDiagram) {
        _drawLabel(canvas, topCenter.dx + rw/2, topCenter.dy - 10, 'r');
        _drawLabel(canvas, topCenter.dx + rw + 15, center.dy, 'h');
        canvas.drawLine(topCenter, topCenter + Offset(rw, 0), dashPaint);
      }
    } else if (shapeId == 'tube' || shapeId == 'cylindrical_tube') {
      final rwOuter = w * 0.35;
      final rhOuter = w * 0.12;
      final rwInner = w * 0.25;
      final rhInner = w * 0.08;
      final height = w * 0.6;
      
      final topCenter = Offset(center.dx, center.dy - height/2);
      final bottomCenter = Offset(center.dx, center.dy + height/2);

      final bottomPath = Path()
        ..moveTo(bottomCenter.dx - rwOuter, bottomCenter.dy)
        ..arcTo(Rect.fromCenter(center: bottomCenter, width: rwOuter*2, height: rhOuter*2), math.pi, math.pi, false);
      canvas.drawPath(bottomPath, paint);
      final bottomDashPath = Path()
        ..moveTo(bottomCenter.dx - rwOuter, bottomCenter.dy)
        ..arcTo(Rect.fromCenter(center: bottomCenter, width: rwOuter*2, height: rhOuter*2), 0, math.pi, false);
      canvas.drawPath(bottomDashPath, dashPaint);
      
      canvas.drawLine(Offset(topCenter.dx - rwOuter, topCenter.dy), Offset(bottomCenter.dx - rwOuter, bottomCenter.dy), paint);
      canvas.drawLine(Offset(topCenter.dx + rwOuter, topCenter.dy), Offset(bottomCenter.dx + rwOuter, bottomCenter.dy), paint);

      final topOuterRect = Rect.fromCenter(center: topCenter, width: rwOuter*2, height: rhOuter*2);
      final topInnerRect = Rect.fromCenter(center: topCenter, width: rwInner*2, height: rhInner*2);
      
      final rimPath = Path()
        ..addOval(topOuterRect)
        ..addOval(topInnerRect)
        ..fillType = PathFillType.evenOdd;
      canvas.drawPath(rimPath, fillPaint);
      
      canvas.drawOval(topOuterRect, paint);
      canvas.drawOval(topInnerRect, paint);

      final innerBottomPath = Path()
        ..moveTo(bottomCenter.dx - rwInner, bottomCenter.dy)
        ..arcTo(Rect.fromCenter(center: bottomCenter, width: rwInner*2, height: rhInner*2), math.pi, math.pi, false);
      
      canvas.drawLine(Offset(topCenter.dx - rwInner, topCenter.dy), Offset(bottomCenter.dx - rwInner, bottomCenter.dy), dashPaint);
      canvas.drawLine(Offset(topCenter.dx + rwInner, topCenter.dy), Offset(bottomCenter.dx + rwInner, bottomCenter.dy), dashPaint);
      canvas.drawPath(innerBottomPath, dashPaint);
      
      canvas.drawRect(Rect.fromLTRB(topCenter.dx - rwInner, topCenter.dy, bottomCenter.dx + rwInner, bottomCenter.dy), fillPaint);

      if (isDiagram) {
        _drawLabel(canvas, topCenter.dx + rwOuter + 15, center.dy, 'h');
        _drawLabel(canvas, topCenter.dx - rwOuter/2, topCenter.dy - 10, 'R');
        _drawLabel(canvas, topCenter.dx + rwInner/2, topCenter.dy + 15, 'r');
        canvas.drawLine(topCenter, topCenter - Offset(rwOuter, 0), dashPaint);
        canvas.drawLine(topCenter, topCenter + Offset(rwInner, 0), dashPaint);
      }
    } else if (shapeId == 'cone') {
      final rw = w * 0.35;
      final rh = w * 0.12;
      final height = w * 0.6;
      final bottomCenter = Offset(center.dx, center.dy + height/2);
      final topCenter = Offset(center.dx, center.dy - height/2);

      canvas.drawOval(Rect.fromCenter(center: bottomCenter, width: rw*2, height: rh*2), fillPaint);
      final bottomPath = Path()
        ..moveTo(bottomCenter.dx - rw, bottomCenter.dy)
        ..arcTo(Rect.fromCenter(center: bottomCenter, width: rw*2, height: rh*2), math.pi, math.pi, false);
      canvas.drawPath(bottomPath, paint);
      final bottomDashPath = Path()
        ..moveTo(bottomCenter.dx - rw, bottomCenter.dy)
        ..arcTo(Rect.fromCenter(center: bottomCenter, width: rw*2, height: rh*2), 0, math.pi, false);
      canvas.drawPath(bottomDashPath, dashPaint);

      final bodyPath = Path()
        ..moveTo(topCenter.dx, topCenter.dy)
        ..lineTo(bottomCenter.dx - rw, bottomCenter.dy)
        ..lineTo(bottomCenter.dx + rw, bottomCenter.dy)..close();
      canvas.drawPath(bodyPath, fillPaint);
      canvas.drawLine(topCenter, Offset(bottomCenter.dx - rw, bottomCenter.dy), paint);
      canvas.drawLine(topCenter, Offset(bottomCenter.dx + rw, bottomCenter.dy), paint);
      
      if (isDiagram) {
        _drawLabel(canvas, bottomCenter.dx + rw/2, bottomCenter.dy - 10, 'r');
        canvas.drawLine(bottomCenter, bottomCenter + Offset(rw, 0), dashPaint);
        canvas.drawLine(topCenter, bottomCenter, dashPaint);
        _drawLabel(canvas, center.dx - 15, center.dy, 'h');
      }
    } else if (shapeId == 'frustum') {
      final rw = w * 0.35;
      final rh = w * 0.12;
      final height = w * 0.6;
      final bottomCenter = Offset(center.dx, center.dy + height/2);
      final topCenter = Offset(center.dx, center.dy - height/2);

      canvas.drawOval(Rect.fromCenter(center: bottomCenter, width: rw*2, height: rh*2), fillPaint);
      final bottomPath = Path()
        ..moveTo(bottomCenter.dx - rw, bottomCenter.dy)
        ..arcTo(Rect.fromCenter(center: bottomCenter, width: rw*2, height: rh*2), math.pi, math.pi, false);
      canvas.drawPath(bottomPath, paint);
      final bottomDashPath = Path()
        ..moveTo(bottomCenter.dx - rw, bottomCenter.dy)
        ..arcTo(Rect.fromCenter(center: bottomCenter, width: rw*2, height: rh*2), 0, math.pi, false);
      canvas.drawPath(bottomDashPath, dashPaint);

      final trw = w * 0.2;
      final trh = w * 0.07;
      
      final bodyPath = Path()
        ..moveTo(topCenter.dx - trw, topCenter.dy)
        ..lineTo(bottomCenter.dx - rw, bottomCenter.dy)
        ..lineTo(bottomCenter.dx + rw, bottomCenter.dy)
        ..lineTo(topCenter.dx + trw, topCenter.dy)..close();
      canvas.drawPath(bodyPath, fillPaint);
      
      canvas.drawLine(Offset(topCenter.dx - trw, topCenter.dy), Offset(bottomCenter.dx - rw, bottomCenter.dy), paint);
      canvas.drawLine(Offset(topCenter.dx + trw, topCenter.dy), Offset(bottomCenter.dx + rw, bottomCenter.dy), paint);

      canvas.drawOval(Rect.fromCenter(center: topCenter, width: trw*2, height: trh*2), fillPaint);
      canvas.drawOval(Rect.fromCenter(center: topCenter, width: trw*2, height: trh*2), paint);
      
      if (isDiagram) {
        _drawLabel(canvas, bottomCenter.dx + rw/2, bottomCenter.dy - 10, 'R');
        _drawLabel(canvas, topCenter.dx + trw/2, topCenter.dy - 10, 'r');
        canvas.drawLine(bottomCenter, bottomCenter + Offset(rw, 0), dashPaint);
        canvas.drawLine(topCenter, topCenter + Offset(trw, 0), dashPaint);
        canvas.drawLine(topCenter, bottomCenter, dashPaint);
        _drawLabel(canvas, center.dx - 15, center.dy, 'h');
      }
    } else if (['sphere', 'hemisphere', 'ellipsoid'].contains(shapeId)) {
      final isHemi = shapeId == 'hemisphere';
      final isEllip = shapeId == 'ellipsoid';
      final r = w * 0.4;
      final reX = isEllip ? w * 0.45 : r;
      final reY = isEllip ? w * 0.3 : r;

      if (isHemi) {
        final rect = Rect.fromCenter(center: center, width: r * 2, height: r * 2);
        final path = Path()
          ..moveTo(center.dx - r, center.dy)
          ..arcTo(rect, math.pi, math.pi, false);
        canvas.drawPath(path, fillPaint);
        canvas.drawPath(path, paint);
        canvas.drawOval(Rect.fromCenter(center: center, width: r*2, height: r*0.5), fillPaint);
        canvas.drawOval(Rect.fromCenter(center: center, width: r*2, height: r*0.5), paint);
        if (isDiagram) {
          canvas.drawLine(center, center + Offset(r, 0), dashPaint);
          _drawLabel(canvas, center.dx + r/2, center.dy - 15, 'r');
        }
      } else {
        canvas.drawOval(Rect.fromCenter(center: center, width: reX*2, height: reY*2), fillPaint);
        canvas.drawOval(Rect.fromCenter(center: center, width: reX*2, height: reY*2), paint);
        final eqPath = Path()
          ..moveTo(center.dx - reX, center.dy)
          ..arcTo(Rect.fromCenter(center: center, width: reX*2, height: reY*0.4), math.pi, math.pi, false);
        canvas.drawPath(eqPath, paint);
        final eqDashPath = Path()
          ..moveTo(center.dx - reX, center.dy)
          ..arcTo(Rect.fromCenter(center: center, width: reX*2, height: reY*0.4), 0, math.pi, false);
        canvas.drawPath(eqDashPath, dashPaint);
        
        if (isDiagram) {
          canvas.drawLine(center, center + Offset(reX, 0), dashPaint);
          _drawLabel(canvas, center.dx + reX/2, center.dy - 15, isEllip ? 'a' : 'r');
          if (isEllip) {
            canvas.drawLine(center, center - Offset(0, reY), dashPaint);
            _drawLabel(canvas, center.dx - 15, center.dy - reY/2, 'c');
          }
        }
      }
    } else if (shapeId == 'pyramid') {
      final sx = w * 0.3;
      final sy = w * 0.15;
      final h = w * 0.4;
      final apex = Offset(center.dx, center.dy - h);
      final bl = Offset(center.dx - sx, center.dy + sy);
      final br = Offset(center.dx + sx, center.dy + sy);
      final tl = Offset(center.dx - sx * 0.5, center.dy - sy*0.5);
      final tr = Offset(center.dx + sx * 1.5, center.dy - sy*0.5);

      canvas.drawLine(tl, tr, dashPaint);
      canvas.drawLine(tl, bl, dashPaint);
      canvas.drawLine(apex, tl, dashPaint);
      
      final baseCenter = Offset(center.dx + sx*0.25, center.dy + sy*0.25);

      final frontFaces = Path()..moveTo(apex.dx, apex.dy)..lineTo(bl.dx, bl.dy)..lineTo(br.dx, br.dy)..close();
      canvas.drawPath(frontFaces, fillPaint);
      canvas.drawPath(frontFaces, paint);
      
      final sideFaces = Path()..moveTo(apex.dx, apex.dy)..lineTo(br.dx, br.dy)..lineTo(tr.dx, tr.dy)..close();
      canvas.drawPath(sideFaces, fillPaint);
      canvas.drawLine(br, tr, paint);
      canvas.drawLine(apex, tr, paint);
      canvas.drawLine(bl, br, paint);

      if (isDiagram) {
        _drawLabel(canvas, center.dx, center.dy + sy + 15, 'l');
        _drawLabel(canvas, center.dx + sx + 15, center.dy + sy*0.5, 'w');
        canvas.drawLine(apex, baseCenter, dashPaint);
        _drawLabel(canvas, center.dx + 5, center.dy - h/2, 'h');
      }
    } else if (shapeId == 'triangular_prism') {
      final sx = w * 0.3;
      final sy = w * 0.2;
      final depth = w * 0.2;
      
      final fTop = Offset(center.dx, center.dy - sy);
      final fLeft = Offset(center.dx - sx, center.dy + sy);
      final fRight = Offset(center.dx + sx, center.dy + sy);
      
      final bTop = fTop + Offset(depth, -depth);
      final bLeft = fLeft + Offset(depth, -depth);
      final bRight = fRight + Offset(depth, -depth);

      canvas.drawLine(bLeft, bRight, dashPaint);
      canvas.drawLine(bTop, bLeft, dashPaint);
      
      canvas.drawLine(fLeft, bLeft, dashPaint);
      canvas.drawLine(fRight, bRight, paint);
      canvas.drawLine(fTop, bTop, paint);
      canvas.drawLine(bTop, bRight, paint);
      
      final front = Path()..moveTo(fTop.dx, fTop.dy)..lineTo(fLeft.dx, fLeft.dy)..lineTo(fRight.dx, fRight.dy)..close();
      canvas.drawPath(front, fillPaint);
      canvas.drawPath(front, paint);

      if (isDiagram) {
        _drawLabel(canvas, center.dx, center.dy + sy + 15, 'b');
        _drawLabel(canvas, center.dx + sx + depth/2 + 10, center.dy + sy - depth/2, 'l');
        canvas.drawLine(fTop, Offset(center.dx, center.dy + sy), dashPaint);
        _drawLabel(canvas, center.dx + 15, center.dy, 'h');
      }
    } else if (shapeId == 'trapezoid_prism') {
      final w1 = w * 0.2;
      final w2 = w * 0.3;
      final h = w * 0.25;
      final depth = w * 0.15;
      
      final fTopL = Offset(center.dx - w1, center.dy - h);
      final fTopR = Offset(center.dx + w1, center.dy - h);
      final fBotL = Offset(center.dx - w2, center.dy + h);
      final fBotR = Offset(center.dx + w2, center.dy + h);
      
      final bTopL = fTopL + Offset(depth, -depth);
      final bTopR = fTopR + Offset(depth, -depth);
      final bBotL = fBotL + Offset(depth, -depth);
      final bBotR = fBotR + Offset(depth, -depth);

      canvas.drawPath(Path()..moveTo(bTopL.dx, bTopL.dy)..lineTo(bTopR.dx, bTopR.dy)..lineTo(bBotR.dx, bBotR.dy), paint);
      canvas.drawLine(bTopL, bBotL, dashPaint);
      canvas.drawLine(bBotL, bBotR, dashPaint);
      
      canvas.drawLine(fTopL, bTopL, paint);
      canvas.drawLine(fTopR, bTopR, paint);
      canvas.drawLine(fBotR, bBotR, paint);
      canvas.drawLine(fBotL, bBotL, dashPaint);
      
      final front = Path()..moveTo(fTopL.dx, fTopL.dy)..lineTo(fTopR.dx, fTopR.dy)..lineTo(fBotR.dx, fBotR.dy)..lineTo(fBotL.dx, fBotL.dy)..close();
      canvas.drawPath(front, fillPaint);
      canvas.drawPath(front, paint);

      if (isDiagram) {
        _drawLabel(canvas, center.dx, fBotL.dy + 15, 'b');
        _drawLabel(canvas, center.dx, fTopL.dy - 15, 'a');
        _drawLabel(canvas, fTopR.dx + depth + 15, center.dy, 'l');
        _drawLabel(canvas, center.dx - w2 - 15, center.dy, 'h');
      }
    } else if (shapeId == 'dumper') {
      final w1 = w * 0.35;
      final w2 = w * 0.2;
      final h = w * 0.25;
      final depth = w * 0.15;
      
      final fTopL = Offset(center.dx - w1, center.dy - h);
      final fTopR = Offset(center.dx + w1, center.dy - h);
      final fBotL = Offset(center.dx - w2, center.dy + h);
      final fBotR = Offset(center.dx + w2, center.dy + h);
      
      final bTopL = fTopL + Offset(depth, -depth);
      final bTopR = fTopR + Offset(depth, -depth);
      final bBotL = fBotL + Offset(depth, -depth);
      final bBotR = fBotR + Offset(depth, -depth);

      canvas.drawLine(bTopL, bBotL, dashPaint);
      canvas.drawLine(bBotL, bBotR, dashPaint);
      canvas.drawLine(bTopL, bTopR, paint);
      canvas.drawLine(bTopR, bBotR, paint);
      
      canvas.drawLine(fTopL, bTopL, paint);
      canvas.drawLine(fTopR, bTopR, paint);
      canvas.drawLine(fBotR, bBotR, paint);
      canvas.drawLine(fBotL, bBotL, dashPaint);
      
      final front = Path()..moveTo(fTopL.dx, fTopL.dy)..lineTo(fTopR.dx, fTopR.dy)..lineTo(fBotR.dx, fBotR.dy)..lineTo(fBotL.dx, fBotL.dy)..close();
      canvas.drawPath(front, fillPaint);
      canvas.drawPath(front, paint);

      if (isDiagram) {
        _drawLabel(canvas, center.dx, fTopL.dy - 15, 'l₁');
        _drawLabel(canvas, center.dx, fBotL.dy + 15, 'l₂');
        _drawLabel(canvas, fTopR.dx + depth + 15, center.dy, 'w');
      }
    } else if (shapeId == 'prism' || shapeId == 'hexagonal_prism') {
      final isHex = shapeId == 'hexagonal_prism';
      final r = w * 0.25;
      final h = w * 0.5;
      final sides = isHex ? 6 : 5;
      
      final List<Offset> fPoints = [];
      final List<Offset> bPoints = [];
      for (int i = 0; i < sides; i++) {
        final angle = -math.pi/2 + (2 * math.pi * i / sides);
        fPoints.add(Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle) + h/2));
        bPoints.add(Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle) - h/2));
      }
      
      for (int i = 0; i < sides; i++) {
        final next = (i + 1) % sides;
        if (bPoints[i].dy < center.dy - h/2 + r*0.5) {
          canvas.drawLine(bPoints[i], bPoints[next], paint);
        } else {
          canvas.drawLine(bPoints[i], bPoints[next], dashPaint);
        }
      }
      
      for (int i = 0; i < sides; i++) {
        if (fPoints[i].dx <= center.dx + r*0.8 && fPoints[i].dx >= center.dx - r*0.8 && fPoints[i].dy < center.dy + h/2) {
          canvas.drawLine(fPoints[i], bPoints[i], dashPaint);
        } else {
          canvas.drawLine(fPoints[i], bPoints[i], paint);
        }
      }
      
      final fPath = Path()..moveTo(fPoints[0].dx, fPoints[0].dy);
      for (int i = 1; i < sides; i++) {
        fPath.lineTo(fPoints[i].dx, fPoints[i].dy);
      }
      fPath.close();
      canvas.drawPath(fPath, fillPaint);
      canvas.drawPath(fPath, paint);

      if (isDiagram) {
        _drawLabel(canvas, fPoints[0].dx, fPoints[0].dy + 15, isHex ? 'a' : 'A');
        _drawLabel(canvas, center.dx + r + 15, center.dy, 'h');
      }
    } else if (shapeId == 'barrel') {
      final wB = w * 0.3;
      final height = w * 0.6;
      final d = w * 0.2;
      
      final top = Offset(center.dx, center.dy - height/2);
      final bottom = Offset(center.dx, center.dy + height/2);
      
      canvas.drawOval(Rect.fromCenter(center: bottom, width: d*2, height: d*0.6), fillPaint);
      final bottomPath = Path()
        ..moveTo(bottom.dx - d, bottom.dy)
        ..arcTo(Rect.fromCenter(center: bottom, width: d*2, height: d*0.6), math.pi, math.pi, false);
      canvas.drawPath(bottomPath, paint);
      final bottomDashPath = Path()
        ..moveTo(bottom.dx - d, bottom.dy)
        ..arcTo(Rect.fromCenter(center: bottom, width: d*2, height: d*0.6), 0, math.pi, false);
      canvas.drawPath(bottomDashPath, dashPaint);
      
      final bodyPath = Path()
        ..moveTo(top.dx - d, top.dy)
        ..quadraticBezierTo(center.dx - wB, center.dy, bottom.dx - d, bottom.dy)
        ..lineTo(bottom.dx + d, bottom.dy)
        ..quadraticBezierTo(center.dx + wB, center.dy, top.dx + d, top.dy)
        ..close();
      canvas.drawPath(bodyPath, fillPaint);
      
      canvas.drawPath(Path()..moveTo(top.dx - d, top.dy)..quadraticBezierTo(center.dx - wB, center.dy, bottom.dx - d, bottom.dy), paint);
      canvas.drawPath(Path()..moveTo(top.dx + d, top.dy)..quadraticBezierTo(center.dx + wB, center.dy, bottom.dx + d, bottom.dy), paint);
      
      canvas.drawOval(Rect.fromCenter(center: top, width: d*2, height: d*0.6), fillPaint);
      canvas.drawOval(Rect.fromCenter(center: top, width: d*2, height: d*0.6), paint);

      if (isDiagram) {
        _drawLabel(canvas, center.dx, top.dy - 15, 'd');
        _drawLabel(canvas, center.dx, center.dy, 'D');
        _drawLabel(canvas, center.dx + wB + 15, center.dy, 'h');
      }
    } else if (shapeId == 'l_shape') {
      final t = w * 0.15; 
      final l1 = w * 0.4; 
      final l2 = w * 0.4; 
      final depth = w * 0.15;
      
      final f1 = Offset(center.dx - l2/2, center.dy - l1/2);
      final f2 = f1 + Offset(t, 0);
      final f3 = f2 + Offset(0, l1 - t);
      final f4 = f3 + Offset(l2 - t, 0);
      final f5 = f4 + Offset(0, t);
      final f6 = f1 + Offset(0, l1);
      
      final offset = Offset(depth, -depth);
      final b1 = f1 + offset;
      final b2 = f2 + offset;
      final b3 = f3 + offset;
      final b4 = f4 + offset;
      final b5 = f5 + offset;
      final b6 = f6 + offset;
      
      canvas.drawLine(b1, b6, dashPaint);
      canvas.drawLine(b6, b5, dashPaint);
      canvas.drawLine(b1, b2, paint);
      canvas.drawLine(b2, b3, paint);
      canvas.drawLine(b3, b4, paint);
      canvas.drawLine(b4, b5, paint);
      
      canvas.drawLine(f1, b1, paint);
      canvas.drawLine(f2, b2, paint);
      canvas.drawLine(f3, b3, dashPaint);
      canvas.drawLine(f4, b4, paint);
      canvas.drawLine(f5, b5, paint);
      canvas.drawLine(f6, b6, dashPaint);
      
      final front = Path()..moveTo(f1.dx, f1.dy)..lineTo(f2.dx, f2.dy)..lineTo(f3.dx, f3.dy)..lineTo(f4.dx, f4.dy)..lineTo(f5.dx, f5.dy)..lineTo(f6.dx, f6.dy)..close();
      canvas.drawPath(front, fillPaint);
      canvas.drawPath(front, paint);

      if (isDiagram) {
        _drawLabel(canvas, f1.dx - 15, center.dy, 'L₁');
        _drawLabel(canvas, center.dx, f5.dy + 15, 'L₂');
      }
    } else if (shapeId == 'pipe_culvert') {
      final rO = w * 0.2;
      final rI = w * 0.15;
      final length = w * 0.4;
      
      for (int i = -1; i <= 1; i += 2) {
        final cx = center.dx + i * rO * 1.1;
        final cTop = Offset(cx, center.dy - length/2);
        final cBot = Offset(cx, center.dy + length/2);
        
        canvas.drawRect(Rect.fromLTRB(cTop.dx - rO, cTop.dy, cBot.dx + rO, cBot.dy), fillPaint);
        canvas.drawLine(Offset(cTop.dx - rO, cTop.dy), Offset(cBot.dx - rO, cBot.dy), paint);
        canvas.drawLine(Offset(cTop.dx + rO, cTop.dy), Offset(cBot.dx + rO, cBot.dy), paint);
        
        final botPath = Path()
          ..moveTo(cBot.dx - rO, cBot.dy)
          ..arcTo(Rect.fromCenter(center: cBot, width: rO*2, height: rO*0.5), math.pi, math.pi, false);
        canvas.drawPath(botPath, paint);
        
        canvas.drawOval(Rect.fromCenter(center: cTop, width: rO*2, height: rO*0.5), fillPaint);
        canvas.drawOval(Rect.fromCenter(center: cTop, width: rO*2, height: rO*0.5), paint);
        canvas.drawOval(Rect.fromCenter(center: cTop, width: rI*2, height: rI*0.5), paint);
      }
      
      if (isDiagram) {
        _drawLabel(canvas, center.dx, center.dy - length/2 - 20, 'N pipes');
        _drawLabel(canvas, center.dx + rO*1.1 + rO + 15, center.dy, 'L');
      }
    } else {
      // Fallback
      canvas.drawCircle(center, w * 0.4, paint);
      canvas.drawCircle(center, w * 0.4, fillPaint);
    }
  }

  void _drawLabel(Canvas canvas, double x, double y, String text) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace',
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _ShapeGeometryPainter oldDelegate) {
    return shapeId != oldDelegate.shapeId || color != oldDelegate.color || textColor != oldDelegate.textColor;
  }
}

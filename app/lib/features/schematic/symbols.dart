import 'dart:math';

import 'package:flutter/material.dart';

import '../components/models/component.dart';

/// Hand-drawn schematic symbols, centered on the origin in grid units.
/// Bright monochrome CAD style per screen.png; selection/glow handled by caller.
void paintSymbol(
  Canvas canvas,
  Component c, {
  required double unit,
  required Color ink,
  required Color accent,
  bool on = false,
  bool closed = false,
}) {
  final stroke = Paint()
    ..color = ink
    ..style = PaintingStyle.stroke
    ..strokeWidth = max(1.5, unit * 0.07)
    ..strokeCap = StrokeCap.round;
  final u = unit;
  Offset p(double x, double y) => Offset(x * u, y * u);

  void line(Offset a, Offset b) => canvas.drawLine(a, b, stroke);
  void leads() {
    line(p(-1, 0), p(-0.6, 0));
    line(p(0.6, 0), p(1, 0));
  }

  switch (c.type) {
    case ComponentType.resistor:
      leads();
      final path = Path()..moveTo(-0.6 * u, 0);
      for (var i = 0; i < 6; i++) {
        path.lineTo((-0.6 + 0.2 * (i + 0.5)) * u, (i.isEven ? -0.3 : 0.3) * u);
      }
      path.lineTo(0.6 * u, 0);
      canvas.drawPath(path, stroke);
    case ComponentType.capacitor:
      line(p(-1, 0), p(-0.12, 0));
      line(p(0.12, 0), p(1, 0));
      line(p(-0.12, -0.4), p(-0.12, 0.4));
      line(p(0.12, -0.4), p(0.12, 0.4));
    case ComponentType.inductor:
      line(p(-1, 0), p(-0.6, 0));
      line(p(0.6, 0), p(1, 0));
      for (var i = 0; i < 3; i++) {
        canvas.drawArc(
          Rect.fromCircle(center: p(-0.4 + 0.4 * i, 0), radius: 0.2 * u),
          pi,
          pi,
          false,
          stroke,
        );
      }
    case ComponentType.diode:
      _diodeBody(canvas, stroke, u);
    case ComponentType.led:
      _diodeBody(canvas, stroke, u);
      if (on) {
        canvas.drawCircle(
          Offset.zero,
          0.75 * u,
          Paint()..color = accent.withValues(alpha: 0.25),
        );
        final rayPaint = Paint()
          ..color = accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke.strokeWidth
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(p(0.35, -0.55), p(0.6, -0.8), rayPaint);
        canvas.drawLine(p(0.55, -0.35), p(0.8, -0.6), rayPaint);
      }
    case ComponentType.pushButton:
    case ComponentType.switch_:
      line(p(-1, 0), p(-0.25, 0));
      line(p(0.25, 0), p(1, 0));
      canvas.drawCircle(p(-0.25, 0), 0.06 * u, Paint()..color = ink);
      canvas.drawCircle(p(0.25, 0), 0.06 * u, Paint()..color = ink);
      if (closed || c.properties['closed'] == 1) {
        line(p(-0.25, 0), p(0.25, 0));
      } else {
        line(p(-0.25, 0), p(0.2, -0.35));
      }
    case ComponentType.potentiometer:
      line(p(-1, 0), p(1, 0));
      final path = Path()..moveTo(-0.8 * u, 0);
      for (var i = 0; i < 4; i++) {
        path.lineTo((-0.8 + 0.4 * (i + 0.5)) * u, (i.isEven ? -0.25 : 0.25) * u);
      }
      path.lineTo(0.8 * u, 0);
      canvas.drawPath(path, stroke);
      line(p(0, 0.6), p(0, 0));
      canvas.drawCircle(p(0, 0), 0.07 * u, Paint()..color = ink);
    case ComponentType.vcc:
      line(p(0, 0.5), p(0, -0.3));
      final head = Path()
        ..moveTo(0, -0.55 * u)
        ..lineTo(-0.18 * u, -0.25 * u)
        ..lineTo(0.18 * u, -0.25 * u)
        ..close();
      canvas.drawPath(head, Paint()..color = ink);
    case ComponentType.gnd:
      line(p(0, -0.4), p(0, 0.1));
      line(p(-0.35, 0.1), p(0.35, 0.1));
      line(p(-0.22, 0.28), p(0.22, 0.28));
      line(p(-0.1, 0.44), p(0.1, 0.44));
    case ComponentType.dcSource:
      line(p(-1, 0), p(-0.6, 0));
      line(p(0.6, 0), p(1, 0));
      canvas.drawCircle(Offset.zero, 0.6 * u, stroke);
      line(p(-0.3, -0.15), p(-0.05, -0.15));
      line(p(-0.3, 0.15), p(-0.05, 0.15));
      line(p(-0.175, 0.02), p(-0.175, 0.28));
    case ComponentType.atmega32:
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: 2.6 * u, height: 1.8 * u), stroke);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: 2.2 * u, height: 1.4 * u), stroke);
      canvas.drawCircle(p(-1.3, 0), 0.09 * u, Paint()..color = ink);
    case ComponentType.relay:
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: 1.6 * u, height: 1.2 * u), stroke);
      line(p(-1, -0.3), p(-0.8, -0.3));
      line(p(-1, 0.3), p(-0.8, 0.3));
      line(p(0.8, -0.3), p(1, -0.3));
      line(p(0.8, 0.3), p(1, 0.3));
      line(p(-0.5, -0.3), p(0.5, -0.3));
    case ComponentType.transformer:
      for (final cx in [-0.35, 0.35]) {
        for (var i = 0; i < 3; i++) {
          canvas.drawArc(
            Rect.fromCircle(center: p(cx, -0.4 + 0.4 * i), radius: 0.2 * u),
            pi / 2,
            pi,
            false,
            stroke,
          );
        }
      }
      line(p(-1, -0.4), p(-0.35, -0.4));
      line(p(-1, 0.4), p(-0.35, 0.4));
      line(p(0.35, -0.4), p(1, -0.4));
      line(p(0.35, 0.4), p(1, 0.4));
  }
}

void _diodeBody(Canvas canvas, Paint stroke, double u) {
  Offset p(double x, double y) => Offset(x * u, y * u);
  void line(Offset a, Offset b) => canvas.drawLine(a, b, stroke);
  line(p(-1, 0), p(-0.4, 0));
  line(p(0.4, 0), p(1, 0));
  final tri = Path()
    ..moveTo(-0.4 * u, -0.35 * u)
    ..lineTo(-0.4 * u, 0.35 * u)
    ..lineTo(0.1 * u, 0)
    ..close();
  canvas.drawPath(tri, stroke);
  line(p(0.1, -0.35), p(0.1, 0.35));
}

/// Small component tag (id) under the symbol.
void paintTag(Canvas canvas, String text, Offset at, double unit, Color color) {
  final tp = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(color: color, fontSize: unit * 0.45),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  tp.paint(canvas, at + Offset(-tp.width / 2, unit * 0.9));
}

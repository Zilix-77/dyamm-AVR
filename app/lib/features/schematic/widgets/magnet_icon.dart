import 'package:flutter/material.dart';

/// U-shaped magnet icon (Material has no magnet glyph).
/// Drawn in a 24×24 box like an [Icon]; honors [color] and [size].
class MagnetIcon extends StatelessWidget {
  final double size;
  final Color color;
  const MagnetIcon({super.key, this.size = 24, required this.color});

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _MagnetPainter(color),
      );
}

class _MagnetPainter extends CustomPainter {
  final Color color;
  _MagnetPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final body = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * s
      ..strokeCap = StrokeCap.butt;
    // U body: two legs joined by a top arc.
    final path = Path()
      ..moveTo(6 * s, 20 * s)
      ..lineTo(6 * s, 11 * s)
      ..arcToPoint(Offset(18 * s, 11 * s), radius: Radius.circular(6 * s))
      ..lineTo(18 * s, 20 * s);
    canvas.drawPath(path, body);
    // Pole tips.
    final tips = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * s;
    canvas.drawLine(Offset(6 * s, 17 * s), Offset(6 * s, 20 * s), tips);
    canvas.drawLine(Offset(18 * s, 17 * s), Offset(18 * s, 20 * s), tips);
  }

  @override
  bool shouldRepaint(covariant _MagnetPainter old) => old.color != color;
}

import 'package:flutter/material.dart';

import '../../components/models/component.dart';
import '../symbols.dart';

/// Miniature library tile symbol — reuses the canvas [paintSymbol] painter
/// so the strip preview and the placed component always match.
class TileSymbol extends StatelessWidget {
  final ComponentType type;
  final Color ink;
  final double size;
  const TileSymbol(
      {super.key, required this.type, required this.ink, this.size = 40});

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _TileSymbolPainter(type: type, ink: ink),
      );
}

class _TileSymbolPainter extends CustomPainter {
  final ComponentType type;
  final Color ink;
  const _TileSymbolPainter({required this.type, required this.ink});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    paintSymbol(
      canvas,
      Component(id: 'tile', type: type),
      unit: 13,
      ink: ink,
      accent: ink,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TileSymbolPainter old) =>
      old.type != type || old.ink != ink;
}

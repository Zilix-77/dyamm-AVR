import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

/// 2D canvas: dotted grid + pan/zoom (PRD §31).
/// Editor interactions arrive in Phase 1; simulation in Phase 3+.
class SchematicCanvas extends StatelessWidget {
  final TransformationController? controller;
  const SchematicCanvas({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: controller,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      minScale: AppConstants.minScale,
      maxScale: AppConstants.maxScale,
      child: const CustomPaint(
        size: Size.infinite,
        painter: GridPainter(),
        child: Center(child: Text(AppConstants.mvpHint)),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  const GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.shade300;
    for (var x = 0.0; x < size.width; x += AppConstants.gridStep) {
      for (var y = 0.0; y < size.height; y += AppConstants.gridStep) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/models/component.dart';
import '../../project/project_manager.dart';
import '../editor_state.dart';
import '../geometry.dart';

/// Live minimap: component dots, current viewport rectangle, tap-to-navigate.
/// Follows pan/zoom via the shared [controller]; canvas size comes from
/// [canvasSizeProvider] (null until first layout — then it shows content only).
class Minimap extends ConsumerWidget {
  final TransformationController controller;
  const Minimap({super.key, required this.controller});

  static const boxSize = Size(216, 132);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final components =
        ref.watch(sessionProvider.select((s) => s.active?.components ?? []));
    final canvasSize = ref.watch(canvasSizeProvider);
    return ValueListenableBuilder<Matrix4>(
      valueListenable: controller,
      builder: (context, view, _) => Tooltip(
        message: 'Minimap — tap to navigate',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) {
            if (canvasSize == null) return;
            final bounds = contentBounds(components);
            final world = miniToWorld(
                d.localPosition, bounds, boxSize);
            controller.value = centerOnWorld(view, world, canvasSize);
          },
          child: Container(
            width: boxSize.width,
            height: boxSize.height,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomPaint(
              painter: _MinimapPainter(
                components: components,
                view: view,
                canvasSize: canvasSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MinimapPainter extends CustomPainter {
  final List<Component> components;
  final Matrix4 view;
  final Size? canvasSize;
  _MinimapPainter({
    required this.components,
    required this.view,
    required this.canvasSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = contentBounds(components);
    final dot = Paint()..color = Colors.white;
    for (final c in components) {
      canvas.drawCircle(
        worldToMini(Offset(c.x, c.y), bounds, size),
        2.5,
        dot,
      );
    }
    if (canvasSize != null) {
      final vp = viewportWorld(view, canvasSize!);
      final tl = worldToMini(vp.topLeft, bounds, size);
      final br = worldToMini(vp.bottomRight, bounds, size);
      canvas.drawRect(
        Rect.fromPoints(tl, br),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MinimapPainter old) => true;
}

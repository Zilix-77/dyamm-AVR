import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/editor_theme.dart';
import 'canvas/schematic_canvas.dart';
import 'widgets/editor_top_bar.dart';
import 'widgets/library_bar.dart';
import 'widgets/project_panel.dart';
import 'widgets/tool_pad.dart';

/// Landscape editor shell — Stitch layout:
/// top bar · left dock · canvas (minimap TR, zoom pill BL) ·
/// bottom library + 3×3 pad. Editing gestures live in [SchematicCanvas];
/// sim controls drive the existing SimController.
class WorkspaceScreen extends ConsumerStatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  ConsumerState<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends ConsumerState<WorkspaceScreen> {
  final _zoomController = TransformationController();
  bool _dockOpen = true;

  @override
  void dispose() {
    _zoomController.dispose();
    super.dispose();
  }

  void _zoom(double factor) {
    final v = _zoomController.value;
    final s = (v.getMaxScaleOnAxis() * factor).clamp(0.2, 4.0);
    _zoomController.value = Matrix4.diagonal3Values(s, s, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EditorColors.canvas,
      appBar: EditorTopBar(
        onMenu: () => setState(() => _dockOpen = !_dockOpen),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_dockOpen) const SizedBox(width: 256, child: ProjectPanelBody()),
          if (_dockOpen) Container(width: 1, color: EditorColors.border),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      SchematicCanvas(controller: _zoomController),
                      const Positioned(
                        top: 12,
                        right: 12,
                        child: MinimapPlaceholder(),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: ZoomPill(
                          controller: _zoomController,
                          onZoomIn: () => _zoom(1.25),
                          onZoomOut: () => _zoom(0.8),
                          onReset: () =>
                              _zoomController.value = Matrix4.identity(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: EditorColors.border),
                SizedBox(
                  height: 192,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Expanded(child: ComponentLibraryBar()),
                      Container(width: 1, color: EditorColors.border),
                      const SizedBox(width: 216, child: ToolPad()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Stitch radar minimap — dotted field + viewport-rect outline.
/// Live viewport tracking is planned; layout + styling are exact.
class MinimapPlaceholder extends StatelessWidget {
  const MinimapPlaceholder({super.key});

  @override
  Widget build(BuildContext context) => Tooltip(
    message: 'Minimap (live tracking planned)',
    child: Container(
      width: 256,
      height: 160,
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
        painter: _MinimapGridPainter(),
        child: Center(
          child: Container(
            width: 128,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    ),
  );
}

class _MinimapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color.fromRGBO(255, 255, 255, 0.14);
    for (var x = 0.0; x < size.width; x += 8) {
      for (var y = 0.0; y < size.height; y += 8) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Floating zoom cluster — Stitch pill: `-` · live `%` · `+` · reset.
class ZoomPill extends StatelessWidget {
  final TransformationController controller;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;
  const ZoomPill({
    super.key,
    required this.controller,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: EditorColors.panel.withValues(alpha: 0.95),
      border: Border.all(color: EditorColors.borderLight),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ZoomButton(
          tooltip: 'Zoom out',
          icon: Icons.remove,
          onPressed: onZoomOut,
        ),
        ValueListenableBuilder<Matrix4>(
          valueListenable: controller,
          builder: (context, v, _) => SizedBox(
            width: 52,
            child: Text(
              '${(v.getMaxScaleOnAxis() * 100).round()}%',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: EditorColors.fontMono,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        _ZoomButton(tooltip: 'Zoom in', icon: Icons.add, onPressed: onZoomIn),
        Container(
          width: 1,
          height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          color: EditorColors.border,
        ),
        _ZoomButton(
          tooltip: 'Reset zoom',
          icon: Icons.fullscreen,
          size: 18,
          onPressed: onReset,
        ),
      ],
    ),
  );
}

class _ZoomButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final double size;
  final VoidCallback onPressed;
  const _ZoomButton({
    required this.tooltip,
    required this.icon,
    this.size = 20,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 36,
    height: 36,
    child: IconButton(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      icon: Icon(icon, size: size, color: EditorColors.muted),
      onPressed: onPressed,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/editor_theme.dart';
import '../simulation/simulation.dart';
import '../components/component_library.dart';
import '../../core/constants/app_constants.dart';
import 'canvas/schematic_canvas.dart';
import 'editor_state.dart';
import 'geometry.dart';
import 'widgets/editor_top_bar.dart';
import 'widgets/library_bar.dart';
import 'widgets/minimap.dart';
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

  /// Session-only panel sizes (reset when the editor closes).
  double _dockWidth = 256;
  double? _shelfHeightDragged;

  @override
  void dispose() {
    _zoomController.dispose();
    super.dispose();
  }

  void _zoom(double factor) {
    final size = ref.read(canvasSizeProvider);
    if (size == null) {
      final v = _zoomController.value;
      final s =
          (v.getMaxScaleOnAxis() * factor).clamp(0.2, 4.0);
      _zoomController.value = Matrix4.diagonal3Values(s, s, 1);
      return;
    }
    _zoomController.value = zoomAboutCenter(
      _zoomController.value,
      Offset(size.width / 2, size.height / 2),
      factor,
      AppConstants.minScale,
      AppConstants.maxScale,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EditorColors.canvas,
      appBar: EditorTopBar(
        onMenu: () => setState(() => _dockOpen = !_dockOpen),
      ),
      body: LayoutBuilder(
        builder: (context, outer) {
          // Dock width: absolute min/max, never more than 40% of the Row.
          final dockWidth = _dockWidth.clamp(
            180.0,
            (outer.maxWidth * 0.4).clamp(180.0, 360.0),
          );
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_dockOpen)
                SizedBox(
                  key: const Key('dock-panel'),
                  width: dockWidth,
                  child: const ProjectPanelBody(),
                ),
              if (_dockOpen)
                _DragDivider(
                  key: const Key('dock-divider'),
                  axis: Axis.horizontal,
                  onDrag: (dx, dy) => setState(() => _dockWidth += dx),
                ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Stitch shelf is 192px; shrink proportionally on short
                    // landscape screens so the column never overflows, unless
                    // the user dragged it (then the dragged height wins).
                    final shelfHeight =
                        (_shelfHeightDragged ?? (constraints.maxHeight * 0.38))
                            .clamp(120.0, 260.0);
                    // Tool pad yields on narrow rows so the shelf Row never
                    // overflows (portrait transition frames, small screens).
                    final padWidth = (constraints.maxWidth * 0.24).clamp(
                      160.0,
                      216.0,
                    );
                    return Column(
                      children: [
                        const _SimErrorStrip(),
                        Expanded(
                          child: Stack(
                            children: [
                              SchematicCanvas(
                                key: const Key('schematic-canvas'),
                                controller: _zoomController,
                              ),
                              const _PlacementHint(),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Minimap(controller: _zoomController),
                              ),
                              Positioned(
                                bottom: 12,
                                left: 12,
                                child: ZoomPill(
                                  controller: _zoomController,
                                  onZoomIn: () => _zoom(1.25),
                                  onZoomOut: () => _zoom(0.8),
                                  onReset: () => _zoomController.value =
                                      Matrix4.identity(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _DragDivider(
                          key: const Key('shelf-divider'),
                          axis: Axis.vertical,
                          onDrag: (dx, dy) => setState(
                            () => _shelfHeightDragged = shelfHeight - dy,
                          ),
                        ),
                        SizedBox(
                          height: shelfHeight,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Expanded(child: ComponentLibraryBar()),
                              Container(width: 1, color: EditorColors.border),
                              SizedBox(width: padWidth, child: const ToolPad()),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Draggable panel divider (Stitch col/row-resize handles): 12px touch
/// target, 1px visual line, brightens on hover/press. Canvas viewport is
/// preserved automatically — resize only changes layout constraints while
/// the [TransformationController] matrix stays untouched.
class _DragDivider extends StatefulWidget {
  final Axis axis;
  final void Function(double dx, double dy) onDrag;
  const _DragDivider({super.key, required this.axis, required this.onDrag});

  @override
  State<_DragDivider> createState() => _DragDividerState();
}

class _DragDividerState extends State<_DragDivider> {
  bool _hot = false;

  @override
  Widget build(BuildContext context) {
    final horizontal = widget.axis == Axis.horizontal;
    return MouseRegion(
      cursor: horizontal
          ? SystemMouseCursors.resizeLeftRight
          : SystemMouseCursors.resizeUpDown,
      onEnter: (_) => setState(() => _hot = true),
      onExit: (_) => setState(() => _hot = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: horizontal
            ? (d) => widget.onDrag(d.delta.dx, 0)
            : null,
        onVerticalDragUpdate: horizontal
            ? null
            : (d) => widget.onDrag(0, d.delta.dy),
        onHorizontalDragStart: horizontal
            ? (_) => setState(() => _hot = true)
            : null,
        onHorizontalDragEnd: horizontal
            ? (_) => setState(() => _hot = false)
            : null,
        onVerticalDragStart: horizontal
            ? null
            : (_) => setState(() => _hot = true),
        onVerticalDragEnd: horizontal
            ? null
            : (_) => setState(() => _hot = false),
        child: Container(
          width: horizontal ? 12 : null,
          height: horizontal ? null : 12,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Container(
            width: horizontal ? 1 : null,
            height: horizontal ? null : 1,
            color: _hot ? Colors.white : EditorColors.border,
          ),
        ),
      ),
    );
  }
}

/// Slim error strip for the last DC solve. Hidden on success.
class _SimErrorStrip extends ConsumerWidget {
  const _SimErrorStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = ref.watch(simErrorProvider);
    if (error == null) return const SizedBox.shrink();
    return Container(
      color: const Color(0xFF3A1414),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(simErrorProvider.notifier).state = null,
            child: const Icon(Icons.close, size: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

/// Armed-placement hint bar. Visible only while a library tile is armed;
/// tells the user the next canvas tap places the component (tap the tile
/// again to disarm).
class _PlacementHint extends ConsumerWidget {
  const _PlacementHint();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingPlacementProvider);
    if (pending == null) return const SizedBox.shrink();
    return Positioned(
      top: 12,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Tap canvas to place ${componentLabel(pending)} — tap tile again to cancel',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
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
    width: 44,
    height: 44,
    child: IconButton(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      icon: Icon(icon, size: size, color: EditorColors.muted),
      onPressed: onPressed,
    ),
  );
}

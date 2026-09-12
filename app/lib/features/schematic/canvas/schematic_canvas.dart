import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../components/models/component.dart';
import '../../project/project_manager.dart';
import '../../simulation/simulation.dart';
import '../editor_state.dart';
import '../geometry.dart';
import '../models/schematic.dart';
import '../symbols.dart';

/// Interactive schematic canvas: renders components + wires, handles
/// place/select/move/delete/rotate/wire gestures per [activeToolProvider].
class SchematicCanvas extends ConsumerStatefulWidget {
  final TransformationController? controller;
  const SchematicCanvas({super.key, this.controller});

  @override
  ConsumerState<SchematicCanvas> createState() => _SchematicCanvasState();
}

class _SchematicCanvasState extends ConsumerState<SchematicCanvas> {
  late final TransformationController _controller =
      widget.controller ?? TransformationController();
  bool _panLocked = false;
  String? _dragId;

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  Offset _toScene(Offset global) {
    final box = context.findRenderObject()! as RenderBox;
    return _controller.toScene(box.globalToLocal(global));
  }

  List<Component> get _components =>
      ref.read(sessionProvider).active?.components ?? [];

  void _tapDown(TapDownDetails d) {
    final pos = _toScene(d.globalPosition);
    final session = ref.read(sessionProvider.notifier);
    final tool = ref.read(activeToolProvider);
    final pending = ref.read(pendingPlacementProvider);
    final comps = _components;

    if (pending != null) {
      final id = 'c${DateTime.now().microsecondsSinceEpoch}';
      session.addComponent(
        makeComponent(id, pending, snap(pos.dx), snap(pos.dy)),
      );
      ref.read(pendingPlacementProvider.notifier).state = null;
      ref.read(selectedIdProvider.notifier).state = id;
      ref.read(activeToolProvider.notifier).state = SchematicTool.select;
      refreshSimulation(ref);
      return;
    }

    final pinHit = hitPin(comps, pos, AppConstants.gridStep * 0.45);
    if (tool == SchematicTool.wire) {
      final wireStart = ref.read(pendingWireProvider);
      if (pinHit == null) {
        ref.read(pendingWireProvider.notifier).state = null;
        return;
      }
      final key = pinKey(pinHit.componentId, pinHit.pin.id);
      if (wireStart == null) {
        ref.read(pendingWireProvider.notifier).state = key;
      } else if (wireStart != key) {
        final a = wireStart.split('.');
        final b = key.split('.');
        session.addWire(
          Wire(
            id: 'w${DateTime.now().microsecondsSinceEpoch}',
            fromComponent: a[0],
            fromPin: a[1],
            toComponent: b[0],
            toPin: b[1],
          ),
        );
        ref.read(pendingWireProvider.notifier).state = null;
      }
      refreshSimulation(ref);
      return;
    }

    final hit = hitComponent(comps, pos, AppConstants.gridStep * 1.1);
    switch (tool) {
      case SchematicTool.delete:
        if (hit != null) {
          session.deleteComponent(hit);
          refreshSimulation(ref);
        }
      case SchematicTool.rotate:
        if (hit != null) {
          session.rotateComponent(hit);
          refreshSimulation(ref);
        }
      case SchematicTool.select:
        ref.read(selectedIdProvider.notifier).state = hit;
        if (hit != null) {
          final c = comps.firstWhere((e) => e.id == hit);
          if (c.type == ComponentType.switch_ ||
              c.type == ComponentType.pushButton) {
            session.toggleSwitch(hit);
            refreshSimulation(ref);
          }
        }
      case SchematicTool.move:
        ref.read(selectedIdProvider.notifier).state = hit;
      default:
        ref.read(selectedIdProvider.notifier).state = hit;
    }
  }

  void _panStart(DragStartDetails d) {
    if (ref.read(activeToolProvider) != SchematicTool.move) return;
    final pos = _toScene(d.globalPosition);
    final hit = hitComponent(_components, pos, AppConstants.gridStep * 1.1);
    if (hit != null) {
      setState(() {
        _dragId = hit;
        _panLocked = true;
      });
      ref.read(selectedIdProvider.notifier).state = hit;
    }
  }

  void _panUpdate(DragUpdateDetails d) {
    final id = _dragId;
    if (id == null) return;
    final pos = _toScene(d.globalPosition);
    ref
        .read(sessionProvider.notifier)
        .moveComponent(id, snap(pos.dx), snap(pos.dy));
  }

  void _panEnd(DragEndDetails _) {
    if (_dragId != null) {
      setState(() {
        _dragId = null;
        _panLocked = false;
      });
      refreshSimulation(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final selectedId = ref.watch(selectedIdProvider);
    final simStates = ref.watch(simStatesProvider);
    final active = session.active;
    return InteractiveViewer(
      transformationController: _controller,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      minScale: AppConstants.minScale,
      maxScale: AppConstants.maxScale,
      panEnabled: !_panLocked,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _tapDown,
        onPanStart: _panStart,
        onPanUpdate: _panUpdate,
        onPanEnd: _panEnd,
        child: CustomPaint(
          size: Size.infinite,
          painter: _SchematicPainter(
            components: active?.components ?? const [],
            wires: active?.wires ?? const [],
            selectedId: selectedId,
            simStates: simStates,
          ),
          child: const CustomPaint(size: Size.infinite, painter: GridPainter()),
        ),
      ),
    );
  }
}

/// Dotted grid background — Stitch `cad-grid`: #050505 with white 16% dots.
class GridPainter extends CustomPainter {
  const GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFF050505), BlendMode.src);
    final paint = Paint()..color = const Color.fromRGBO(255, 255, 255, 0.16);
    for (var x = 0.0; x < size.width; x += 20) {
      for (var y = 0.0; y < size.height; y += 20) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SchematicPainter extends CustomPainter {
  final List<Component> components;
  final List<Wire> wires;
  final String? selectedId;
  final Map<String, bool> simStates;

  _SchematicPainter({
    required this.components,
    required this.wires,
    required this.selectedId,
    required this.simStates,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final unit = AppConstants.gridStep;
    const ink = Color(0xFFE8E8E8);
    const accent = Color(0xFFF4F4F4);
    final byId = {for (final c in components) c.id: c};

    final wirePaint = Paint()
      ..color = const Color(0xFF9A9A9A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final w in wires) {
      final from = byId[w.fromComponent];
      final to = byId[w.toComponent];
      if (from == null || to == null) continue;
      final a = _pinById(from, w.fromPin);
      final b = _pinById(to, w.toPin);
      if (a == null || b == null) continue;
      canvas.drawLine(pinWorld(from, a), pinWorld(to, b), wirePaint);
    }
    for (final c in components) {
      canvas.save();
      canvas.translate(c.x, c.y);
      paintSymbol(
        canvas,
        c,
        unit: unit,
        ink: ink,
        accent: accent,
        on: simStates[c.id] ?? false,
      );
      if (c.id == selectedId) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: 2.6 * unit,
            height: 2.2 * unit,
          ),
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
      canvas.restore();
      paintTag(canvas, c.id, Offset(c.x, c.y), unit, const Color(0xFF7E7E7E));
    }
    for (final c in components) {
      for (final p in c.pins) {
        canvas.drawCircle(
          pinWorld(c, p),
          3,
          Paint()..color = const Color(0xFFB5B5B5),
        );
      }
    }
  }

  Pin? _pinById(Component c, String pinId) {
    for (final p in c.pins) {
      if (p.id == pinId) return p;
    }
    return null;
  }

  @override
  bool shouldRepaint(covariant _SchematicPainter old) =>
      old.components != components ||
      old.wires != wires ||
      old.selectedId != selectedId ||
      old.simStates != simStates;
}

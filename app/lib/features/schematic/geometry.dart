import 'dart:ui' show Offset, Rect, Size;

import 'package:vector_math/vector_math_64.dart' show Matrix4, Vector3;

import '../components/models/component.dart';
import '../project/models/project.dart';
import '../../core/constants/app_constants.dart';

/// Grid + rotation math shared by the painter and hit testing.
/// Positions are logical pixels; components snap to [AppConstants.gridStep].
/// Snaps [v] to the grid when [enabled] (toggle), else free positioning.
double snap(double v, [bool enabled = true]) => enabled
    ? (v / AppConstants.gridStep).round() * AppConstants.gridStep
    : v;

/// Rotates a symbol-relative offset by [rotation] degrees clockwise
/// (screen coordinates, y down).
Offset rotateOffset(double dx, double dy, int rotation) {
  switch (((rotation % 360) + 360) % 360) {
    case 90:
      return Offset(-dy, dx);
    case 180:
      return Offset(-dx, -dy);
    case 270:
      return Offset(dy, -dx);
    default:
      return Offset(dx, dy);
  }
}

/// World position of a component pin in logical pixels.
Offset pinWorld(Component c, Pin p) {
  final o = rotateOffset(p.dx, p.dy, c.rotation);
  return Offset(
    c.x + o.dx * AppConstants.gridStep,
    c.y + o.dy * AppConstants.gridStep,
  );
}

/// Pin reference key used by wires: `componentId.pinId`.
String pinKey(String componentId, String pinId) => '$componentId.$pinId';

/// Finds the pin whose world position is within [radius] of [point].
({String componentId, Pin pin})? hitPin(
    List<Component> components, Offset point, double radius) {
  for (final c in components) {
    for (final p in c.pins) {
      if ((pinWorld(c, p) - point).distance <= radius) {
        return (componentId: c.id, pin: p);
      }
    }
  }
  return null;
}

/// Finds the topmost component body within [radius] of [point].
String? hitComponent(List<Component> components, Offset point, double radius) {
  for (var i = components.length - 1; i >= 0; i--) {
    if ((Offset(components[i].x, components[i].y) - point).distance <=
        radius) {
      return components[i].id;
    }
  }
  return null;
}

/// Zooms [m] about screen point [center] by [factor], clamped to
/// [minScale]..[maxScale]. The world point under [center] stays put.
/// Pure math (testable): M' = T(center) · S(r) · T(-center) · M.
Matrix4 zoomAboutCenter(
    Matrix4 m, Offset center, double factor, double minScale, double maxScale) {
  final s0 = m.getMaxScaleOnAxis();
  if (s0 <= 0) return m.clone();
  final s1 = (s0 * factor).clamp(minScale, maxScale);
  final r = s1 / s0;
  if (r == 1.0) return m.clone();
  final t = Matrix4.identity()
    ..translateByDouble(center.dx, center.dy, 0.0, 1.0)
    ..scaleByDouble(r, r, 1.0, 1.0)
    ..translateByDouble(-center.dx, -center.dy, 0.0, 1.0);
  return t * m;
}

double distanceToSegment(Offset p, Offset a, Offset b) {
  final l2 = (b - a).distanceSquared;
  if (l2 == 0) return (p - a).distance;
  final t = (((p.dx - a.dx) * (b.dx - a.dx) + (p.dy - a.dy) * (b.dy - a.dy)) /
          l2)
      .clamp(0.0, 1.0);
  return (p - Offset(a.dx + t * (b.dx - a.dx), a.dy + t * (b.dy - a.dy)))
      .distance;
}

/// Pin lookup by id within one component (null when absent).
Pin? pinById(Component c, String pinId) {
  for (final p in c.pins) {
    if (p.id == pinId) return p;
  }
  return null;
}

/// Finds the topmost wire within [radius] of [point].
String? hitWire(
  List<Component> components,
  List<Wire> wires,
  Offset point,
  double radius,
) {
  final byId = {for (final c in components) c.id: c};
  for (var i = wires.length - 1; i >= 0; i--) {
    final w = wires[i];
    final from = byId[w.fromComponent];
    final to = byId[w.toComponent];
    if (from == null || to == null) continue;
    final a = pinById(from, w.fromPin);
    final b = pinById(to, w.toPin);
    if (a == null || b == null) continue;
    if (distanceToSegment(point, pinWorld(from, a), pinWorld(to, b)) <=
        radius) {
      return w.id;
    }
  }
  return null;
}

/// World-space bounds of all components, with a fallback area when empty.
({Offset min, Offset max}) contentBounds(List<Component> comps) {
  if (comps.isEmpty) {
    return (min: const Offset(-240, -240), max: const Offset(240, 240));
  }
  var minX = double.infinity;
  var minY = double.infinity;
  var maxX = -double.infinity;
  var maxY = -double.infinity;
  for (final c in comps) {
    if (c.x < minX) minX = c.x;
    if (c.y < minY) minY = c.y;
    if (c.x > maxX) maxX = c.x;
    if (c.y > maxY) maxY = c.y;
  }
  const pad = 96.0;
  return (
    min: Offset(minX - pad, minY - pad),
    max: Offset(maxX + pad, maxY + pad)
  );
}

/// Maps a world point into minimap-box coordinates.
Offset worldToMini(
    Offset world, ({Offset min, Offset max}) bounds, Size mini) {
  final w = (bounds.max.dx - bounds.min.dx).clamp(1.0, double.infinity);
  final h = (bounds.max.dy - bounds.min.dy).clamp(1.0, double.infinity);
  final s = (mini.width / w < mini.height / h ? mini.width / w : mini.height / h);
  final ox = (mini.width - w * s) / 2;
  final oy = (mini.height - h * s) / 2;
  return Offset(ox + (world.dx - bounds.min.dx) * s,
      oy + (world.dy - bounds.min.dy) * s);
}

/// Inverse of [worldToMini].
Offset miniToWorld(
    Offset miniPt, ({Offset min, Offset max}) bounds, Size mini) {
  final w = (bounds.max.dx - bounds.min.dx).clamp(1.0, double.infinity);
  final h = (bounds.max.dy - bounds.min.dy).clamp(1.0, double.infinity);
  final s = (mini.width / w < mini.height / h ? mini.width / w : mini.height / h);
  final ox = (mini.width - w * s) / 2;
  final oy = (mini.height - h * s) / 2;
  return Offset(bounds.min.dx + (miniPt.dx - ox) / s,
      bounds.min.dy + (miniPt.dy - oy) / s);
}

/// Canvas viewport rectangle in world coordinates.
Rect viewportWorld(Matrix4 view, Size canvasSize) {
  final inv = Matrix4.inverted(view);
  Offset unproject(Offset p) {
    final v = inv.transform3(Vector3(p.dx, p.dy, 0));
    return Offset(v.x, v.y);
  }

  return Rect.fromPoints(
    unproject(Offset.zero),
    unproject(Offset(canvasSize.width, canvasSize.height)),
  );
}

/// New viewport matrix that centers [world] in [canvasSize] at current scale.
Matrix4 centerOnWorld(Matrix4 view, Offset world, Size canvasSize) {
  final s = view.getMaxScaleOnAxis();
  final c = Offset(canvasSize.width / 2, canvasSize.height / 2);
  return Matrix4.identity()
    ..translateByDouble(c.dx - s * world.dx, c.dy - s * world.dy, 0.0, 1.0)
    ..scaleByDouble(s, s, 1.0, 1.0);
}


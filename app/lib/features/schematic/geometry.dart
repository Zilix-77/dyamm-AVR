import 'dart:ui' show Offset;

import '../components/models/component.dart';
import '../../core/constants/app_constants.dart';

/// Grid + rotation math shared by the painter and hit testing.
/// Positions are logical pixels; components snap to [AppConstants.gridStep].
double snap(double v) =>
    (v / AppConstants.gridStep).round() * AppConstants.gridStep;

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

double distanceToSegment(Offset p, Offset a, Offset b) {
  final l2 = (b - a).distanceSquared;
  if (l2 == 0) return (p - a).distance;
  final t = (((p.dx - a.dx) * (b.dx - a.dx) + (p.dy - a.dy) * (b.dy - a.dy)) /
          l2)
      .clamp(0.0, 1.0);
  return (p - Offset(a.dx + t * (b.dx - a.dx), a.dy + t * (b.dy - a.dy)))
      .distance;
}


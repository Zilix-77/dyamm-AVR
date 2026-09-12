import 'dart:ui' show Offset, Size;

import 'package:dyamm_avr_schema_design/features/components/models/component.dart';
import 'package:dyamm_avr_schema_design/features/schematic/geometry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart' show Matrix4, Vector3;

void main() {
  test('snap honors the toggle', () {
    expect(snap(35), 32);
    expect(snap(35, false), 35);
    expect(snap(35, true), 32);
  });

  test('rotation maps offsets clockwise in screen space', () {
    expect(rotateOffset(1, 0, 0), const Offset(1, 0));
    expect(rotateOffset(1, 0, 90), const Offset(0, 1));
    expect(rotateOffset(1, 0, 180), const Offset(-1, 0));
    expect(rotateOffset(1, 0, 270), const Offset(0, -1));
    expect(rotateOffset(1, 0, 450), const Offset(0, 1));
  });

  test('pin world position uses rotation and grid step', () {
    const c = Component(id: 'r', type: ComponentType.resistor, x: 64, y: 64);
    const pin = Pin(id: 'a', label: 'A', dx: -1);
    expect(pinWorld(c, pin), const Offset(32, 64));
  });

  test('zoomAboutCenter keeps the focal world point fixed', () {
    const center = Offset(400, 300);
    final m = Matrix4.identity()..translateByDouble(100, 50, 0, 1);
    final zoomed = zoomAboutCenter(m, center, 2.0, 0.2, 4.0);
    // World point under center before == world point under center after.
    Offset unproject(Matrix4 v, Offset p) {
      final inv = Matrix4.inverted(v);
      final r = inv.transform3(Vector3(p.dx, p.dy, 0));
      return Offset(r.x, r.y);
    }

    final before = unproject(m, center);
    final after = unproject(zoomed, center);
    expect((after - before).distance, lessThan(1e-6));
    expect(zoomed.getMaxScaleOnAxis(), closeTo(2.0, 1e-9));
  });

  test('zoomAboutCenter clamps to min/max scale', () {
    const center = Offset(0, 0);
    final up = zoomAboutCenter(Matrix4.identity(), center, 100, 0.2, 4.0);
    expect(up.getMaxScaleOnAxis(), 4.0);
    final down = zoomAboutCenter(Matrix4.identity(), center, 0.001, 0.2, 4.0);
    expect(down.getMaxScaleOnAxis(), 0.2);
  });

  test('minimap round-trip world->mini->world', () {
    const bounds = (min: Offset(0, 0), max: Offset(400, 200));
    const mini = Size(200, 132);
    const world = Offset(100, 50);
    final back = miniToWorld(worldToMini(world, bounds, mini), bounds, mini);
    expect((back - world).distance, lessThan(1e-6));
  });

  test('centerOnWorld puts world at canvas center', () {
    const canvas = Size(800, 600);
    const world = Offset(100, 50);
    final m = centerOnWorld(Matrix4.identity(), world, canvas);
    // Applying m to world should yield canvas center.
    final v = m.transform3(Vector3(world.dx, world.dy, 0));
    expect(v.x, closeTo(400, 1e-6));
    expect(v.y, closeTo(300, 1e-6));
  });
}

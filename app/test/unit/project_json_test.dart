import 'dart:convert';

import 'package:dyamm_avr_schema_design/features/components/models/component.dart';
import 'package:dyamm_avr_schema_design/features/project/models/project.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('project survives a JSON round-trip', () {
    final p = Project(name: 'round', components: [
      makeComponent('r1', ComponentType.resistor, 24, 48)
          .copyWith(rotation: 90, properties: {'resistance': 470}),
      makeComponent('led1', ComponentType.led, 72, 48),
    ], wires: [
      const Wire(
          id: 'w1',
          fromComponent: 'r1',
          fromPin: 'b',
          toComponent: 'led1',
          toPin: 'a'),
    ]);
    final back =
        Project.fromJson(jsonDecode(jsonEncode(p.toJson())) as Map<String, dynamic>);
    expect(back.name, 'round');
    expect(back.components.length, 2);
    final r = back.components.firstWhere((c) => c.id == 'r1');
    expect(r.rotation, 90);
    expect(r.properties['resistance'], 470);
    expect(r.pins.map((e) => e.id), ['a', 'b']);
    expect(back.wires.single.toJson(), p.wires.single.toJson());
  });
}

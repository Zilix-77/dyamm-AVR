import 'dart:io';

import 'package:dyamm_avr_schema_design/features/components/models/component.dart';
import 'package:dyamm_avr_schema_design/features/project/services/project_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('save/list/open round-trip on disk', () async {
    final dir = await Directory.systemTemp.createTemp('simavr_test_');
    addTearDown(() => dir.delete(recursive: true));
    final storage = FileProjectStorage(dir);
    final p = Project(name: 'filed', components: [
      makeComponent('r1', ComponentType.resistor, 24, 24),
    ], wires: const []);
    await storage.save(p);
    expect(await storage.list(), ['filed']);
    final back = await storage.open('filed');
    expect(back?.name, 'filed');
    expect(back?.components.single.properties['resistance'], 220);
    expect(await storage.open('missing'), isNull);
  });
}

import 'package:dyamm_avr_schema_design/features/components/models/component.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('component serializes to .dyamm JSON', () {
    const c = Component(
      id: 'r1',
      type: ComponentType.resistor,
      properties: {'resistance': 220},
    );
    final j = c.toJson();
    expect(j['id'], 'r1');
    expect(j['type'], 'resistor');
    expect((j['properties'] as Map)['resistance'], 220);
  });
}

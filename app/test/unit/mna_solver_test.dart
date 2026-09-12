import 'package:dyamm_avr_schema_design/features/components/models/component.dart';
import 'package:dyamm_avr_schema_design/features/project/models/project.dart';
import 'package:dyamm_avr_schema_design/features/simulation/solver/mna_solver.dart';
import 'package:flutter_test/flutter_test.dart';

Project _circuit({
  required Component source,
  required Component series,
  required Component led,
}) {
  // source+ -- series -- led.A -- led.K -- GND
  return Project(name: 't', components: [
    source,
    series,
    led,
    makeComponent('gnd', ComponentType.gnd, 0, 0),
  ], wires: [
    Wire(
        id: 'w1',
        fromComponent: source.id,
        fromPin: 'p',
        toComponent: series.id,
        toPin: 'a'),
    Wire(
        id: 'w2',
        fromComponent: series.id,
        fromPin: 'b',
        toComponent: led.id,
        toPin: 'a'),
    Wire(
        id: 'w3',
        fromComponent: led.id,
        fromPin: 'b',
        toComponent: 'gnd',
        toPin: 'p'),
  ]);
}

void main() {
  test('VCC-R-LED-GND lights with sane node voltages', () {
    final vcc = makeComponent('vcc', ComponentType.vcc, 0, 0);
    final r = makeComponent('r1', ComponentType.resistor, 0, 0);
    final led = makeComponent('led1', ComponentType.led, 0, 0);
    final sol = solveDc(_circuit(source: vcc, series: r, led: led));
    expect(sol.error, isNull);
    expect(sol.componentOn['led1'], isTrue);
    // I = (5-2)/(220+10) ≈ 13.04mA; Vanode ≈ 5 - I*220 ≈ 2.13V.
    expect(sol.pinVoltages['led1.a']!, closeTo(2.13, 0.05));
    expect(sol.pinVoltages['led1.b']!, closeTo(0, 1e-9));
    expect(sol.branchCurrents['led1']!, closeTo(0.01304, 0.001));
  });

  test('open switch keeps LED dark', () {
    final vcc = makeComponent('vcc', ComponentType.vcc, 0, 0);
    final sw = makeComponent('sw', ComponentType.switch_, 0, 0);
    final led = makeComponent('led1', ComponentType.led, 0, 0);
    final sol = solveDc(_circuit(source: vcc, series: sw, led: led));
    expect(sol.error, isNull);
    expect(sol.componentOn['led1'] ?? false, isFalse);
  });

  test('closed switch lights LED', () {
    final vcc = makeComponent('vcc', ComponentType.vcc, 0, 0);
    final sw = makeComponent('sw', ComponentType.switch_, 0, 0)
        .copyWith(properties: {'closed': 1.0});
    final led = makeComponent('led1', ComponentType.led, 0, 0);
    final sol = solveDc(_circuit(source: vcc, series: sw, led: led));
    expect(sol.error, isNull);
    expect(sol.componentOn['led1'], isTrue);
  });

  test('floating dc source without ground is an error', () {
    final dc = makeComponent('dc', ComponentType.dcSource, 0, 0);
    final sol = solveDc(Project(name: 't', components: [dc], wires: const []));
    expect(sol.error, isNotNull);
  });

  test('capacitor in series blocks DC', () {
    final vcc = makeComponent('vcc', ComponentType.vcc, 0, 0);
    final cap = makeComponent('c1', ComponentType.capacitor, 0, 0);
    final led = makeComponent('led1', ComponentType.led, 0, 0);
    final sol = solveDc(_circuit(source: vcc, series: cap, led: led));
    expect(sol.error, isNull);
    expect(sol.componentOn['led1'] ?? false, isFalse);
  });
}

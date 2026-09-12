import 'package:dyamm_avr_schema_design/features/components/models/component.dart';
import 'package:dyamm_avr_schema_design/features/project/project_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProviderContainer makeContainer() => ProviderContainer();

  test('place, move, rotate, toggle, wire, delete', () {
    final c = makeContainer();
    addTearDown(c.dispose);
    final ctl = c.read(sessionProvider.notifier);
    expect(ctl.create('ed'), CreateResult.ok);

    ctl.addComponent(makeComponent('r1', ComponentType.resistor, 0, 0));
    expect(c.read(sessionProvider).active?.components.length, 1);

    ctl.moveComponent('r1', 48, 72);
    final moved =
        c.read(sessionProvider).active?.components.singleWhere((e) => e.id == 'r1');
    expect(moved?.x, 48);
    expect(moved?.y, 72);

    ctl.rotateComponent('r1');
    expect(
        c.read(sessionProvider).active?.components.singleWhere((e) => e.id == 'r1').rotation,
        90);

    ctl.addComponent(makeComponent('led1', ComponentType.led, 96, 72));
    ctl.addWire(const Wire(
        id: 'w1',
        fromComponent: 'r1',
        fromPin: 'b',
        toComponent: 'led1',
        toPin: 'a'));
    expect(c.read(sessionProvider).active?.wires.length, 1);

    ctl.deleteComponent('r1');
    final s = c.read(sessionProvider);
    expect(s.active?.components.map((e) => e.id), ['led1']);
    expect(s.active?.wires, isEmpty); // dangling wire removed too.
  });

  test('toggleSwitch flips closed and ignores other types', () {
    final c = makeContainer();
    addTearDown(c.dispose);
    final ctl = c.read(sessionProvider.notifier);
    ctl.create('ed');
    ctl.addComponent(makeComponent('sw', ComponentType.switch_, 0, 0));
    ctl.addComponent(makeComponent('r1', ComponentType.resistor, 0, 0));
    ctl.toggleSwitch('sw');
    ctl.toggleSwitch('r1');
    final comps = c.read(sessionProvider).active!.components;
    expect(comps.firstWhere((e) => e.id == 'sw').properties['closed'], 1.0);
    expect(comps.firstWhere((e) => e.id == 'r1').properties['closed'], isNull);
  });
}

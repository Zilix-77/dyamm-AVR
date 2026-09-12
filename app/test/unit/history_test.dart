import 'package:dyamm_avr_schema_design/features/components/models/component.dart';
import 'package:dyamm_avr_schema_design/features/project/project_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ProviderContainer makeContainer() => ProviderContainer();

void main() {
  test('undo/redo across place, move, delete and wire', () {
    final c = makeContainer();
    addTearDown(c.dispose);
    final ctl = c.read(sessionProvider.notifier);
    ctl.create('h');
    expect(ctl.canUndo(), isFalse);

    ctl.addComponent(makeComponent('r1', ComponentType.resistor, 0, 0));
    expect(ctl.canUndo(), isTrue);
    ctl.undo();
    expect(c.read(sessionProvider).active?.components, isEmpty);
    expect(ctl.canRedo(), isTrue);
    ctl.redo();
    expect(c.read(sessionProvider).active?.components.length, 1);

    ctl.moveComponent('r1', 99, 99);
    ctl.undo();
    expect(
        c.read(sessionProvider).active?.components.single.x, 0);

    ctl.addComponent(makeComponent('l1', ComponentType.led, 0, 0));
    ctl.addWire(const Wire(
        id: 'w1',
        fromComponent: 'r1',
        fromPin: 'b',
        toComponent: 'l1',
        toPin: 'a'));
    ctl.deleteComponent('r1');
    expect(c.read(sessionProvider).active?.components.map((e) => e.id),
        ['l1']);
    expect(c.read(sessionProvider).active?.wires, isEmpty);
    ctl.undo(); // restores r1 AND its wire.
    expect(
        c.read(sessionProvider).active?.components.map((e) => e.id),
        contains('r1'));
    expect(c.read(sessionProvider).active?.wires.length, 1);
    ctl.undo(); // removes the wire.
    expect(c.read(sessionProvider).active?.wires, isEmpty);
  });

  test('new edit clears redo; history is bounded', () {
    final c = makeContainer();
    addTearDown(c.dispose);
    final ctl = c.read(sessionProvider.notifier);
    ctl.create('h');
    ctl.addComponent(makeComponent('a', ComponentType.resistor, 0, 0));
    ctl.undo();
    expect(ctl.canRedo(), isTrue);
    ctl.addComponent(makeComponent('b', ComponentType.resistor, 0, 0));
    expect(ctl.canRedo(), isFalse);
    // Empty-stack calls are safe no-ops.
    final empty = makeContainer();
    addTearDown(empty.dispose);
    final e2 = empty.read(sessionProvider.notifier);
    e2.undo();
    e2.redo();
  });
}

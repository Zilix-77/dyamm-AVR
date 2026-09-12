import 'package:dyamm_avr_schema_design/features/project/project_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProviderContainer makeContainer() => ProviderContainer();

  test('create rejects empty and blank names', () {
    final c = makeContainer();
    addTearDown(c.dispose);
    final ctl = c.read(sessionProvider.notifier);
    expect(ctl.create(''), CreateResult.emptyName);
    expect(ctl.create('   '), CreateResult.emptyName);
    expect(c.read(sessionProvider).active, isNull);
    expect(c.read(sessionProvider).recents, isEmpty);
  });

  test('create trims, activates and records recent', () {
    final c = makeContainer();
    addTearDown(c.dispose);
    final ctl = c.read(sessionProvider.notifier);
    expect(ctl.create('  blink  '), CreateResult.ok);
    final s = c.read(sessionProvider);
    expect(s.active?.name, 'blink');
    expect(s.recents.map((p) => p.name), ['blink']);
  });

  test('open and close switch screens worth of state', () {
    final c = makeContainer();
    addTearDown(c.dispose);
    final ctl = c.read(sessionProvider.notifier);
    ctl.create('a');
    ctl.create('b');
    ctl.close();
    expect(c.read(sessionProvider).active, isNull);
    expect(c.read(sessionProvider).recents.map((p) => p.name), ['b', 'a']);
    ctl.open(const Project(name: 'a'));
    expect(c.read(sessionProvider).active?.name, 'a');
  });
}

import 'package:dyamm_avr_schema_design/app.dart';
import 'package:dyamm_avr_schema_design/features/project/project_manager.dart';
import 'package:dyamm_avr_schema_design/features/schematic/canvas/schematic_canvas.dart';
import 'package:dyamm_avr_schema_design/features/schematic/editor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<ProviderContainer> _openEditor(WidgetTester tester, String name) async {
  await tester.pumpWidget(const ProviderScope(child: DyammApp()));
  await tester.pumpAndSettle();
  await tester.tap(find.text('New Project'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), name);
  await tester.tap(find.text('Create'));
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(
    tester.element(find.byType(SchematicCanvas)),
    listen: false,
  );
}

void main() {
  testWidgets('tile tap then canvas tap places a component', (
    WidgetTester tester,
  ) async {
    final container = await _openEditor(tester, 'ed');
    await tester.tap(find.text('Resistor'));
    await tester.pumpAndSettle();
    await tester.tapAt(tester.getCenter(find.byType(SchematicCanvas)));
    await tester.pumpAndSettle();
    expect(container.read(sessionProvider).active?.components.length, 1);
    expect(
      container
          .read(sessionProvider)
          .active
          ?.components
          .single
          .properties['resistance'],
      220,
    );
  });

  testWidgets('tool pad selects the active tool', (WidgetTester tester) async {
    final container = await _openEditor(tester, 'ed');
    await tester.tap(find.text('Wire'));
    await tester.pumpAndSettle();
    expect(container.read(activeToolProvider).name, 'wire');
  });

  testWidgets('delete tool removes the tapped component', (
    WidgetTester tester,
  ) async {
    final container = await _openEditor(tester, 'ed');
    await tester.tap(find.text('Resistor'));
    await tester.pumpAndSettle();
    await tester.tapAt(tester.getCenter(find.byType(SchematicCanvas)));
    await tester.pumpAndSettle();
    expect(container.read(sessionProvider).active?.components.length, 1);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    // Re-query: the solver error banner shifts layout after placement.
    await tester.tapAt(tester.getCenter(find.byType(SchematicCanvas)));
    await tester.pumpAndSettle();
    expect(container.read(sessionProvider).active?.components, isEmpty);
  });
}

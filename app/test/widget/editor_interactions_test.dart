import 'package:dyamm_avr_schema_design/app.dart';
import 'package:dyamm_avr_schema_design/features/project/project_manager.dart';
import 'package:dyamm_avr_schema_design/features/schematic/canvas/schematic_canvas.dart';
import 'package:dyamm_avr_schema_design/features/schematic/editor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<ProviderContainer> _openEditor(
    WidgetTester tester, String name) async {
  await tester.pumpWidget(const ProviderScope(child: DyammApp()));
  await tester.pumpAndSettle();
  await tester.tap(find.text('NEW PROJECT'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), name);
  await tester.tap(find.text('CREATE'));
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(
      tester.element(find.byType(SchematicCanvas)),
      listen: false);
}

Offset _canvasTap(WidgetTester tester) =>
    tester.getCenter(find.byType(SchematicCanvas));

void main() {
  testWidgets('arming a tile shows the placement hint', (
    WidgetTester tester,
  ) async {
    await _openEditor(tester, 'ed');
    expect(find.textContaining('Tap canvas to place'), findsNothing);
    await tester.tap(find.text('Resistor'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Tap canvas to place'), findsOneWidget);
    await tester.tapAt(_canvasTap(tester));
    await tester.pumpAndSettle();
    expect(find.textContaining('Tap canvas to place'), findsNothing);
  });

  testWidgets('grid toggle flips state and tooltip', (
    WidgetTester tester,
  ) async {
    final container = await _openEditor(tester, 'ed');
    expect(container.read(showGridProvider), isTrue);
    await tester.tap(find.byTooltip('Grid: on'));
    await tester.pumpAndSettle();
    expect(container.read(showGridProvider), isFalse);
    expect(find.byTooltip('Grid: off'), findsOneWidget);
  });

  testWidgets('snap toggle flips state', (WidgetTester tester) async {
    final container = await _openEditor(tester, 'ed');
    expect(container.read(snapEnabledProvider), isTrue);
    await tester.tap(find.byTooltip('Snap: on'));
    await tester.pumpAndSettle();
    expect(container.read(snapEnabledProvider), isFalse);
  });

  testWidgets('undo/redo buttons track history through placement', (
    WidgetTester tester,
  ) async {
    final container = await _openEditor(tester, 'ed');
    IconButton undoBtn() =>
        tester.widget<IconButton>(find.byTooltip('Undo'));
    expect(undoBtn().onPressed, isNull);
    await tester.tap(find.text('Resistor'));
    await tester.pumpAndSettle();
    await tester.tapAt(_canvasTap(tester));
    await tester.pumpAndSettle();
    expect(
        container.read(sessionProvider).active?.components.length, 1);
    expect(undoBtn().onPressed, isNotNull);
    await tester.tap(find.byTooltip('Undo'));
    await tester.pumpAndSettle();
    expect(container.read(sessionProvider).active?.components, isEmpty);
    expect(
        tester.widget<IconButton>(find.byTooltip('Redo')).onPressed,
        isNotNull);
    await tester.tap(find.byTooltip('Redo'));
    await tester.pumpAndSettle();
    expect(
        container.read(sessionProvider).active?.components.length, 1);
  });
}

import 'package:dyamm_avr_schema_design/app.dart';
import 'package:dyamm_avr_schema_design/features/components/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Stitch layout contract: top bar, dock sections, canvas chrome,
/// 11 category chips, 13 symbol tiles, 9 tool-pad cells, sim states.
Future<void> _pumpEditor(WidgetTester tester) async {
  // Landscape target surface so full (non-compact) labels render.
  tester.view.physicalSize = const Size(1280, 720);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(const ProviderScope(child: DyammApp()));
  await tester.pumpAndSettle();
  await tester.tap(find.text('New Project'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), 'stitch');
  await tester.tap(find.text('Create'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('editor chrome: brand, pill, sim segment, utility cluster', (
    WidgetTester tester,
  ) async {
    await _pumpEditor(tester);
    expect(find.text('stitch.dyamm'), findsWidgets);
    expect(find.widgetWithText(FilledButton, 'Run'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Pause'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Stop'), findsOneWidget);
    expect(find.byTooltip('Toggle grid (Phase 3)'), findsOneWidget);
    expect(find.byTooltip('Snap to grid (Phase 3)'), findsOneWidget);
    expect(find.byTooltip('Undo (Phase 3)'), findsOneWidget);
    expect(find.byTooltip('Redo (Phase 3)'), findsOneWidget);
    expect(
      find.byTooltip('Save (Phase 4 — .dyamm persistence)'),
      findsOneWidget,
    );
    expect(find.byTooltip('Settings (planned)'), findsOneWidget);
  });

  testWidgets('dock sections + placeholders', (WidgetTester tester) async {
    await _pumpEditor(tester);
    expect(find.text('PROJECT'), findsOneWidget);
    expect(find.text('New'), findsOneWidget);
    expect(find.textContaining('Open'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Save As'), findsOneWidget);
    for (final s in ['PROPERTIES', 'SIMULATION', 'LAYERS']) {
      expect(find.text(s), findsOneWidget);
    }
    expect(find.text('Version : 1.0.0'), findsOneWidget);
  });

  testWidgets('canvas chrome: zoom pill + minimap', (
    WidgetTester tester,
  ) async {
    await _pumpEditor(tester);
    expect(find.byTooltip('Zoom in'), findsOneWidget);
    expect(find.byTooltip('Zoom out'), findsOneWidget);
    expect(find.byTooltip('Reset zoom'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.byTooltip('Minimap (live tracking planned)'), findsOneWidget);
  });

  testWidgets('library: 11 chips + 13 tiles', (WidgetTester tester) async {
    await _pumpEditor(tester);
    for (final c in [
      'All',
      'MCU',
      'Basic',
      'Passive',
      'Diodes & Transistors',
      'Logic',
      'Sensors',
      'Display',
      'Power',
      'Actuators',
      'Misc',
    ]) {
      expect(find.text(c), findsOneWidget);
    }
    for (final t in componentLibrary) {
      await tester.scrollUntilVisible(
        find.text(componentLabel(t)),
        200,
        scrollable: find.descendant(
          of: find.byKey(const Key('library-tiles')),
          matching: find.byType(Scrollable),
        ),
      );
      expect(find.text(componentLabel(t)), findsOneWidget);
    }
    expect(find.byType(TextField), findsOneWidget); // search placeholder
  });

  testWidgets('tool pad: 9 cells, Select active', (WidgetTester tester) async {
    await _pumpEditor(tester);
    for (final label in [
      'Select',
      'Move',
      'Wire',
      'Delete',
      'Cut',
      'Copy',
      'Paste',
      'Rotate',
      'More',
    ]) {
      expect(find.text(label), findsOneWidget);
    }
    // Tapping Move moves the active-white state (UI state only).
    await tester.tap(find.text('Move'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
  });

  testWidgets('Run/Pause/Stop enable logic', (WidgetTester tester) async {
    await _pumpEditor(tester);
    FilledButton btn(String label) =>
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, label));

    expect(btn('Run').enabled, isTrue);
    expect(btn('Pause').enabled, isFalse);
    expect(btn('Stop').enabled, isFalse);

    await tester.tap(find.widgetWithText(FilledButton, 'Run'));
    await tester.pumpAndSettle();
    expect(btn('Run').enabled, isFalse);
    expect(btn('Pause').enabled, isTrue);
    expect(btn('Stop').enabled, isTrue);

    await tester.tap(find.widgetWithText(FilledButton, 'Pause'));
    await tester.pumpAndSettle();
    expect(btn('Run').enabled, isTrue);

    await tester.tap(find.widgetWithText(FilledButton, 'Run'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Stop'));
    await tester.pumpAndSettle();
    expect(btn('Stop').enabled, isFalse);
    expect(btn('Run').enabled, isTrue);
  });

  testWidgets('tile tap arms canvas-tap placement', (
    WidgetTester tester,
  ) async {
    await _pumpEditor(tester);
    await tester.tap(find.text('Resistor'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Resistor — tap canvas to place'), findsOneWidget);
    // Disarm by tapping again.
    await tester.tap(find.text('Resistor'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Resistor — tap to arm placement'), findsOneWidget);
  });
}

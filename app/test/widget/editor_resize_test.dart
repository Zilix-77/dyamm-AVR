import 'package:dyamm_avr_schema_design/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Landscape-first layout contract: portrait PM, draggable dock + shelf,
/// canvas adapting with its viewport preserved.
Future<void> _setSurface(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Future<void> _openEditor(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: DyammApp()));
  await tester.pumpAndSettle();
  await tester.tap(find.text('New Project'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), 'resize');
  await tester.tap(find.text('Create'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('portrait project manager stays vertical', (
    WidgetTester tester,
  ) async {
    await _setSurface(tester, const Size(400, 800));
    await tester.pumpWidget(const ProviderScope(child: DyammApp()));
    await tester.pumpAndSettle();
    // Vertical file-manager flow intact, no overflow on narrow portrait.
    expect(find.text('DYAMM'), findsNWidgets(2));
    expect(find.text('New Project'), findsOneWidget);
    expect(find.text('RECENT PROJECTS'), findsOneWidget);
    expect(find.text('ON THIS DEVICE'), findsOneWidget);
    expect(find.text('Component Library'), findsNothing);
  });

  testWidgets('dock drag resizes panel, canvas adapts, zoom kept', (
    WidgetTester tester,
  ) async {
    await _setSurface(tester, const Size(1280, 720));
    await _openEditor(tester);

    final dock = find.byKey(const Key('dock-panel'));
    final canvas = find.byKey(const Key('schematic-canvas'));
    final divider = find.byKey(const Key('dock-divider'));
    expect(dock, findsOneWidget);
    expect(divider, findsOneWidget);

    // Zoom in so the viewport-preservation check has a non-default value.
    await tester.tap(find.byTooltip('Zoom in'));
    await tester.pumpAndSettle();
    expect(find.text('125%'), findsOneWidget);

    final dockBefore = tester.getSize(dock);
    final canvasBefore = tester.getSize(canvas);

    await tester.drag(divider, const Offset(60, 0));
    await tester.pumpAndSettle();

    final dockAfter = tester.getSize(dock);
    final canvasAfter = tester.getSize(canvas);
    expect(dockAfter.width, greaterThan(dockBefore.width));
    expect(
      canvasAfter.width,
      lessThan(canvasBefore.width),
      reason: 'canvas yields space to the widened dock',
    );
    expect(
      find.text('125%'),
      findsOneWidget,
      reason: 'resize never touches the zoom matrix',
    );
    expect(find.text('Component Library'), findsOneWidget);
  });

  testWidgets('dock drag clamps at min/max', (WidgetTester tester) async {
    await _setSurface(tester, const Size(1280, 720));
    await _openEditor(tester);

    final dock = find.byKey(const Key('dock-panel'));
    final divider = find.byKey(const Key('dock-divider'));

    await tester.drag(divider, const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(tester.getSize(dock).width, 180);

    await tester.drag(divider, const Offset(900, 0));
    await tester.pumpAndSettle();
    expect(tester.getSize(dock).width, 360);
  });

  testWidgets('shelf drag resizes library, tiles survive', (
    WidgetTester tester,
  ) async {
    await _setSurface(tester, const Size(1280, 720));
    await _openEditor(tester);

    final divider = find.byKey(const Key('shelf-divider'));
    expect(divider, findsOneWidget);

    // Drag up: shelf grows, canvas shrinks vertically.
    final canvasBefore = tester.getSize(
      find.byKey(const Key('schematic-canvas')),
    );
    await tester.drag(divider, const Offset(0, -40));
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byKey(const Key('schematic-canvas'))).height,
      lessThan(canvasBefore.height),
    );
    expect(find.text('Component Library'), findsOneWidget);
    expect(find.text('ATmega32'), findsOneWidget);
  });

  testWidgets('project creation flow reaches the landscape editor', (
    WidgetTester tester,
  ) async {
    await _setSurface(tester, const Size(400, 800));
    await tester.pumpWidget(const ProviderScope(child: DyammApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Project'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'flow');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    // Editor shell proves the PM → editor transition.
    expect(find.text('flow.dyamm'), findsWidgets);
    expect(find.byKey(const Key('dock-divider')), findsOneWidget);
    expect(find.byKey(const Key('shelf-divider')), findsOneWidget);
  });
}

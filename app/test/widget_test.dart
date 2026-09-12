import 'package:dyamm_avr_schema_design/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: DyammApp()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Project Manager is the first screen with empty state', (
    WidgetTester tester,
  ) async {
    await _pump(tester);
    expect(find.text('DYAMM'), findsNWidgets(2)); // app bar + brand mark
    expect(find.text('-AVR'), findsOneWidget);
    expect(find.text('New Project'), findsOneWidget);
    expect(find.text('RECENT PROJECTS'), findsOneWidget);
    expect(find.textContaining('No projects yet'), findsOneWidget);
    // Editor must not show yet.
    expect(find.byTooltip('Close project'), findsNothing);
  });

  testWidgets('empty project name is rejected', (WidgetTester tester) async {
    await _pump(tester);
    await tester.tap(find.text('New Project'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a project name'), findsOneWidget);
    // Still on Project Manager.
    expect(find.text('RECENT PROJECTS'), findsOneWidget);
  });

  testWidgets('create project opens the editor; panel toggles', (
    WidgetTester tester,
  ) async {
    await _pump(tester);
    await tester.tap(find.text('New Project'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '  blink  ');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    // Editor shell with trimmed project name + .dyamm pill.
    expect(find.text('blink.dyamm'), findsWidgets);
    expect(find.byTooltip('Toggle project panel'), findsOneWidget);
    expect(find.text('Component Library'), findsOneWidget);
    // Hamburger collapses the dock.
    await tester.tap(find.byTooltip('Toggle project panel'));
    await tester.pumpAndSettle();
    expect(find.text('PROJECT'), findsNothing);
    await tester.tap(find.byTooltip('Toggle project panel'));
    await tester.pumpAndSettle();
    expect(find.text('PROJECT'), findsOneWidget);
  });
}

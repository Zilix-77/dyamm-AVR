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
    expect(find.text('SimAVR'), findsWidgets);
    expect(find.text('New Project'), findsOneWidget);
    expect(find.text('Recent Projects'), findsOneWidget);
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
    expect(find.text('Recent Projects'), findsOneWidget);
  });

  testWidgets('create project opens the editor; close returns', (
    WidgetTester tester,
  ) async {
    await _pump(tester);
    await tester.tap(find.text('New Project'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '  blink  ');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    // Editor shell with trimmed project name.
    expect(find.text('blink'), findsOneWidget);
    expect(find.byTooltip('Close project'), findsOneWidget);
    expect(find.text('Minimap'), findsOneWidget);
    // Back to Project Manager, project listed under recents.
    await tester.tap(find.byTooltip('Close project'));
    await tester.pumpAndSettle();
    expect(find.text('Recent Projects'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'blink'), findsOneWidget);
  });
}

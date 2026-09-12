import 'package:dyamm_avr_schema_design/app.dart';
import 'package:dyamm_avr_schema_design/features/project/project_manager.dart';
import 'package:dyamm_avr_schema_design/features/project/services/project_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// On-device save round-trip. Runs with `flutter test integration_test -d <device>`.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('save writes a file the app can list and reopen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: DyammApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('NEW PROJECT'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'it1');
    await tester.tap(find.text('CREATE'));
    await tester.pumpAndSettle();

    // Project dock starts open; Save row is visible without toggling.
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Saved to'), findsOneWidget);

    final storage = await FileProjectStorage.appDir();
    expect(await storage.list(), contains('it1'));

    final container = ProviderScope.containerOf(
      tester.element(find.text('it1.dyamm').first),
      listen: false,
    );
    expect(
      await container.read(sessionProvider.notifier).openSaved(storage, 'it1'),
      isTrue,
    );
  });
}

import 'package:dyamm_avr_schema_design/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('workspace shell smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: DyammApp()));
    expect(find.text('dyamm-AVR Schema design'), findsOneWidget);
    expect(find.textContaining('Schematic canvas'), findsOneWidget);
  });
}

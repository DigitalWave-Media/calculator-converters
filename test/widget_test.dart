import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calculator_converters/app.dart';

void main() {
  testWidgets('App main shell rendering test', (WidgetTester tester) async {
    // Build our app under ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: CalculatorApp(),
      ),
    );

    // Verify that "Calculator" and "Converter" tabs are found.
    expect(find.text('Calculator'), findsAtLeast(1));
    expect(find.text('Converter'), findsAtLeast(1));
  });
}

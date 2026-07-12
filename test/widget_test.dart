import 'package:flutter/material.dart';
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

  testWidgets('App navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CalculatorApp(),
      ),
    );

    // Switch to Converter tab (ConverterHubScreen) by dragging the PageView
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    // Scroll until GST card is visible in the GridView
    final gstCard = find.text('GST');
    await tester.scrollUntilVisible(
      gstCard,
      100.0,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();

    // Verify that the GST card is displayed
    expect(gstCard, findsOneWidget);

    // Tap on GST card to navigate to GstCalculatorScreen
    await tester.tap(gstCard);
    await tester.pumpAndSettle();

    // Verify GstCalculatorScreen is shown (it has 'GST Calculator' title in its appBar)
    expect(find.text('GST Calculator'), findsOneWidget);
  });
}

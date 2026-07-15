import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_converters/core/utils/expression_evaluator.dart';
import 'package:calculator_converters/core/utils/number_to_word_converter.dart';

void main() {
  group('Isolate ExpressionEvaluator Tests', () {
    test('evaluateAsync produces correct basic arithmetic output', () async {
      final res = await ExpressionEvaluator.evaluateAsync('15+25×2');
      expect(res, '65');
    });

    test('evaluateAsync handles complex expressions', () async {
      final res = await ExpressionEvaluator.evaluateAsync('100÷4');
      expect(res, '25');
    });

    test('evaluateAsync handles error cases gracefully', () async {
      final res = await ExpressionEvaluator.evaluateAsync('5+*5');
      expect(res, 'Error');
    });
  });

  group('Isolate NumberToWordConverter Tests', () {
    test('toEnglishAsync matches toEnglish', () async {
      final syncVal = NumberToWordConverter.toEnglish(1234567);
      final asyncVal = await NumberToWordConverter.toEnglishAsync(1234567);
      expect(asyncVal, syncVal);
      expect(asyncVal, 'One Million Two Hundred Thirty Four Thousand Five Hundred Sixty Seven');
    });

    test('toHindiAsync matches toHindi', () async {
      final syncVal = NumberToWordConverter.toHindi(10500);
      final asyncVal = await NumberToWordConverter.toHindiAsync(10500);
      expect(asyncVal, syncVal);
      expect(asyncVal, 'दस हजार पाँच सौ');
    });

    test('toBengaliAsync matches toBengali', () async {
      final syncVal = NumberToWordConverter.toBengali(99);
      final asyncVal = await NumberToWordConverter.toBengaliAsync(99);
      expect(asyncVal, syncVal);
      expect(asyncVal, 'নিরানব্বই');
    });
  });
}

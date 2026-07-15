import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_converters/core/utils/expression_evaluator.dart';
import 'package:calculator_converters/core/utils/base_converter.dart';
import 'package:calculator_converters/core/utils/temperature_converter.dart';
import 'package:calculator_converters/core/utils/date_diff_calculator.dart';
import 'package:calculator_converters/core/utils/finance_calculator.dart';
import 'package:calculator_converters/models/finance_input.dart';

void main() {
  group('ExpressionEvaluator tests', () {
    test('Basic addition', () {
      expect(ExpressionEvaluator.evaluate('2+2'), '4');
    });

    test('Order of operations (multiplication first)', () {
      expect(ExpressionEvaluator.evaluate('2+3×4'), '14');
    });

    test('Division and decimals handling', () {
      expect(ExpressionEvaluator.evaluate('10÷4'), '2.5');
    });

    test('Trailing operator truncation', () {
      expect(ExpressionEvaluator.evaluate('5+5+'), '10');
    });

    test('Invalid expression safety', () {
      expect(ExpressionEvaluator.evaluate('5+*5'), 'Error');
    });
  });

  group('BaseConverter radix tests', () {
    test('Decimal to Binary', () {
      expect(BaseConverter.convert('10', 10, 2), '1010');
    });

    test('Hex to Decimal', () {
      expect(BaseConverter.convert('FF', 16, 10), '255');
    });

    test('Binary validation', () {
      expect(BaseConverter.isValidInput('10101', 2), true);
      expect(BaseConverter.isValidInput('10201', 2), false);
    });

    test('Hex validation', () {
      expect(BaseConverter.isValidInput('FFA9', 16), true);
      expect(BaseConverter.isValidInput('FFAZ', 16), false);
    });
  });

  group('TemperatureConverter tests', () {
    test('Celsius to Fahrenheit', () {
      expect(TemperatureConverter.convert(0, 'Celsius', 'Fahrenheit'), 32.0);
      expect(TemperatureConverter.convert(100, 'Celsius', 'Fahrenheit'), 212.0);
    });

    test('Celsius to Kelvin', () {
      expect(TemperatureConverter.convert(0, 'Celsius', 'Kelvin'), 273.15);
    });

    test('Fahrenheit to Celsius', () {
      expect(TemperatureConverter.convert(32, 'Fahrenheit', 'Celsius'), 0.0);
    });

    test('Celsius to Rankine', () {
      expect(TemperatureConverter.convert(0, 'Celsius', 'Rankine'), closeTo(491.67, 0.01));
      expect(TemperatureConverter.convert(-273.15, 'Celsius', 'Rankine'), closeTo(0.0, 0.01));
    });

    test('Rankine to Celsius', () {
      expect(TemperatureConverter.convert(491.67, 'Rankine', 'Celsius'), closeTo(0.0, 0.01));
    });

    test('Celsius to Réaumur', () {
      expect(TemperatureConverter.convert(100, 'Celsius', 'Réaumur'), closeTo(80.0, 0.01));
      expect(TemperatureConverter.convert(0, 'Celsius', 'Réaumur'), closeTo(0.0, 0.01));
    });

    test('Réaumur to Celsius', () {
      expect(TemperatureConverter.convert(80, 'Réaumur', 'Celsius'), closeTo(100.0, 0.01));
    });
  });

  group('DateDiffCalculator calendar-aware tests', () {
    test('Basic years difference', () {
      final from = DateTime(2020, 1, 1);
      final to = DateTime(2025, 1, 1);
      final diff = DateDiffCalculator.calculate(from, to);
      expect(diff.years, 5);
      expect(diff.months, 0);
      expect(diff.days, 0);
    });

    test('Months carryover difference', () {
      final from = DateTime(2020, 1, 15);
      final to = DateTime(2021, 2, 10);
      final diff = DateDiffCalculator.calculate(from, to);
      expect(diff.years, 1);
      expect(diff.months, 0);
      // Since Jan 15 to Feb 10 is less than a month, it should carry days over
      expect(diff.days, 26);
    });
  });

  group('FinanceCalculator tests', () {
    test('Loan EMI computation', () {
      final input = FinanceInput(
        mode: FinanceMode.loan,
        amount: 100000,
        interestRate: 12.0,
        durationYears: 1,
        durationMonths: 0,
      );
      final res = FinanceCalculator.calculate(input);
      // EMI = [100000 * 0.01 * (1.01)^12] / [(1.01)^12 - 1] = 8884.88
      expect(res.emi, closeTo(8884.88, 0.05));
      expect(res.totalInterest, closeTo(6618.55, 0.05));
    });

    test('Lump Sum Investment compound', () {
      final input = FinanceInput(
        mode: FinanceMode.investment,
        amount: 10000,
        interestRate: 12.0,
        durationYears: 1,
        durationMonths: 0,
        investmentType: InvestmentType.oneTime,
      );
      final res = FinanceCalculator.calculate(input);
      // FV = 10000 * (1.01)^12 = 11268.25
      expect(res.futureValue, closeTo(11268.25, 0.05));
    });
  });
}

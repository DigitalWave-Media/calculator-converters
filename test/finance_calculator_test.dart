import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_converters/core/utils/finance_calculator.dart';
import 'package:calculator_converters/models/finance_input.dart';

void main() {
  group('FinanceCalculator — Loan Mode', () {
    test('zero-duration loan returns principal as EMI', () {
      final input = FinanceInput(
        mode: FinanceMode.loan,
        amount: 10000,
        interestRate: 10,
        durationYears: 0,
        durationMonths: 0,
      );
      final result = FinanceCalculator.calculate(input);
      expect(result.futureValue, 10000);
      expect(result.totalInterest, 0);
      expect(result.emi, 10000);
    });

    test('zero-interest loan splits principal evenly across months', () {
      final input = FinanceInput(
        mode: FinanceMode.loan,
        amount: 12000,
        interestRate: 0,
        durationYears: 1,
        durationMonths: 0,
      );
      final result = FinanceCalculator.calculate(input);
      expect(result.emi, 1000); // 12000 / 12
      expect(result.totalInterest, 0);
      expect(result.futureValue, 12000);
    });

    test('standard EMI calculation (10000 @ 12% for 1 year)', () {
      final input = FinanceInput(
        mode: FinanceMode.loan,
        amount: 10000,
        interestRate: 12,
        durationYears: 1,
        durationMonths: 0,
      );
      final result = FinanceCalculator.calculate(input);
      // EMI ≈ 888.49
      expect(result.emi, closeTo(888.49, 0.5));
      expect(result.totalInterest, closeTo(661.85, 1.0));
      expect(result.futureValue, closeTo(10661.85, 1.0));
    });

    test('larger loan (500000 @ 8.5% for 20 years)', () {
      final input = FinanceInput(
        mode: FinanceMode.loan,
        amount: 500000,
        interestRate: 8.5,
        durationYears: 20,
        durationMonths: 0,
      );
      final result = FinanceCalculator.calculate(input);
      // EMI ≈ 4339.12
      expect(result.emi, closeTo(4339.12, 1.0));
      expect(result.totalInterest, greaterThan(0));
      expect(result.futureValue, greaterThan(500000));
    });
  });

  group('FinanceCalculator — Investment Mode (Lump Sum)', () {
    test('zero-duration investment returns principal', () {
      final input = FinanceInput(
        mode: FinanceMode.investment,
        amount: 10000,
        interestRate: 10,
        durationYears: 0,
        durationMonths: 0,
        investmentType: InvestmentType.oneTime,
      );
      final result = FinanceCalculator.calculate(input);
      expect(result.futureValue, 10000);
      expect(result.totalInterest, 0);
    });

    test('lump sum compound interest (10000 @ 10% for 1 year)', () {
      final input = FinanceInput(
        mode: FinanceMode.investment,
        amount: 10000,
        interestRate: 10,
        durationYears: 1,
        durationMonths: 0,
        investmentType: InvestmentType.oneTime,
      );
      final result = FinanceCalculator.calculate(input);
      // FV = 10000 * (1 + 0.10/12)^12 ≈ 11047.13
      expect(result.futureValue, closeTo(11047.13, 1.0));
      expect(result.totalInvestedOrPrincipal, 10000);
      expect(result.totalInterest, closeTo(1047.13, 1.0));
    });
  });

  group('FinanceCalculator — Investment Mode (SIP)', () {
    test('SIP with zero interest returns total deposits', () {
      final input = FinanceInput(
        mode: FinanceMode.investment,
        amount: 5000,
        interestRate: 0,
        durationYears: 1,
        durationMonths: 0,
        investmentType: InvestmentType.recurring,
      );
      final result = FinanceCalculator.calculate(input);
      expect(result.futureValue, 60000); // 5000 * 12
      expect(result.totalInterest, 0);
    });

    test('SIP compound interest (5000/month @ 12% for 2 years)', () {
      final input = FinanceInput(
        mode: FinanceMode.investment,
        amount: 5000,
        interestRate: 12,
        durationYears: 2,
        durationMonths: 0,
        investmentType: InvestmentType.recurring,
      );
      final result = FinanceCalculator.calculate(input);
      expect(result.totalInvestedOrPrincipal, 120000); // 5000 * 24
      expect(result.futureValue, greaterThan(120000));
      expect(result.totalInterest, greaterThan(0));
    });

    test('zero-duration SIP returns principal', () {
      final input = FinanceInput(
        mode: FinanceMode.investment,
        amount: 5000,
        interestRate: 12,
        durationYears: 0,
        durationMonths: 0,
        investmentType: InvestmentType.recurring,
      );
      final result = FinanceCalculator.calculate(input);
      expect(result.futureValue, 5000);
      expect(result.totalInterest, 0);
    });
  });

  group('FinanceInput', () {
    test('totalMonths combines years and months', () {
      const input = FinanceInput(
        mode: FinanceMode.loan,
        amount: 0,
        interestRate: 0,
        durationYears: 2,
        durationMonths: 6,
      );
      expect(input.totalMonths, 30);
    });
  });
}

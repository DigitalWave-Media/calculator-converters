import 'dart:math';
import '../../models/finance_input.dart';

class FinanceCalculator {
  static FinanceResult calculate(FinanceInput input) {
    if (input.mode == FinanceMode.loan) {
      return _calculateLoan(input);
    } else {
      return _calculateInvestment(input);
    }
  }

  static FinanceResult _calculateLoan(FinanceInput input) {
    final double principal = input.amount;
    final int months = input.totalMonths;
    
    if (months <= 0) {
      return FinanceResult(
        futureValue: principal,
        totalInvestedOrPrincipal: principal,
        totalInterest: 0,
        emi: principal,
      );
    }

    final double annualRate = input.interestRate;
    if (annualRate <= 0) {
      final double emi = principal / months;
      return FinanceResult(
        futureValue: principal,
        totalInvestedOrPrincipal: principal,
        totalInterest: 0,
        emi: emi,
      );
    }

    final double monthlyRate = (annualRate / 12) / 100;
    // EMI Formula: [P x r x (1+r)^n] / [(1+r)^n - 1]
    final double compound = pow(1 + monthlyRate, months).toDouble();
    final double emi = (principal * monthlyRate * compound) / (compound - 1);
    final double totalPayment = emi * months;
    final double totalInterest = totalPayment - principal;

    return FinanceResult(
      futureValue: totalPayment,
      totalInvestedOrPrincipal: principal,
      totalInterest: totalInterest,
      emi: emi,
    );
  }

  static FinanceResult _calculateInvestment(FinanceInput input) {
    final double amount = input.amount;
    final int months = input.totalMonths;
    final double annualRate = input.interestRate;
    
    if (months <= 0) {
      return FinanceResult(
        futureValue: amount,
        totalInvestedOrPrincipal: amount,
        totalInterest: 0,
      );
    }

    final double monthlyRate = (annualRate / 12) / 100;

    if (input.investmentType == InvestmentType.oneTime) {
      // Lump Sum Compound Interest: FV = P * (1 + r)^n
      final double futureValue = amount * pow(1 + monthlyRate, months);
      final double totalInterest = futureValue - amount;
      return FinanceResult(
        futureValue: futureValue,
        totalInvestedOrPrincipal: amount,
        totalInterest: totalInterest,
      );
    } else {
      // SIP Compound Interest (Monthly recurring deposit)
      // FV = P * [((1 + r)^n - 1) / r] * (1 + r)
      if (monthlyRate <= 0) {
        final double totalInvested = amount * months;
        return FinanceResult(
          futureValue: totalInvested,
          totalInvestedOrPrincipal: totalInvested,
          totalInterest: 0,
        );
      }
      
      final double compound = pow(1 + monthlyRate, months).toDouble();
      final double futureValue = amount * ((compound - 1) / monthlyRate) * (1 + monthlyRate);
      final double totalInvested = amount * months;
      final double totalInterest = futureValue - totalInvested;

      return FinanceResult(
        futureValue: futureValue,
        totalInvestedOrPrincipal: totalInvested,
        totalInterest: totalInterest,
      );
    }
  }
}

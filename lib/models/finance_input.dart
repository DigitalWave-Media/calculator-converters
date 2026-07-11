enum FinanceMode { loan, investment }
enum InvestmentType { oneTime, recurring }

class FinanceInput {
  final FinanceMode mode;
  final double amount; // Principal or Monthly contribution
  final double interestRate; // Annual interest rate (%)
  final int durationYears;
  final int durationMonths;
  final InvestmentType investmentType; // Only relevant for investment mode

  const FinanceInput({
    required this.mode,
    required this.amount,
    required this.interestRate,
    required this.durationYears,
    required this.durationMonths,
    this.investmentType = InvestmentType.oneTime,
  });

  int get totalMonths => (durationYears * 12) + durationMonths;
}

class FinanceResult {
  final double futureValue; // Total output amount
  final double totalInvestedOrPrincipal;
  final double totalInterest;
  final double emi; // Only relevant for loan mode

  const FinanceResult({
    required this.futureValue,
    required this.totalInvestedOrPrincipal,
    required this.totalInterest,
    this.emi = 0.0,
  });
}

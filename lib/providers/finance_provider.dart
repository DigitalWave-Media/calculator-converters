import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/finance_input.dart';
import '../core/utils/finance_calculator.dart';

class FinanceState {
  final FinanceMode mode;
  final String amount;
  final String interestRate;
  final int durationYears;
  final int durationMonths;
  final InvestmentType investmentType;
  final FinanceResult? result;

  const FinanceState({
    this.mode = FinanceMode.loan,
    this.amount = '10000',
    this.interestRate = '8.5',
    this.durationYears = 1,
    this.durationMonths = 0,
    this.investmentType = InvestmentType.oneTime,
    this.result,
  });

  FinanceState copyWith({
    FinanceMode? mode,
    String? amount,
    String? interestRate,
    int? durationYears,
    int? durationMonths,
    InvestmentType? investmentType,
    FinanceResult? result,
    bool clearResult = false,
  }) {
    return FinanceState(
      mode: mode ?? this.mode,
      amount: amount ?? this.amount,
      interestRate: interestRate ?? this.interestRate,
      durationYears: durationYears ?? this.durationYears,
      durationMonths: durationMonths ?? this.durationMonths,
      investmentType: investmentType ?? this.investmentType,
      result: clearResult ? null : (result ?? this.result),
    );
  }
}

class FinanceNotifier extends Notifier<FinanceState> {
  @override
  FinanceState build() {
    return const FinanceState();
  }

  void setMode(FinanceMode mode) {
    state = state.copyWith(mode: mode, clearResult: true);
  }

  void setAmount(String amount) {
    state = state.copyWith(amount: amount, clearResult: true);
  }

  void setInterestRate(String rate) {
    state = state.copyWith(interestRate: rate, clearResult: true);
  }

  void setDuration(int years, int months) {
    state = state.copyWith(
      durationYears: years,
      durationMonths: months,
      clearResult: true,
    );
  }

  void setInvestmentType(InvestmentType type) {
    state = state.copyWith(investmentType: type, clearResult: true);
  }

  void calculate() {
    final double? amt = double.tryParse(state.amount);
    final double? rate = double.tryParse(state.interestRate);

    if (amt == null || rate == null || amt < 0 || rate < 0) {
      return;
    }

    final input = FinanceInput(
      mode: state.mode,
      amount: amt,
      interestRate: rate,
      durationYears: state.durationYears,
      durationMonths: state.durationMonths,
      investmentType: state.investmentType,
    );

    final res = FinanceCalculator.calculate(input);
    state = state.copyWith(result: res);
  }
}

final financeProvider = NotifierProvider<FinanceNotifier, FinanceState>(
  FinanceNotifier.new,
);

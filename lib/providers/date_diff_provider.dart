import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/date_diff_result.dart';
import '../core/utils/date_diff_calculator.dart';

class DateDiffState {
  final DateTime fromDate;
  final DateTime toDate;
  final DateDiffResult result;

  DateDiffState({
    required this.fromDate,
    required this.toDate,
    required this.result,
  });

  DateDiffState copyWith({
    DateTime? fromDate,
    DateTime? toDate,
    DateDiffResult? result,
  }) {
    return DateDiffState(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      result: result ?? this.result,
    );
  }
}

class DateDiffNotifier extends Notifier<DateDiffState> {
  @override
  DateDiffState build() {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    return DateDiffState(
      fromDate: now,
      toDate: tomorrow,
      result: DateDiffCalculator.calculate(now, tomorrow),
    );
  }

  void setFromDate(DateTime date) {
    final newResult = DateDiffCalculator.calculate(date, state.toDate);
    state = state.copyWith(fromDate: date, result: newResult);
  }

  void setToDate(DateTime date) {
    final newResult = DateDiffCalculator.calculate(state.fromDate, date);
    state = state.copyWith(toDate: date, result: newResult);
  }
}

final dateDiffProvider = NotifierProvider<DateDiffNotifier, DateDiffState>(
  DateDiffNotifier.new,
);

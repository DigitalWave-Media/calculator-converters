import '../../models/date_diff_result.dart';

class DateDiffCalculator {
  static DateDiffResult calculate(DateTime from, DateTime to) {
    // Keep clean normalized dates (remove time component)
    final DateTime startNorm = DateTime(from.year, from.month, from.day);
    final DateTime endNorm = DateTime(to.year, to.month, to.day);

    final bool isNegative = startNorm.isAfter(endNorm);
    final DateTime start = isNegative ? endNorm : startNorm;
    final DateTime end = isNegative ? startNorm : endNorm;

    int years = end.year - start.year;
    int months = end.month - start.month;
    int days = end.day - start.day;

    if (days < 0) {
      months -= 1;
      // Get the number of days in the month preceding the end date
      final DateTime prevMonth = DateTime(end.year, end.month, 0);
      days += prevMonth.day;
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    return DateDiffResult(
      years: years,
      months: months,
      days: days,
      isNegative: isNegative,
    );
  }
}

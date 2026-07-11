class DateDiffResult {
  final int years;
  final int months;
  final int days;
  final bool isNegative;

  const DateDiffResult({
    required this.years,
    required this.months,
    required this.days,
    required this.isNegative,
  });

  @override
  String toString() {
    return '$years years, $months months, $days days';
  }
}

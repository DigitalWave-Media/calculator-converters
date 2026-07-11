import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/date_diff_provider.dart';
import '../../widgets/shared/detail_header.dart';
import '../../widgets/shared/result_card.dart';
import '../../widgets/shared/bottom_drag_handle.dart';

class DateCalculatorScreen extends ConsumerWidget {
  const DateCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dateDiffProvider);
    final notifier = ref.read(dateDiffProvider.notifier);

    final result = state.result;
    final dateFmt = DateFormat('dd MMMM yyyy');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const DetailHeader(title: 'Date Calculator'),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            
            // Date Selection Row: FROM
            _buildDateRow(
              context: context,
              label: 'From Date',
              date: state.fromDate,
              format: dateFmt,
              isHighlight: true,
              onTap: () async {
                final chosen = await showDatePicker(
                  context: context,
                  initialDate: state.fromDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  builder: (context, child) => _buildCustomThemeDatePicker(context, child),
                );
                if (chosen != null) {
                  notifier.setFromDate(chosen);
                }
              },
            ),

            const SizedBox(height: 8),

            // Date Selection Row: TO
            _buildDateRow(
              context: context,
              label: 'To Date',
              date: state.toDate,
              format: dateFmt,
              isHighlight: false,
              onTap: () async {
                final chosen = await showDatePicker(
                  context: context,
                  initialDate: state.toDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  builder: (context, child) => _buildCustomThemeDatePicker(context, child),
                );
                if (chosen != null) {
                  notifier.setToDate(chosen);
                }
              },
            ),

            const SizedBox(height: 16),

            // Result Display Card
            Expanded(
              child: ResultCard(
                title: 'Difference',
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 8),
                    // Grid showing stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn('Years', result.years.toString()),
                        _buildStatColumn('Months', result.months.toString()),
                        _buildStatColumn('Days', result.days.toString()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 12),
                    // Summary Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFooterDate('Start', state.fromDate),
                        const Icon(Icons.arrow_forward, color: AppColors.textLight, size: 20),
                        _buildFooterDate('End', state.toDate),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const BottomDragHandle(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow({
    required BuildContext context,
    required String label,
    required DateTime date,
    required DateFormat format,
    required bool isHighlight,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHighlight ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textGray,
              ),
            ),
            Row(
              children: [
                Text(
                  format.format(date),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isHighlight ? AppColors.primary : AppColors.textDark,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: isHighlight ? AppColors.primary : AppColors.textLight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterDate(String label, DateTime date) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textLight),
        ),
        const SizedBox(height: 2),
        Text(
          DateFormat('yyyy-MM-dd').format(date),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomThemeDatePicker(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          onSurface: AppColors.textDark,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
        ),
      ),
      child: child!,
    );
  }
}

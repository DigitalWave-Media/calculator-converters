import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../models/finance_input.dart';
import '../../providers/finance_provider.dart';
import '../../widgets/shared/detail_header.dart';
import '../../widgets/shared/form_input_field.dart';
import '../../widgets/shared/toggle_radio_pair.dart';
import '../../widgets/shared/cta_button.dart';

class FinanceCalculatorScreen extends ConsumerWidget {
  const FinanceCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(financeProvider);
    final notifier = ref.read(financeProvider.notifier);

    final isLoan = state.mode == FinanceMode.loan;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const DetailHeader(title: 'Finance Calculator'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Loan vs Investment selection
              ToggleRadioPair(
                label: 'Calculation Type',
                value1: 'Loan / EMI',
                value2: 'Investment',
                selectedValue: isLoan ? 'Loan / EMI' : 'Investment',
                onChanged: (val) => notifier.setMode(
                  val == 'Loan / EMI' ? FinanceMode.loan : FinanceMode.investment,
                ),
              ),

              // Dynamic Input field depending on Mode
              FormInputField(
                label: isLoan ? 'Loan Principal Amount' : 'Amount',
                initialValue: state.amount,
                onChanged: (val) => notifier.setAmount(val),
                suffixText: '₹',
              ),

              FormInputField(
                label: 'Annual Interest Rate',
                initialValue: state.interestRate,
                onChanged: (val) => notifier.setInterestRate(val),
                suffixText: '%',
              ),

              // Duration selector row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Duration',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => _showDurationPicker(context, state, notifier),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${state.durationYears} year${state.durationYears != 1 ? 's' : ''} and ${state.durationMonths} month${state.durationMonths != 1 ? 's' : ''}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Investment Type (Lump-sum vs SIP) - animated visibility
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: Visibility(
                  visible: !isLoan,
                  child: ToggleRadioPair(
                    label: 'Investment Type',
                    value1: 'One-time (Lump sum)',
                    value2: 'Recurring (SIP)',
                    selectedValue: state.investmentType == InvestmentType.oneTime
                        ? 'One-time (Lump sum)'
                        : 'Recurring (SIP)',
                    onChanged: (val) => notifier.setInvestmentType(
                      val.contains('One-time') ? InvestmentType.oneTime : InvestmentType.recurring,
                    ),
                  ),
                ),
              ),

              CTAButton(
                label: 'Calculate',
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  notifier.calculate();
                },
              ),

              // Result card
              if (state.result != null)
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLoan ? 'Loan EMI Breakdown' : 'Investment Projections',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const Divider(height: 24),
                      if (isLoan) ...[
                        _buildResultRow(
                          'Monthly EMI',
                          '₹${state.result!.emi.toStringAsFixed(2)}',
                          isHighlight: true,
                        ),
                        const SizedBox(height: 12),
                        _buildResultRow(
                          'Principal Loan Amount',
                          '₹${state.result!.totalInvestedOrPrincipal.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 8),
                        _buildResultRow(
                          'Total Interest Payable',
                          '₹${state.result!.totalInterest.toStringAsFixed(2)}',
                        ),
                        const Divider(height: 24),
                        _buildResultRow(
                          'Total Payment (Principal + Interest)',
                          '₹${state.result!.futureValue.toStringAsFixed(2)}',
                          isBold: true,
                        ),
                      ] else ...[
                        _buildResultRow(
                          'Future Value',
                          '₹${state.result!.futureValue.toStringAsFixed(2)}',
                          isHighlight: true,
                        ),
                        const SizedBox(height: 12),
                        _buildResultRow(
                          'Total Invested Amount',
                          '₹${state.result!.totalInvestedOrPrincipal.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 8),
                        _buildResultRow(
                          'Total Interest Earned',
                          '₹${state.result!.totalInterest.toStringAsFixed(2)}',
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {bool isHighlight = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isHighlight ? 16 : 14,
            fontWeight: isHighlight || isBold ? FontWeight.bold : FontWeight.normal,
            color: isHighlight ? AppColors.primary : AppColors.textDark,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? 22 : 15,
            fontWeight: FontWeight.bold,
            color: isHighlight ? AppColors.primary : AppColors.textDark,
          ),
        ),
      ],
    );
  }

  void _showDurationPicker(BuildContext context, FinanceState state, FinanceNotifier notifier) {
    int selectedY = state.durationYears;
    int selectedM = state.durationMonths;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Duration',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      notifier.setDuration(selectedY, selectedM);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Done', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: Row(
                  children: [
                    // Years Wheel
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Years', style: TextStyle(fontWeight: FontWeight.w600)),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(initialItem: selectedY),
                              itemExtent: 40,
                              onSelectedItemChanged: (index) => selectedY = index,
                              children: List.generate(41, (index) => Center(child: Text('$index'))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Months Wheel
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Months', style: TextStyle(fontWeight: FontWeight.w600)),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(initialItem: selectedM),
                              itemExtent: 40,
                              onSelectedItemChanged: (index) => selectedM = index,
                              children: List.generate(12, (index) => Center(child: Text('$index'))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

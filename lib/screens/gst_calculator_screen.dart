import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/gst_provider.dart';
import '../../widgets/shared/detail_header.dart';
import '../../widgets/shared/chip_selector_row.dart';
import '../../widgets/shared/toggle_radio_pair.dart';
import '../../widgets/shared/numeric_keypad.dart';
import '../../widgets/shared/bottom_drag_handle.dart';

class GstCalculatorScreen extends ConsumerWidget {
  const GstCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gstProvider);
    final notifier = ref.read(gstProvider.notifier);

    final double finalPrice = state.computedFinalPrice;
    final double cgstSgst = state.cgstSgst;
    final double gstAmount = state.gstAmount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const DetailHeader(title: 'GST Calculator'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Add or Subtract GST selection
                  ToggleRadioPair(
                    label: 'Calculation Mode',
                    value1: 'Add GST',
                    value2: 'Remove GST',
                    selectedValue: state.addGst ? 'Add GST' : 'Remove GST',
                    onChanged: (val) => notifier.toggleAddGst(val == 'Add GST'),
                  ),

                  // Labeled input row
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Original Price',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark),
                        ),
                        Text(
                          state.originalPrice.isEmpty ? '0' : state.originalPrice,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // GST Rate Chip selector
                  ChipSelectorRow<int>(
                    label: 'GST Rate',
                    values: const [3, 5, 12, 18, 28],
                    selectedValue: state.gstRate,
                    onChanged: (val) => notifier.setGstRate(val),
                    displayLabel: (val) => '$val%',
                  ),

                  // Results panel
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
                      children: [
                        _buildResultRow('Net Price', '₹${state.priceDouble.toStringAsFixed(2)}'),
                        const SizedBox(height: 12),
                        _buildResultRow('CGST (${(state.gstRate / 2).toStringAsFixed(1)}%)', '₹${cgstSgst.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        _buildResultRow('SGST (${(state.gstRate / 2).toStringAsFixed(1)}%)', '₹${cgstSgst.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        _buildResultRow('Total Tax', '₹${gstAmount.toStringAsFixed(2)}', isBold: true),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Divider(),
                        ),
                        _buildResultRow(
                          state.addGst ? 'Total Price (Gross)' : 'Base Price (Excl. GST)',
                          '₹${finalPrice.toStringAsFixed(2)}',
                          isBold: true,
                          highlight: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          NumericKeypad(
            mode: KeypadMode.standard,
            onKeyPressed: (key) => notifier.onKeypadInput(key),
          ),
          const BottomDragHandle(),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {bool isBold = false, bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: highlight ? AppColors.primary : AppColors.textDark,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: highlight ? 22 : (isBold ? 16 : 14),
            fontWeight: isBold || highlight ? FontWeight.bold : FontWeight.normal,
            color: highlight ? AppColors.primary : AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/gst_provider.dart';
import '../../widgets/shared/detail_header.dart';
import '../../widgets/shared/chip_selector_row.dart';
import '../../widgets/shared/numeric_keypad.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const DetailHeader(title: 'GST Calculator'),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Small compact Add / Remove GST selection
                    _buildCompactToggle(context, state, notifier),

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

                    // GST Rate Chip selector with + icon for custom %
                    ChipSelectorRow<int>(
                      label: 'GST Rate',
                      values: state.availableRates,
                      selectedValue: state.gstRate,
                      onChanged: (val) => notifier.setGstRate(val),
                      displayLabel: (val) => '$val%',
                      trailingWidget: _buildAddRateChip(context, notifier),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCompactToggle(BuildContext context, GstState state, GstNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            _buildCompactSegment(
              label: 'Add GST (+)',
              isSelected: state.addGst,
              onTap: () => notifier.toggleAddGst(true),
            ),
            _buildCompactSegment(
              label: 'Remove GST (-)',
              isSelected: !state.addGst,
              onTap: () => notifier.toggleAddGst(false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactSegment({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddRateChip(BuildContext context, GstNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () => _showAddCustomRateDialog(context, notifier),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 18, color: AppColors.primary),
              SizedBox(width: 2),
              Text(
                'Custom',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCustomRateDialog(BuildContext context, GstNotifier notifier) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add Custom GST Rate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'e.g. 15',
            suffixText: '%',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textGray)),
          ),
          ElevatedButton(
            onPressed: () {
              final val = int.tryParse(controller.text.trim());
              if (val != null && val > 0 && val <= 100) {
                notifier.addCustomRate(val);
                Navigator.of(ctx).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
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


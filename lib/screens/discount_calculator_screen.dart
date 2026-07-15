import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/discount_provider.dart';
import '../../widgets/shared/detail_header.dart';
import '../../widgets/shared/numeric_keypad.dart';

class DiscountCalculatorScreen extends ConsumerWidget {
  const DiscountCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(discountProvider);
    final notifier = ref.read(discountProvider.notifier);

    final double finalPrice = state.computedFinalPrice;
    final double savedVal = state.savedAmount;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const DetailHeader(title: 'Discount Calculator'),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    
                    // Original Price Row
                    _buildInputBox(
                      label: 'Original Price',
                      value: state.originalPrice.isEmpty ? '0' : state.originalPrice,
                      isActive: state.activeField == 1,
                      onTap: () => notifier.onFieldTapped(1),
                    ),
                    
                    const SizedBox(height: 12),
  
                    // Discount Percent Row
                    _buildInputBox(
                      label: 'Discount (%)',
                      value: state.discountPercent.isEmpty ? '0' : state.discountPercent,
                      isActive: state.activeField == 2,
                      onTap: () => notifier.onFieldTapped(2),
                      suffix: '%',
                    ),
                    
                    // Results
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'You Save',
                                style: TextStyle(fontSize: 16, color: AppColors.textLight),
                              ),
                              Text(
                                '₹${savedVal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Final Price',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                              ),
                              Text(
                                '₹${finalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
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

  Widget _buildInputBox({
    required String label,
    required String value,
    required bool isActive,
    required VoidCallback onTap,
    String? suffix,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppColors.primary : AppColors.textDark,
                  ),
                ),
                if (suffix != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    suffix,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isActive ? AppColors.primary : AppColors.textLight,
                    ),
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}

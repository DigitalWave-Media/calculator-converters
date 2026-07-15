import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AdvancedCostModuleWidget extends StatelessWidget {
  final TextEditingController unitCostController;
  final double wastagePercentage;
  final ValueChanged<double> onWastageChanged;
  final FocusNode? unitCostFocusNode;

  const AdvancedCostModuleWidget({
    super.key,
    required this.unitCostController,
    required this.wastagePercentage,
    required this.onWastageChanged,
    this.unitCostFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: isDark ? AppColors.darkSurface : AppColors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.primary.withAlpha(100),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.construction_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Advanced Estimation Parameters',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: unitCostController,
              focusNode: unitCostFocusNode,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Material Unit Cost',
                hintText: 'e.g. 45.00',
                prefixIcon: const Icon(Icons.attach_money_rounded),
                suffixText: 'per unit',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Site Wastage Factor',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${wastagePercentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: wastagePercentage.clamp(0.0, 50.0),
              min: 0.0,
              max: 50.0,
              divisions: 100,
              label: '${wastagePercentage.toStringAsFixed(1)}%',
              activeColor: AppColors.primary,
              onChanged: onWastageChanged,
            ),
            Text(
              'Accounts for site cuts, breakage, spillage, and ordering margins.',
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

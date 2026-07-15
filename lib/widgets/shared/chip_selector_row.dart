import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ChipSelectorRow<T> extends StatelessWidget {
  final String label;
  final List<T> values;
  final T selectedValue;
  final Function(T) onChanged;
  final String Function(T) displayLabel;

  final Widget? trailingWidget;

  const ChipSelectorRow({
    super.key,
    required this.label,
    required this.values,
    required this.selectedValue,
    required this.onChanged,
    required this.displayLabel,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textGray,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...values.map((val) {
                  final isSelected = val == selectedValue;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () => onChanged(val),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.divider.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          displayLabel(val),
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                ?trailingWidget,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

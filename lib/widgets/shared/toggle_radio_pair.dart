import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ToggleRadioPair extends StatelessWidget {
  final String label;
  final String value1;
  final String value2;
  final String selectedValue;
  final Function(String) onChanged;
  final IconData? icon1;
  final IconData? icon2;

  const ToggleRadioPair({
    super.key,
    required this.label,
    required this.value1,
    required this.value2,
    required this.selectedValue,
    required this.onChanged,
    this.icon1,
    this.icon2,
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
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                _buildSegment(context, value1, icon1),
                _buildSegment(context, value2, icon2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment(BuildContext context, String value, IconData? icon) {
    final bool isSelected = selectedValue == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: isSelected ? Colors.white : AppColors.textDark,
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                value,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

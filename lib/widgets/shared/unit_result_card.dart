import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/unit_option.dart';

class UnitResultCard extends StatelessWidget {
  final UnitOption unit;
  final String value;

  const UnitResultCard({
    super.key,
    required this.unit,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameColor = isDark ? Colors.white : AppColors.textDark;
    final abbrColor = isDark ? Colors.white70 : AppColors.textLight;
    final valueColor = isDark ? AppColors.primaryDark : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          // Left side: Unit name and abbreviation inline
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                unit.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: nameColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit.abbreviation,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: abbrColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Right side: Value
          Expanded(
            child: SelectableText(
              value.isEmpty ? '0' : value,
              textAlign: TextAlign.end,
              maxLines: 1,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

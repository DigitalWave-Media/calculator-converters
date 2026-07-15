import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ModeToggleHeaderWidget extends StatelessWidget {
  final bool isAdvancedMode;
  final ValueChanged<bool> onModeChanged;

  const ModeToggleHeaderWidget({
    super.key,
    required this.isAdvancedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkSurface : AppColors.divider,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Mode Indicator Label
          Row(
            children: [
              Icon(
                isAdvancedMode ? Icons.rocket_launch_rounded : Icons.square_foot_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                isAdvancedMode ? 'Advanced Mode' : 'Normal Mode',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),

          // Compact Small Icon Buttons Row
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CompactIconButton(
                  icon: Icons.square_foot_rounded,
                  tooltip: 'Normal Mode: Essential dimensional inputs for raw geometry',
                  isSelected: !isAdvancedMode,
                  onTap: () => onModeChanged(false),
                ),
                const SizedBox(width: 4),
                _CompactIconButton(
                  icon: Icons.rocket_launch_rounded,
                  tooltip: 'Advanced Mode: Full cost estimation & wastage factor parameters',
                  isSelected: isAdvancedMode,
                  onTap: () => onModeChanged(true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  const _CompactIconButton({
    required this.icon,
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(80),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      )
                    ]
                  : [],
            ),
            child: Icon(
              icon,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white60 : Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}

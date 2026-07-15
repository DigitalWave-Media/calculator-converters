import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class KeypadKey extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool isDoubleWidth;

  const KeypadKey({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.keyActive,
    this.textColor = AppColors.textDark,
    this.isDoubleWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDigit = RegExp(r'^\d+$').hasMatch(label) || label == '.' || label == '00';
    final bool isBackspace = label == '⌫';

    final fontWeight = isDigit ? FontWeight.w300 : FontWeight.w400;
    final double fontSize = isDigit ? 26 : 24;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disabledBg = isDark ? AppColors.darkKeyNumeric.withValues(alpha: 0.3) : AppColors.keyDisabled;

    return Expanded(
      flex: isDoubleWidth ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: onPressed == null ? disabledBg : backgroundColor,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: isBackspace
                  ? Icon(
                      Icons.backspace_outlined,
                      size: 24,
                      color: onPressed == null
                          ? AppColors.textLight.withValues(alpha: 0.5)
                          : textColor,
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        color: onPressed == null
                            ? AppColors.textLight.withValues(alpha: 0.5)
                            : textColor,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

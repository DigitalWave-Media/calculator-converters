import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'keypad_key.dart';

enum KeypadMode { standard, hex, temperature, partial }

class NumericKeypad extends StatelessWidget {
  static final RegExp _hexRegExp = RegExp(r'^[A-F]$');
  final KeypadMode mode;
  final Function(String) onKeyPressed;
  final bool Function(String)? isKeyEnabled;

  const NumericKeypad({
    super.key,
    required this.mode,
    required this.onKeyPressed,
    this.isKeyEnabled,
  });

  bool _checkEnabled(String key) {
    if (isKeyEnabled != null) {
      return isKeyEnabled!(key);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final List<List<String>> layout;

    switch (mode) {
      case KeypadMode.standard:
        layout = [
          ['Clear', '⌫', '%', '÷'],
          ['7', '8', '9', '×'],
          ['4', '5', '6', '−'],
          ['1', '2', '3', '+'],
          ['00', '0', '.', '='],
        ];
        break;
      case KeypadMode.hex:
        layout = [
          ['A', 'B', 'C', '⌫'],
          ['D', 'E', 'F', 'Clear'],
          ['7', '8', '9', '00'],
          ['4', '5', '6', '.'],
          ['1', '2', '3', '0'],
        ];
        break;
      case KeypadMode.temperature:
        layout = [
          ['Clear', '⌫', '%', '÷'],
          ['7', '8', '9', '×'],
          ['4', '5', '6', '−'],
          ['1', '2', '3', '+'],
          ['+/-', '0', '.', '='],
        ];
        break;
      case KeypadMode.partial:
        layout = [
          ['Clear', '⌫', '%', '÷'],
          ['7', '8', '9', '×'],
          ['4', '5', '6', '−'],
          ['1', '2', '3', '+'],
          ['00', '0', '.', '='],
        ];
        break;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.darkKeypadBg : const Color(0xFFF5F5F7),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: layout.map((row) {
          return Row(
            children: row.map((key) {
              if (key.isEmpty) {
                return const Expanded(child: SizedBox.shrink());
              }

              // Decide key colors based on light vs dark theme
              Color bg;
              Color text;

              if (isDark) {
                if (key == '=' || key == 'Calculate') {
                  bg = AppColors.darkKeyAction;
                  text = Colors.white;
                } else if (key == 'Clear' ||
                    key == '⌫' ||
                    key == '( )' ||
                    key == '+/-' ||
                    key == '%' ||
                    _isOperator(key) ||
                    _hexRegExp.hasMatch(key)) {
                  bg = AppColors.darkKeyFunction;
                  text = Colors.white;
                } else {
                  bg = AppColors.darkKeyNumeric;
                  text = Colors.white;
                }
              } else {
                if (key == '=' || key == 'Calculate') {
                  bg = AppColors.primary;
                  text = Colors.white;
                } else if (key == 'Clear' || key == '⌫' || key == '( )' || key == '+/-') {
                  bg = Colors.white;
                  text = AppColors.primary;
                } else if (_isOperator(key)) {
                  bg = Colors.white;
                  text = AppColors.primary;
                } else if (key == '%') {
                  bg = Colors.white;
                  text = AppColors.primary.withValues(alpha: 0.4);
                } else {
                  bg = Colors.white;
                  text = AppColors.textDark;
                }
              }

              final bool enabled = _checkEnabled(key);
              final displayLabel = key == 'Clear' ? 'C' : key;

              return KeypadKey(
                label: displayLabel,
                backgroundColor: bg,
                textColor: text,
                onPressed: enabled ? () => onKeyPressed(key) : null,
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  bool _isOperator(String key) {
    return key == '÷' || key == '×' || key == '−' || key == '+';
  }
}

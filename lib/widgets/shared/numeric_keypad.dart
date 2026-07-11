import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'keypad_key.dart';

enum KeypadMode { standard, hex, temperature, partial }

class NumericKeypad extends StatelessWidget {
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
          ['C', '( )', '%', '÷'],
          ['7', '8', '9', '×'],
          ['4', '5', '6', '−'],
          ['1', '2', '3', '+'],
          ['0', '.', '⌫', '='],
        ];
        break;
      case KeypadMode.hex:
        layout = [
          ['A', 'B', 'C', '⌫'],
          ['D', 'E', 'F', 'C'],
          ['7', '8', '9', ''],
          ['4', '5', '6', ''],
          ['1', '2', '3', ''],
          ['0', '.', '', ''],
        ];
        break;
      case KeypadMode.temperature:
        layout = [
          ['7', '8', '9', '⌫'],
          ['4', '5', '6', 'C'],
          ['1', '2', '3', '.'],
          ['+/-', '0', '', ''],
        ];
        break;
      case KeypadMode.partial:
        layout = [
          ['7', '8', '9', '⌫'],
          ['4', '5', '6', 'C'],
          ['1', '2', '3', '.'],
          ['0', '', '', ''],
        ];
        break;
    }

    return Container(
      color: AppColors.keypadBg,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: layout.map((row) {
          return Row(
            children: row.map((key) {
              if (key.isEmpty) {
                return const Expanded(child: SizedBox.shrink());
              }

              // Decide key colors
              Color bg = AppColors.keyActive;
              Color text = AppColors.textDark;

              if (key == '=' || key == 'Calculate') {
                bg = AppColors.primary;
                text = Colors.white;
              } else if (key == 'C' || key == '⌫' || key == 'C' || key == '( )' || key == '%' || key == '+/-') {
                bg = AppColors.keyActive.withValues(alpha: 0.8);
                text = AppColors.primary;
              } else if (_isOperator(key)) {
                bg = AppColors.keyActive.withValues(alpha: 0.8);
                text = AppColors.primary;
              }

              final bool enabled = _checkEnabled(key);

              return KeypadKey(
                label: key,
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

import 'dart:isolate';
import 'package:math_expressions/math_expressions.dart';

class ExpressionEvaluator {
  static Future<String> evaluateAsync(String expression) async {
    return Isolate.run(() => evaluate(expression));
  }

  static String evaluate(String expression) {
    try {
      // Sanitize the expression for the parser
      String sanitized = expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('−', '-'); // Replace minus signs with hyphens

      // Handle empty or trailing operator cases
      if (sanitized.trim().isEmpty) return '';

      // If the expression ends with an operator, strip it for evaluation
      while (sanitized.isNotEmpty && _isOperator(sanitized[sanitized.length - 1])) {
        sanitized = sanitized.substring(0, sanitized.length - 1);
      }

      if (sanitized.isEmpty) return '0';

      GrammarParser p = GrammarParser();
      Expression exp = p.parse(sanitized);
      ContextModel cm = ContextModel();
      double eval = RealEvaluator(cm).evaluate(exp).toDouble();

      if (eval.isNaN) return 'Error';
      if (eval.isInfinite) return 'Infinity';

      // Formatting: if it's an integer, don't show the .0 decimal
      if (eval == eval.roundToDouble()) {
        return eval.round().toString();
      } else {
        // Limit double resolution
        String res = eval.toString();
        if (res.contains('.')) {
          int decIndex = res.indexOf('.');
          if (res.length - decIndex > 9) {
            res = eval.toStringAsFixed(8);
            // Trim trailing zeros
            while (res.endsWith('0')) {
              res = res.substring(0, res.length - 1);
            }
            if (res.endsWith('.')) {
              res = res.substring(0, res.length - 1);
            }
          }
        }
        return res;
      }
    } catch (e) {
      return 'Error';
    }
  }

  static bool _isOperator(String char) {
    return char == '+' || char == '-' || char == '*' || char == '/' || char == '%';
  }
}

import 'dart:math' as math;

import 'package:flutter_riverpod/legacy.dart';

import 'package:math_expressions/math_expressions.dart';

class HistoryItem {
  final String expression;
  final String result;
  final DateTime timestamp;

  const HistoryItem({
    required this.expression,
    required this.result,
    required this.timestamp,
  });
}

class FloatingCalculatorState {
  final String expression;
  final String result;
  final List<HistoryItem> history;
  final bool isScientific;
  final bool isHistoryOpen;
  final bool isDegree;
  final bool isCalculated; // Tracks if the user just pressed '='
  final bool isInverse;

  const FloatingCalculatorState({
    this.expression = '',
    this.result = '',
    this.history = const [],
    this.isScientific = false,
    this.isHistoryOpen = false,
    this.isDegree = false,
    this.isCalculated = false,
    this.isInverse = false,
  });

  FloatingCalculatorState copyWith({
    String? expression,
    String? result,
    List<HistoryItem>? history,
    bool? isScientific,
    bool? isHistoryOpen,
    bool? isDegree,
    bool? isCalculated,
    bool? isInverse,
  }) {
    return FloatingCalculatorState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
      history: history ?? this.history,
      isScientific: isScientific ?? this.isScientific,
      isHistoryOpen: isHistoryOpen ?? this.isHistoryOpen,
      isDegree: isDegree ?? this.isDegree,
      isCalculated: isCalculated ?? this.isCalculated,
      isInverse: isInverse ?? this.isInverse,
    );
  }
}

class FloatingCalculatorNotifier extends StateNotifier<FloatingCalculatorState> {
  FloatingCalculatorNotifier() : super(const FloatingCalculatorState());

  void toggleScientific() {
    state = state.copyWith(isScientific: !state.isScientific);
  }

  void toggleInverse() {
    state = state.copyWith(isInverse: !state.isInverse);
  }

  void toggleHistory() {
    state = state.copyWith(isHistoryOpen: !state.isHistoryOpen);
  }

  void toggleDegree() {
    state = state.copyWith(isDegree: !state.isDegree);
    _evaluateRealTime();
  }

  void clearAll() {
    state = state.copyWith(
      expression: '',
      result: '',
      isCalculated: false,
    );
  }

  void backspace() {
    if (state.expression.isEmpty) return;

    String expr = state.expression;
    // Check if we are deleting functions
    final List<String> functions = ['asin(', 'acos(', 'atan(', 'sin(', 'cos(', 'tan(', 'log(', 'ln(', 'sqrt('];
    bool deletedFunction = false;

    for (final func in functions) {
      if (expr.endsWith(func)) {
        expr = expr.substring(0, expr.length - func.length);
        deletedFunction = true;
        break;
      }
    }

    if (!deletedFunction) {
      expr = expr.substring(0, expr.length - 1);
    }

    state = state.copyWith(
      expression: expr,
      isCalculated: false,
    );
    _evaluateRealTime();
  }

  void append(String value) {
    String currentExpr = state.expression;

    // Define operators once — used in two places below
    const List<String> operators = ['+', '-', '×', '÷', '^', '%', '−'];
    final bool valueIsOperator = operators.contains(value);

    // If a calculation was just completed:
    // - Typing an operator should append to the result
    // - Typing a number or function should replace the expression
    if (state.isCalculated) {
      if (valueIsOperator && state.result.isNotEmpty && state.result != 'Error') {
        currentExpr = state.result;
      } else {
        currentExpr = '';
      }
    }

    // ── NEW ──────────────────────────────────────────────────────────────────
    // If the incoming value is an operator and the expression already ends
    // with one, replace the trailing operator instead of appending.
    if (valueIsOperator &&
        currentExpr.isNotEmpty &&
        operators.contains(currentExpr[currentExpr.length - 1])) {
      currentExpr = currentExpr.substring(0, currentExpr.length - 1);
    }
    // ─────────────────────────────────────────────────────────────────────────

    // Append logical formatting
    String addition = value;
    if (value == 'sin' || value == 'cos' || value == 'tan' ||
        value == 'asin' || value == 'acos' || value == 'atan' ||
        value == 'log' || value == 'ln') {
      addition = '$value(';
    } else if (value == '√') {
      addition = 'sqrt(';
    }

    state = state.copyWith(
      expression: currentExpr + addition,
      isCalculated: false,
    );

    _evaluateRealTime();
  }

  void appendParentheses() {
    String expr = state.expression;
    if (state.isCalculated) {
      expr = '';
    }

    // Determine whether to append '(' or ')'
    int openCount = 0;
    int closeCount = 0;
    for (int i = 0; i < expr.length; i++) {
      if (expr[i] == '(') openCount++;
      if (expr[i] == ')') closeCount++;
    }

    if (openCount > closeCount && expr.isNotEmpty && _isDigitOrRightParen(expr.substring(expr.length - 1))) {
      expr += ')';
    } else {
      expr += '(';
    }

    state = state.copyWith(
      expression: expr,
      isCalculated: false,
    );
    _evaluateRealTime();
  }

  bool _isDigitOrRightParen(String char) {
    if (char == ')') return true;
    final intCode = char.codeUnitAt(0);
    return (intCode >= 48 && intCode <= 57) || char == 'π' || char == 'e' || char == '!';
  }

  void calculate() {
    if (state.expression.isEmpty) return;

    final String finalResult = _evaluateExpression(state.expression);
    if (finalResult == 'Error') {
      state = state.copyWith(
        result: 'Error',
        isCalculated: true,
      );
      return;
    }

    // Append to history if it's a valid non-empty result
    final List<HistoryItem> newHistory = List.from(state.history);
    final bool duplicate = newHistory.any((item) =>
        item.expression == state.expression && item.result == finalResult);
    if (!duplicate) {
      newHistory.insert(
        0,
        HistoryItem(
          expression: state.expression,
          result: finalResult,
          timestamp: DateTime.now(),
        ),
      );
    }

    state = state.copyWith(
      result: finalResult,
      history: newHistory,
      isCalculated: true,
    );
  }

  void loadHistoryItem(HistoryItem item) {
    state = state.copyWith(
      expression: item.expression,
      result: item.result,
      isCalculated: false,
      isHistoryOpen: false,
    );
  }

  void clearHistory() {
    state = state.copyWith(history: const []);
  }

  void _evaluateRealTime() {
    if (state.expression.isEmpty) {
      state = state.copyWith(result: '');
      return;
    }
    final String res = _evaluateExpression(state.expression);
    if (res != 'Error') {
      state = state.copyWith(result: res);
    }
  }

  /// Parses and evaluates an already-preprocessed expression string.
  /// Does NOT apply symbol replacement or trig conversion.
  String _parseAndEval(String processed) {
    try {
      final String safe = processed.replaceAll('()', '(0)');
      final GrammarParser p = GrammarParser();
      final Expression parsedExpr = p.parse(safe);
      final ContextModel cm = ContextModel();
      final double eval = RealEvaluator(cm).evaluate(parsedExpr).toDouble();
      if (eval.isNaN) return 'Error';
      if (eval.isInfinite) return 'Infinity';
      return _formatResult(eval);
    } catch (e) {
      return 'Error';
    }
  }

  String _evaluateExpression(String expr) {
    try {
      String processed = expr;

      // 1. Replace UI symbols with mathematical equivalents
      processed = processed.replaceAll('−', '-');
      processed = processed.replaceAll('×', '*');
      processed = processed.replaceAll('÷', '/');
      processed = processed.replaceAll('π', 'pi');

      // Percentage: e.g. 50% → (50/100)
      processed = processed.replaceAllMapped(
        RegExp(r'(\d+\.?\d*)%'),
        (m) => '(${m[1]}/100)',
      );

      // Base-10 log: UI 'log' → library 'log(10, x)'
      processed = processed.replaceAll('log(', 'log(10,');

      // 2. Pre-process trigonometric degree/radian conversion
      if (state.isDegree) {
        processed = _convertTrigToRad(processed);
      }

      // 3. Pre-process factorials (e.g. 5! or (2+3)!)
      processed = _evaluateFactorials(processed);

      // Handle empty parentheses, e.g. "()" or empty arguments that would crash Parser
      processed = processed.replaceAll('()', '(0)');

      // 4. Parse and evaluate using math_expressions
      final GrammarParser p = GrammarParser();
      final Expression parsedExpr = p.parse(processed);
      final ContextModel cm = ContextModel();
      final double eval = RealEvaluator(cm).evaluate(parsedExpr).toDouble();

      if (eval.isNaN) return 'Error';
      if (eval.isInfinite) return 'Infinity';

      // 5. Clean up display output (remove trailing .0, round very close double errors)
      return _formatResult(eval);
    } catch (e) {
      return 'Error';
    }
  }

  String _formatResult(double val) {
    // If the value is very close to an integer, round it to fix float representation errors
    if ((val - val.round()).abs() < 1e-11) {
      return val.round().toString();
    }
    
    // Check if scientific notation is needed for extremely large/small values
    if (val.abs() > 1e12 || (val.abs() < 1e-6 && val != 0.0)) {
      return val.toStringAsExponential(5);
    }

    String str = val.toStringAsFixed(8);
    // Strip trailing zeroes
    while (str.contains('.') && (str.endsWith('0') || str.endsWith('.'))) {
      str = str.substring(0, str.length - 1);
    }
    return str;
  }

  String _convertTrigToRad(String expr) {
    final functions = ['sin', 'cos', 'tan'];
    String result = expr;
    for (final func in functions) {
      int idx = 0;
      while ((idx = result.indexOf('$func(', idx)) != -1) {
        // Need to make sure it's not asin, acos, atan
        if (idx > 0 && result[idx - 1] == 'a') {
          idx += func.length + 1;
          continue;
        }
        
        int startArg = idx + func.length + 1;
        int endArg = _findMatchingParenthesis(result, startArg - 1);
        if (endArg == -1) {
          break; // Unclosed parenthesis
        }
        String arg = result.substring(startArg, endArg);
        String processedArg = _convertTrigToRad(arg); // Process nested trig
        String replacement = '($processedArg * (${math.pi / 180.0}))';
        result = result.replaceRange(startArg, endArg, replacement);
        idx = startArg + replacement.length + 1;
      }
    }
    
    // Convert output of asin, acos, atan to degrees if needed
    final invFunctions = ['asin', 'acos', 'atan'];
    for (final func in invFunctions) {
      int idx = 0;
      while ((idx = result.indexOf('$func(', idx)) != -1) {
        int startArg = idx + func.length + 1;
        int endArg = _findMatchingParenthesis(result, startArg - 1);
        if (endArg == -1) break;
        
        String replacement = '(($func(${result.substring(startArg, endArg)})) * (180.0 / ${math.pi}))';
        result = result.replaceRange(idx, endArg + 1, replacement);
        idx = idx + replacement.length;
      }
    }
    
    return result;
  }

  int _findMatchingParenthesis(String str, int openPos) {
    int closePos = openPos;
    int counter = 1;
    while (counter > 0) {
      closePos++;
      if (closePos >= str.length) {
        return -1;
      }
      if (str[closePos] == '(') {
        counter++;
      } else if (str[closePos] == ')') {
        counter--;
      }
    }
    return closePos;
  }

  String _evaluateFactorials(String expr) {
    String result = expr;
    int idx;
    while ((idx = result.indexOf('!')) != -1) {
      // Find the operand for the factorial to the left of '!'
      if (idx == 0) {
        return 'Error'; // Invalid expression: starts with !
      }

      int start = idx - 1;
      if (result[start] == ')') {
        // Operand is parenthesized, e.g., (3+2)!
        int openParen = _findMatchingOpenParenthesis(result, start);
        if (openParen == -1) return 'Error';
        
        // Walk back past any function name preceding the opening paren
        int funcStart = openParen;
        while (funcStart > 0 && RegExp(r'[a-zA-Z]').hasMatch(result[funcStart - 1])) {
          funcStart--;
        }

        String subExpr = result.substring(openParen, start + 1);
        // Evaluate the sub-expression first
        String subResult = _parseAndEval(subExpr);
        if (subResult == 'Error' || subResult == 'Infinity') return 'Error';
        
        double val = double.tryParse(subResult) ?? 0.0;
        double factVal = _factorial(val);
        if (factVal.isNaN) return 'Error';
        
        result = result.replaceRange(funcStart, idx + 1, factVal.toString());
      } else {
        // Operand is a simple number or constant
        while (start >= 0 && _isFactorialOperandChar(result[start])) {
          start--;
        }
        start++; // Move back to the first operand character
        
        String numStr = result.substring(start, idx);
        double val = double.tryParse(numStr) ?? 0.0;
        double factVal = _factorial(val);
        if (factVal.isNaN) return 'Error';
        
        result = result.replaceRange(start, idx + 1, factVal.toString());
      }
    }
    return result;
  }

  bool _isFactorialOperandChar(String char) {
    final code = char.codeUnitAt(0);
    // Allow digits, decimals, e, and pi references
    return (code >= 48 && code <= 57) || char == '.' || char == 'e' || char == 'p' || char == 'i';
  }

  int _findMatchingOpenParenthesis(String str, int closePos) {
    int openPos = closePos;
    int counter = 1;
    while (counter > 0) {
      openPos--;
      if (openPos < 0) {
        return -1;
      }
      if (str[openPos] == ')') {
        counter++;
      } else if (str[openPos] == '(') {
        counter--;
      }
    }
    return openPos;
  }

  double _factorial(double n) {
    if (n < 0 || n > 170) return double.nan; // Factorial limits in double
    if (n != n.roundToDouble()) return double.nan; // non-integer input → Error
    if (n == 0 || n == 1) return 1.0;
    double res = 1.0;
    int val = n.toInt();
    for (int i = 2; i <= val; i++) {
      res *= i;
    }
    return res;
  }
}

final floatingCalculatorProvider = StateNotifierProvider<FloatingCalculatorNotifier, FloatingCalculatorState>((ref) {
  return FloatingCalculatorNotifier();
});
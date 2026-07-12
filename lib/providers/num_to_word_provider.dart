import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/number_to_word_converter.dart';
import '../core/utils/expression_evaluator.dart';

class NumToWordState {
  final String inputExpression;

  const NumToWordState({
    this.inputExpression = '',
  });

  int get evaluatedValue {
    if (inputExpression.isEmpty) return 0;
    final evaluatedStr = ExpressionEvaluator.evaluate(inputExpression);
    if (evaluatedStr == 'Error' || evaluatedStr.isEmpty) return 0;
    
    final doubleVal = double.tryParse(evaluatedStr) ?? 0.0;
    return doubleVal.clamp(-900000000000000.0, 900000000000000.0).round();
  }

  String get englishWord {
    if (inputExpression.isEmpty) return 'Zero';
    final val = evaluatedValue;
    return NumberToWordConverter.toEnglish(val);
  }

  String get hindiWord {
    if (inputExpression.isEmpty) return 'शून्य';
    final val = evaluatedValue;
    return NumberToWordConverter.toHindi(val);
  }

  String get bengaliWord {
    if (inputExpression.isEmpty) return 'শূন্য';
    final val = evaluatedValue;
    return NumberToWordConverter.toBengali(val);
  }

  NumToWordState copyWith({
    String? inputExpression,
  }) {
    return NumToWordState(
      inputExpression: inputExpression ?? this.inputExpression,
    );
  }
}

class NumToWordNotifier extends Notifier<NumToWordState> {
  @override
  NumToWordState build() {
    return const NumToWordState();
  }

  bool _canAppendDecimal(String expression) {
    final RegExp opRegExp = RegExp(r'[+\−\×\÷%]');
    final matches = opRegExp.allMatches(expression);
    if (matches.isEmpty) {
      return !expression.contains('.');
    } else {
      final lastOpIndex = matches.last.start;
      final lastNumberSegment = expression.substring(lastOpIndex + 1);
      return !lastNumberSegment.contains('.');
    }
  }

  void onKeypadInput(String key) {
    String currentVal = state.inputExpression;

    if (key == 'C' || key == 'Clear') {
      currentVal = '';
    } else if (key == '⌫') {
      if (currentVal.isNotEmpty) {
        currentVal = currentVal.substring(0, currentVal.length - 1);
      }
    } else if (key == '=') {
      currentVal = ExpressionEvaluator.evaluate(currentVal);
    } else {
      if (key == '.') {
        if (!_canAppendDecimal(currentVal)) return;
      }
      
      final List<String> ops = ['+', '−', '×', '÷', '%'];
      if (ops.contains(key)) {
        if (currentVal.isEmpty) {
          if (key != '−') return;
        } else {
          final lastChar = currentVal[currentVal.length - 1];
          if (ops.contains(lastChar)) {
            currentVal = currentVal.substring(0, currentVal.length - 1) + key;
            state = state.copyWith(inputExpression: currentVal);
            return;
          }
        }
      } else {
        if (currentVal.length >= 15) return;
      }
      
      currentVal += key;
    }

    state = state.copyWith(inputExpression: currentVal);
  }
}

final numToWordProvider = NotifierProvider<NumToWordNotifier, NumToWordState>(
  NumToWordNotifier.new,
);

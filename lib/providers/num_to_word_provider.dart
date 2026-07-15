import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/number_to_word_converter.dart';
import '../core/utils/expression_evaluator.dart';

class NumToWordState {
  final String inputExpression;
  final int evaluatedValue;
  final String englishWord;
  final String hindiWord;
  final String bengaliWord;

  const NumToWordState({
    this.inputExpression = '',
    this.evaluatedValue = 0,
    this.englishWord = 'Zero',
    this.hindiWord = 'शून्य',
    this.bengaliWord = 'শূন্য',
  });

  NumToWordState copyWith({
    String? inputExpression,
    int? evaluatedValue,
    String? englishWord,
    String? hindiWord,
    String? bengaliWord,
  }) {
    return NumToWordState(
      inputExpression: inputExpression ?? this.inputExpression,
      evaluatedValue: evaluatedValue ?? this.evaluatedValue,
      englishWord: englishWord ?? this.englishWord,
      hindiWord: hindiWord ?? this.hindiWord,
      bengaliWord: bengaliWord ?? this.bengaliWord,
    );
  }
}

class NumToWordNotifier extends Notifier<NumToWordState> {
  @override
  NumToWordState build() {
    return const NumToWordState();
  }

  static NumToWordState computeState(String inputExpression) {
    if (inputExpression.isEmpty) {
      return const NumToWordState(inputExpression: '');
    }
    final evaluatedStr = ExpressionEvaluator.evaluate(inputExpression);
    if (evaluatedStr == 'Error' || evaluatedStr.isEmpty) {
      return NumToWordState(
        inputExpression: inputExpression,
        evaluatedValue: 0,
        englishWord: 'Zero',
        hindiWord: 'शून्य',
        bengaliWord: 'শূন্য',
      );
    }

    final doubleVal = double.tryParse(evaluatedStr) ?? 0.0;
    final val = doubleVal.clamp(-900000000000000.0, 900000000000000.0).round();
    return NumToWordState(
      inputExpression: inputExpression,
      evaluatedValue: val,
      englishWord: NumberToWordConverter.toEnglish(val),
      hindiWord: NumberToWordConverter.toHindi(val),
      bengaliWord: NumberToWordConverter.toBengali(val),
    );
  }

  Future<void> _updateStateAsync(String currentVal) async {
    final syncState = computeState(currentVal);
    state = syncState;

    if (currentVal.isEmpty || syncState.englishWord == 'Zero' && syncState.evaluatedValue == 0) {
      return;
    }

    final val = syncState.evaluatedValue;
    final results = await Future.wait([
      NumberToWordConverter.toEnglishAsync(val),
      NumberToWordConverter.toHindiAsync(val),
      NumberToWordConverter.toBengaliAsync(val),
    ]);

    if (state.inputExpression == currentVal) {
      state = state.copyWith(
        englishWord: results[0],
        hindiWord: results[1],
        bengaliWord: results[2],
      );
    }
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
            _updateStateAsync(currentVal);
            return;
          }
        }
      } else {
        if (currentVal.length >= 15) return;
      }
      
      currentVal += key;
    }

    _updateStateAsync(currentVal);
  }
}

final numToWordProvider = NotifierProvider<NumToWordNotifier, NumToWordState>(
  NumToWordNotifier.new,
);

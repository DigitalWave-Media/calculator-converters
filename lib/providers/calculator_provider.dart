import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/history_entry.dart';
import '../services/history_storage_service.dart';
import '../core/utils/expression_evaluator.dart';

final historyStorageProvider = Provider<HistoryStorageService>((ref) {
  return HistoryStorageService();
});

class CalculatorState {
  final String currentInput;
  final String result;
  final List<HistoryEntry> history;

  const CalculatorState({
    this.currentInput = '',
    this.result = '',
    this.history = const [],
  });

  CalculatorState copyWith({
    String? currentInput,
    String? result,
    List<HistoryEntry>? history,
  }) {
    return CalculatorState(
      currentInput: currentInput ?? this.currentInput,
      result: result ?? this.result,
      history: history ?? this.history,
    );
  }
}

class CalculatorNotifier extends Notifier<CalculatorState> {
  @override
  CalculatorState build() {
    _loadHistory();
    return const CalculatorState();
  }

  Future<void> _loadHistory() async {
    final storage = ref.read(historyStorageProvider);
    final list = await storage.getHistory();
    state = state.copyWith(history: list);
  }

  void onDigitPressed(String digit) {
    state = state.copyWith(
      currentInput: state.currentInput + digit,
    );
    _computeLiveResult();
  }

  void onOperatorPressed(String op) {
    String input = state.currentInput;
    if (input.isEmpty) {
      if (op == '−') {
        state = state.copyWith(currentInput: '−');
      }
      return;
    }

    final lastChar = input[input.length - 1];
    if (_isOperator(lastChar)) {
      input = input.substring(0, input.length - 1) + op;
    } else {
      input += op;
    }

    state = state.copyWith(currentInput: input);
  }

  void onEquals() {
    if (state.currentInput.isEmpty) return;
    
    final finalResult = ExpressionEvaluator.evaluate(state.currentInput);
    if (finalResult == 'Error') {
      state = state.copyWith(result: 'Error');
      return;
    }

    final newEntry = HistoryEntry(
      expression: state.currentInput,
      result: finalResult,
      timestamp: DateTime.now(),
    );

    final updatedHistory = [newEntry, ...state.history];
    state = state.copyWith(
      currentInput: finalResult,
      result: '',
      history: updatedHistory,
    );

    ref.read(historyStorageProvider).saveHistory(updatedHistory);
  }

  void onClear() {
    state = state.copyWith(currentInput: '', result: '');
  }

  void onBackspace() {
    final input = state.currentInput;
    if (input.isEmpty) return;

    final updatedInput = input.substring(0, input.length - 1);
    state = state.copyWith(currentInput: updatedInput);
    _computeLiveResult();
  }

  void clearAllHistory() {
    state = state.copyWith(history: const []);
    ref.read(historyStorageProvider).clearHistory();
  }

  void setInputFromHistory(String expression) {
    state = state.copyWith(currentInput: expression);
    _computeLiveResult();
  }

  void _computeLiveResult() {
    final input = state.currentInput;
    if (input.isEmpty) {
      state = state.copyWith(result: '');
      return;
    }

    final lastChar = input[input.length - 1];
    if (!_isOperator(lastChar) && lastChar != '(') {
      final preview = ExpressionEvaluator.evaluate(input);
      state = state.copyWith(result: preview == 'Error' ? '' : preview);
    }
  }

  bool _isOperator(String char) {
    return char == '+' || char == '−' || char == '×' || char == '÷' || char == '%';
  }
}

final calculatorProvider = NotifierProvider<CalculatorNotifier, CalculatorState>(
  CalculatorNotifier.new,
);

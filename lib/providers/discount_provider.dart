import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/expression_evaluator.dart';

class DiscountState {
  final String originalPrice;
  final String discountPercent;
  final int activeField; // 1 = originalPrice, 2 = discountPercent

  const DiscountState({
    this.originalPrice = '',
    this.discountPercent = '',
    this.activeField = 1,
  });

  double get priceDouble {
    final evaluated = ExpressionEvaluator.evaluate(originalPrice);
    return double.tryParse(evaluated) ?? 0.0;
  }
  double get discountDouble {
    final evaluated = ExpressionEvaluator.evaluate(discountPercent);
    return double.tryParse(evaluated) ?? 0.0;
  }

  double get computedFinalPrice {
    final double p = priceDouble;
    final double d = discountDouble;
    if (p == 0.0) return 0.0;
    return p * (1 - d / 100);
  }

  double get savedAmount {
    return priceDouble - computedFinalPrice;
  }

  DiscountState copyWith({
    String? originalPrice,
    String? discountPercent,
    int? activeField,
  }) {
    return DiscountState(
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      activeField: activeField ?? this.activeField,
    );
  }
}

class DiscountNotifier extends Notifier<DiscountState> {
  @override
  DiscountState build() {
    return const DiscountState();
  }

  void onFieldTapped(int field) {
    state = state.copyWith(activeField: field);
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
    final int active = state.activeField;
    String currentVal = active == 1 ? state.originalPrice : state.discountPercent;

    if (key == 'C' || key == 'Clear') {
      currentVal = '';
    } else if (key == '⌫') {
      if (currentVal.isNotEmpty) {
        currentVal = currentVal.substring(0, currentVal.length - 1);
      }
    } else if (key == '=') {
      final evaluated = ExpressionEvaluator.evaluate(currentVal);
      if (active == 2) {
        final double? parsedVal = double.tryParse(evaluated);
        if (parsedVal != null && parsedVal > 100.0) {
          currentVal = '100';
        } else {
          currentVal = evaluated;
        }
      } else {
        currentVal = evaluated;
      }
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
            if (active == 1) {
              state = state.copyWith(originalPrice: currentVal);
            } else {
              state = state.copyWith(discountPercent: currentVal);
            }
            return;
          }
        }
      } else {
        // If typing digits in discount field, enforce the 100% check on plain numbers
        if (active == 2 && !currentVal.contains(RegExp(r'[+\−\×\÷%]'))) {
          final double? testVal = double.tryParse(currentVal + key);
          if (testVal != null && testVal > 100.0) return;
        }
      }
      currentVal += key;
    }

    if (active == 1) {
      state = state.copyWith(originalPrice: currentVal);
    } else {
      state = state.copyWith(discountPercent: currentVal);
    }
  }
}

final discountProvider = NotifierProvider<DiscountNotifier, DiscountState>(
  DiscountNotifier.new,
);

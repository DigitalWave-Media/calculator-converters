import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/expression_evaluator.dart';

class GstState {
  final String originalPrice;
  final int gstRate; // Percentage (3, 5, 12, 18, 28, or custom)
  final bool addGst; // True to add GST, false to remove/extract GST
  final List<int> customRates;

  static const List<int> defaultRates = [3, 5, 12, 18, 28];

  const GstState({
    this.originalPrice = '',
    this.gstRate = 18,
    this.addGst = true,
    this.customRates = const [],
  });

  List<int> get availableRates {
    final list = [...defaultRates];
    for (final r in customRates) {
      if (!list.contains(r)) {
        list.add(r);
      }
    }
    list.sort();
    return list;
  }

  double get priceDouble {
    final evaluated = ExpressionEvaluator.evaluate(originalPrice);
    return double.tryParse(evaluated) ?? 0.0;
  }

  double get computedFinalPrice {
    final double p = priceDouble;
    if (p == 0.0) return 0.0;
    if (addGst) {
      return p * (1 + gstRate / 100);
    } else {
      return p / (1 + gstRate / 100);
    }
  }

  double get gstAmount {
    return (computedFinalPrice - priceDouble).abs();
  }

  double get cgstSgst {
    return gstAmount / 2;
  }

  GstState copyWith({
    String? originalPrice,
    int? gstRate,
    bool? addGst,
    List<int>? customRates,
  }) {
    return GstState(
      originalPrice: originalPrice ?? this.originalPrice,
      gstRate: gstRate ?? this.gstRate,
      addGst: addGst ?? this.addGst,
      customRates: customRates ?? this.customRates,
    );
  }
}

class GstNotifier extends Notifier<GstState> {
  @override
  GstState build() {
    return const GstState();
  }

  void setOriginalPrice(String price) {
    state = state.copyWith(originalPrice: price);
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
    String currentVal = state.originalPrice;

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
            state = state.copyWith(originalPrice: currentVal);
            return;
          }
        }
      }
      currentVal += key;
    }

    state = state.copyWith(originalPrice: currentVal);
  }

  void setGstRate(int rate) {
    state = state.copyWith(gstRate: rate);
  }

  void addCustomRate(int rate) {
    if (rate <= 0) return;
    final List<int> updatedCustom = List.from(state.customRates);
    if (!GstState.defaultRates.contains(rate) && !updatedCustom.contains(rate)) {
      updatedCustom.add(rate);
    }
    state = state.copyWith(
      customRates: updatedCustom,
      gstRate: rate,
    );
  }

  void toggleAddGst(bool add) {
    state = state.copyWith(addGst: add);
  }
}

final gstProvider = NotifierProvider<GstNotifier, GstState>(
  GstNotifier.new,
);

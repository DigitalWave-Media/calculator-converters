import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/currency_option.dart';
import '../services/currency_rate_service.dart';
import '../core/utils/expression_evaluator.dart';

final currencyRateServiceProvider = Provider<CurrencyRateService>((ref) {
  return CurrencyRateService();
});

class CurrencyState {
  final List<CurrencyOption> allCurrencies; // All rates fetched
  final List<CurrencyOption> selectedCurrencies; // Displayed currency rows
  final String activeIsoCode; // Currently editing currency ISO code
  final String activeValue; // Number string in editing field
  final bool isLoading;
  final String? errorMessage;
  final bool isLiveRates; // true if rates came from a live API call
  final DateTime? ratesTimestamp; // When the cached rates were last fetched

  const CurrencyState({
    this.allCurrencies = const [],
    this.selectedCurrencies = const [],
    this.activeIsoCode = 'USD',
    this.activeValue = '',
    this.isLoading = false,
    this.errorMessage,
    this.isLiveRates = true,
    this.ratesTimestamp,
  });

  CurrencyState copyWith({
    List<CurrencyOption>? allCurrencies,
    List<CurrencyOption>? selectedCurrencies,
    String? activeIsoCode,
    String? activeValue,
    bool? isLoading,
    String? errorMessage,
    bool? isLiveRates,
    DateTime? ratesTimestamp,
  }) {
    return CurrencyState(
      allCurrencies: allCurrencies ?? this.allCurrencies,
      selectedCurrencies: selectedCurrencies ?? this.selectedCurrencies,
      activeIsoCode: activeIsoCode ?? this.activeIsoCode,
      activeValue: activeValue ?? this.activeValue,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isLiveRates: isLiveRates ?? this.isLiveRates,
      ratesTimestamp: ratesTimestamp ?? this.ratesTimestamp,
    );
  }
}

class CurrencyNotifier extends Notifier<CurrencyState> {
  @override
  CurrencyState build() {
    Future.microtask(refreshRates);
    return const CurrencyState();
  }

  Future<void> refreshRates() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await ref.read(currencyRateServiceProvider).fetchRates();
      final list = result.rates;
      
      List<CurrencyOption> selected = state.selectedCurrencies;
      if (selected.isEmpty) {
        final usd = list.firstWhere((c) => c.isoCode == 'USD', orElse: () => CurrencyRateService.defaultRates[0]);
        final eur = list.firstWhere((c) => c.isoCode == 'EUR', orElse: () => CurrencyRateService.defaultRates[1]);
        final inr = list.firstWhere((c) => c.isoCode == 'INR', orElse: () => CurrencyRateService.defaultRates[3]);
        selected = [usd, eur, inr];
      } else {
        selected = selected.map((s) {
          final fresh = list.firstWhere((c) => c.isoCode == s.isoCode, orElse: () => s);
          return fresh;
        }).toList();
      }

      state = state.copyWith(
        allCurrencies: list,
        selectedCurrencies: selected,
        isLoading: false,
        isLiveRates: result.isLive,
        ratesTimestamp: result.cacheTimestamp,
        errorMessage: result.isLive ? null : 'Using cached rates',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update rates',
      );
    }
  }

  void selectActiveCurrency(String isoCode, String currentValue) {
    state = state.copyWith(
      activeIsoCode: isoCode,
      activeValue: currentValue,
    );
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
    String currentVal = state.activeValue;

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
            state = state.copyWith(activeValue: currentVal);
            return;
          }
        }
      }
      currentVal += key;
    }

    state = state.copyWith(activeValue: currentVal);
  }

  String getDisplayValue(String isoCode) {
    if (state.activeValue.isEmpty) return '';
    
    final activeRateOption = state.allCurrencies.firstWhere(
      (c) => c.isoCode == state.activeIsoCode,
      orElse: () => CurrencyRateService.defaultRates[0],
    );
    final targetRateOption = state.allCurrencies.firstWhere(
      (c) => c.isoCode == isoCode,
      orElse: () => CurrencyRateService.defaultRates[0],
    );

    final evaluated = ExpressionEvaluator.evaluate(state.activeValue);
    final double activeVal = double.tryParse(evaluated) ?? 0.0;
    if (activeVal == 0.0) return '0';

    final double usdValue = activeVal / activeRateOption.rate;
    final double convertedValue = usdValue * targetRateOption.rate;

    return _formatDouble(convertedValue);
  }

  void updateSelectedCurrency(int index, CurrencyOption newCurrency) {
    final updated = List<CurrencyOption>.from(state.selectedCurrencies);
    updated[index] = newCurrency;
    
    String activeIso = state.activeIsoCode;
    if (state.selectedCurrencies[index].isoCode == state.activeIsoCode) {
      activeIso = newCurrency.isoCode;
    }

    state = state.copyWith(
      selectedCurrencies: updated,
      activeIsoCode: activeIso,
    );
  }

  void addSelectedCurrency(CurrencyOption currency) {
    if (state.selectedCurrencies.any((c) => c.isoCode == currency.isoCode)) return;

    state = state.copyWith(
      selectedCurrencies: [...state.selectedCurrencies, currency],
    );
  }

  void removeSelectedCurrency(int index) {
    if (state.selectedCurrencies.length <= 1) return;

    final updated = List<CurrencyOption>.from(state.selectedCurrencies);
    final removed = updated.removeAt(index);

    String activeIso = state.activeIsoCode;
    String activeVal = state.activeValue;
    if (removed.isoCode == state.activeIsoCode) {
      activeIso = updated[0].isoCode;
      activeVal = getDisplayValue(activeIso);
    }

    state = state.copyWith(
      selectedCurrencies: updated,
      activeIsoCode: activeIso,
      activeValue: activeVal,
    );
  }

  String _formatDouble(double val) {
    if (val.isNaN) return 'Error';
    if (val.isInfinite) return 'Infinity';
    if (val == val.roundToDouble()) {
      return val.round().toString();
    }
    String str = val.toString();
    if (str.contains('.')) {
      int idx = str.indexOf('.');
      if (str.length - idx > 5) {
        str = val.toStringAsFixed(4);
        while (str.endsWith('0')) {
          str = str.substring(0, str.length - 1);
        }
        if (str.endsWith('.')) {
          str = str.substring(0, str.length - 1);
        }
      }
    }
    return str;
  }
}

final currencyProvider = NotifierProvider<CurrencyNotifier, CurrencyState>(
  CurrencyNotifier.new,
);

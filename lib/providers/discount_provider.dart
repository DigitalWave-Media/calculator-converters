import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscountState {
  final String originalPrice;
  final String discountPercent;
  final int activeField; // 1 = originalPrice, 2 = discountPercent

  const DiscountState({
    this.originalPrice = '',
    this.discountPercent = '',
    this.activeField = 1,
  });

  double get priceDouble => double.tryParse(originalPrice) ?? 0.0;
  double get discountDouble => double.tryParse(discountPercent) ?? 0.0;

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

  void onKeypadInput(String key) {
    final int active = state.activeField;
    String currentVal = active == 1 ? state.originalPrice : state.discountPercent;

    if (key == 'C') {
      currentVal = '';
    } else if (key == '⌫') {
      if (currentVal.isNotEmpty) {
        currentVal = currentVal.substring(0, currentVal.length - 1);
      }
    } else {
      if (key == '.' && currentVal.contains('.')) return;
      
      if (active == 2) {
        final double? testVal = double.tryParse(currentVal + key);
        if (testVal != null && testVal > 100.0) return;
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

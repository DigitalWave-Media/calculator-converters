import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_converters/providers/discount_provider.dart';

void main() {
  group('DiscountState — computedFinalPrice', () {
    test('standard discount (1000 @ 20%)', () {
      const state = DiscountState(originalPrice: '1000', discountPercent: '20');
      expect(state.computedFinalPrice, closeTo(800.0, 0.01));
      expect(state.savedAmount, closeTo(200.0, 0.01));
    });

    test('0% discount returns original price', () {
      const state = DiscountState(originalPrice: '500', discountPercent: '0');
      expect(state.computedFinalPrice, closeTo(500.0, 0.01));
      expect(state.savedAmount, closeTo(0.0, 0.01));
    });

    test('100% discount returns zero', () {
      const state = DiscountState(originalPrice: '500', discountPercent: '100');
      expect(state.computedFinalPrice, closeTo(0.0, 0.01));
      expect(state.savedAmount, closeTo(500.0, 0.01));
    });

    test('empty price returns zero', () {
      const state = DiscountState(originalPrice: '', discountPercent: '50');
      expect(state.priceDouble, 0.0);
      expect(state.computedFinalPrice, 0.0);
    });

    test('empty discount is treated as 0%', () {
      const state = DiscountState(originalPrice: '1000', discountPercent: '');
      expect(state.discountDouble, 0.0);
      expect(state.computedFinalPrice, closeTo(1000.0, 0.01));
    });

    test('discount greater than 100% gives negative final price', () {
      // The provider enforces a cap in keypad input, but the state model itself
      // does the raw math — this tests the math is correct even if unclamped.
      const state = DiscountState(originalPrice: '1000', discountPercent: '150');
      expect(state.computedFinalPrice, closeTo(-500.0, 0.01));
    });

    test('decimal discount (33.33%)', () {
      const state = DiscountState(originalPrice: '300', discountPercent: '33.33');
      // 300 * (1 - 0.3333) = 300 * 0.6667 = 200.01
      expect(state.computedFinalPrice, closeTo(200.01, 0.1));
      expect(state.savedAmount, closeTo(99.99, 0.1));
    });
  });

  group('DiscountState — savedAmount', () {
    test('saved amount equals price minus final price', () {
      const state = DiscountState(originalPrice: '250', discountPercent: '10');
      expect(state.savedAmount, closeTo(25.0, 0.01));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_converters/providers/gst_provider.dart';

void main() {
  group('GstState — Add GST', () {
    test('adding 18% GST to 1000', () {
      const state = GstState(originalPrice: '1000', gstRate: 18, addGst: true);
      expect(state.priceDouble, 1000.0);
      expect(state.computedFinalPrice, closeTo(1180.0, 0.01));
      expect(state.gstAmount, closeTo(180.0, 0.01));
      expect(state.cgstSgst, closeTo(90.0, 0.01));
    });

    test('adding 5% GST to 500', () {
      const state = GstState(originalPrice: '500', gstRate: 5, addGst: true);
      expect(state.computedFinalPrice, closeTo(525.0, 0.01));
      expect(state.gstAmount, closeTo(25.0, 0.01));
      expect(state.cgstSgst, closeTo(12.5, 0.01));
    });

    test('adding 28% GST to 2000', () {
      const state = GstState(originalPrice: '2000', gstRate: 28, addGst: true);
      expect(state.computedFinalPrice, closeTo(2560.0, 0.01));
      expect(state.gstAmount, closeTo(560.0, 0.01));
      expect(state.cgstSgst, closeTo(280.0, 0.01));
    });

    test('zero price returns zero', () {
      const state = GstState(originalPrice: '', gstRate: 18, addGst: true);
      expect(state.priceDouble, 0.0);
      expect(state.computedFinalPrice, 0.0);
      expect(state.gstAmount, 0.0);
    });
  });

  group('GstState — Remove GST', () {
    test('removing 18% GST from 1180 (inclusive price)', () {
      const state = GstState(originalPrice: '1180', gstRate: 18, addGst: false);
      expect(state.computedFinalPrice, closeTo(1000.0, 0.01));
      expect(state.gstAmount, closeTo(180.0, 0.01));
      expect(state.cgstSgst, closeTo(90.0, 0.01));
    });

    test('removing 12% GST from 1120', () {
      const state = GstState(originalPrice: '1120', gstRate: 12, addGst: false);
      expect(state.computedFinalPrice, closeTo(1000.0, 0.01));
      expect(state.gstAmount, closeTo(120.0, 0.01));
    });
  });

  group('GstState — CGST/SGST split', () {
    test('CGST and SGST are always half of GST amount', () {
      const state = GstState(originalPrice: '1000', gstRate: 18, addGst: true);
      final gst = state.gstAmount;
      final split = state.cgstSgst;
      expect(split * 2, closeTo(gst, 0.001));
    });

    test('3% GST on 10000 splits correctly', () {
      const state = GstState(originalPrice: '10000', gstRate: 3, addGst: true);
      expect(state.gstAmount, closeTo(300.0, 0.01));
      expect(state.cgstSgst, closeTo(150.0, 0.01));
    });
  });
}

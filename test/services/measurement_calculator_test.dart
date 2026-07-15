import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_converters/services/measurement_calculator.dart';

void main() {
  group('MeasurementCalculator - Area Shapes', () {
    test('Square Area Calculation', () {
      final shape = MeasurementCalculator.getShapeById('square');
      final res = MeasurementCalculator.calculate(
        shape: shape,
        values: {'s': 5.0},
        isAdvancedMode: false,
      );
      expect(res.rawValue, equals(25.0));
      expect(res.grossValueWithWastage, equals(25.0));
    });

    test('Rectangle Area Calculation', () {
      final shape = MeasurementCalculator.getShapeById('rectangle');
      final res = MeasurementCalculator.calculate(
        shape: shape,
        values: {'l': 10.0, 'w': 4.0},
        isAdvancedMode: false,
      );
      expect(res.rawValue, equals(40.0));
    });

    test('Circle Area Calculation', () {
      final shape = MeasurementCalculator.getShapeById('circle');
      final res = MeasurementCalculator.calculate(
        shape: shape,
        values: {'r': 3.0},
        isAdvancedMode: false,
      );
      expect(res.rawValue, closeTo(math.pi * 9.0, 0.0001));
    });

    test('Sector Area Calculation', () {
      final shape = MeasurementCalculator.getShapeById('sector');
      final res = MeasurementCalculator.calculate(
        shape: shape,
        values: {'r': 6.0, 'angle': 90.0},
        isAdvancedMode: false,
      );
      expect(res.rawValue, closeTo(0.25 * math.pi * 36.0, 0.0001));
    });

    test('Area with Advanced Mode Cost & Wastage', () {
      final shape = MeasurementCalculator.getShapeById('rectangle');
      final res = MeasurementCalculator.calculate(
        shape: shape,
        values: {'l': 10.0, 'w': 10.0},
        isAdvancedMode: true,
        wastagePercentage: 10.0,
        unitCost: 15.0,
      );
      expect(res.rawValue, equals(100.0));
      expect(res.grossValueWithWastage, closeTo(110.0, 0.0001));
      expect(res.totalCost, closeTo(1650.0, 0.0001));
    });
  });

  group('MeasurementCalculator - Volume Shapes', () {
    test('Cube Volume Calculation', () {
      final shape = MeasurementCalculator.getShapeById('cube');
      final res = MeasurementCalculator.calculate(
        shape: shape,
        values: {'s': 3.0},
        isAdvancedMode: false,
      );
      expect(res.rawValue, equals(27.0));
    });

    test('Rectangular Prism Volume Calculation', () {
      final shape = MeasurementCalculator.getShapeById('rectangular_prism');
      final res = MeasurementCalculator.calculate(
        shape: shape,
        values: {'l': 5.0, 'w': 4.0, 'h': 2.0},
        isAdvancedMode: false,
      );
      expect(res.rawValue, equals(40.0));
    });

    test('Cylinder Volume Calculation', () {
      final shape = MeasurementCalculator.getShapeById('cylinder');
      final res = MeasurementCalculator.calculate(
        shape: shape,
        values: {'r': 2.0, 'h': 5.0},
        isAdvancedMode: false,
      );
      expect(res.rawValue, closeTo(math.pi * 4.0 * 5.0, 0.0001));
    });

    test('Dumper Truck Load Volume Calculation', () {
      final shape = MeasurementCalculator.getShapeById('dumper');
      final res = MeasurementCalculator.calculate(
        shape: shape,
        values: {
          'l1': 4.0,
          'w1': 2.0,
          'l2': 4.0,
          'w2': 2.0,
          'h': 3.0,
        },
        isAdvancedMode: false,
      );
      expect(res.rawValue, closeTo(24.0, 0.0001));
    });

    test('L-Shape Retaining Wall Volume', () {
      final shape = MeasurementCalculator.getShapeById('l_shape');
      final res = MeasurementCalculator.calculate(
        shape: shape,
        values: {
          'l1': 10.0,
          'w1': 2.0,
          'h1': 3.0,
          'l2': 5.0,
          'w2': 2.0,
          'h2': 3.0,
        },
        isAdvancedMode: false,
      );
      expect(res.rawValue, equals(60.0 + 30.0));
    });

    test('Volume with Advanced Mode Cost & Wastage', () {
      final shape = MeasurementCalculator.getShapeById('cylinder');
      final res = MeasurementCalculator.calculate(
        shape: shape,
        values: {'r': 1.0, 'h': 10.0},
        isAdvancedMode: true,
        wastagePercentage: 5.0,
        unitCost: 100.0,
      );
      final raw = math.pi * 10.0;
      expect(res.rawValue, closeTo(raw, 0.0001));
      expect(res.grossValueWithWastage, closeTo(raw * 1.05, 0.0001));
      expect(res.totalCost, closeTo(raw * 1.05 * 100.0, 0.0001));
    });
  });
}

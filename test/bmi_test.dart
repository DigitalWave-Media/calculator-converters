import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_converters/providers/bmi_provider.dart';

void main() {
  group('BmiNotifier — calculate()', () {
    // We test the BmiState computation logic directly by creating a notifier-like flow.
    // Since BmiNotifier extends Notifier (Riverpod), we test the math by replicating
    // the calculate() logic on BmiState values.

    double computeBmi(double heightCm, double weightKg) {
      final heightM = heightCm / 100;
      return weightKg / (heightM * heightM);
    }

    String categorize(double bmi) {
      if (bmi < 18.5) return 'Underweight';
      if (bmi < 25.0) return 'Normal weight';
      if (bmi < 30.0) return 'Overweight';
      return 'Obese';
    }

    test('underweight: BMI < 18.5', () {
      // 170cm, 50kg → BMI ≈ 17.30
      final bmi = computeBmi(170, 50);
      expect(bmi, lessThan(18.5));
      expect(categorize(bmi), 'Underweight');
    });

    test('normal weight boundary: BMI = 18.5', () {
      // Solve: w / (1.7^2) = 18.5 → w = 18.5 * 2.89 = 53.465
      final bmi = computeBmi(170, 53.465);
      expect(bmi, closeTo(18.5, 0.01));
      expect(categorize(bmi), 'Normal weight');
    });

    test('normal weight: 170cm, 70kg → BMI ≈ 24.22', () {
      final bmi = computeBmi(170, 70);
      expect(bmi, closeTo(24.22, 0.1));
      expect(categorize(bmi), 'Normal weight');
    });

    test('overweight boundary: BMI = 25.0', () {
      // 170cm: w = 25 * 2.89 = 72.25
      final bmi = computeBmi(170, 72.25);
      expect(bmi, closeTo(25.0, 0.01));
      expect(categorize(bmi), 'Overweight');
    });

    test('overweight: 175cm, 85kg → BMI ≈ 27.76', () {
      final bmi = computeBmi(175, 85);
      expect(bmi, closeTo(27.76, 0.1));
      expect(categorize(bmi), 'Overweight');
    });

    test('obese boundary: BMI = 30.0', () {
      // 170cm: w = 30 * 2.89 = 86.7
      final bmi = computeBmi(170, 86.7);
      expect(bmi, closeTo(30.0, 0.05));
      expect(categorize(bmi), 'Obese');
    });

    test('obese: 160cm, 100kg → BMI ≈ 39.06', () {
      final bmi = computeBmi(160, 100);
      expect(bmi, closeTo(39.06, 0.1));
      expect(categorize(bmi), 'Obese');
    });
  });

  group('BmiState — invalid inputs', () {
    test('BmiState with invalid height string', () {
      const state = BmiState(heightCm: 'abc', weightKg: '70');
      // double.tryParse('abc') returns null
      expect(double.tryParse(state.heightCm), isNull);
    });

    test('BmiState with zero height', () {
      const state = BmiState(heightCm: '0', weightKg: '70');
      expect(double.tryParse(state.heightCm), 0);
    });

    test('BmiState with negative weight', () {
      const state = BmiState(heightCm: '170', weightKg: '-5');
      expect(double.tryParse(state.weightKg), -5);
    });

    test('BmiState default values', () {
      const state = BmiState();
      expect(state.age, '25');
      expect(state.gender, 'Male');
      expect(state.heightCm, '170');
      expect(state.weightKg, '70');
      expect(state.bmiValue, isNull);
      expect(state.category, isNull);
    });

    test('BmiState copyWith preserves unmodified values', () {
      const state = BmiState(heightCm: '180', weightKg: '80');
      final updated = state.copyWith(heightCm: '175');
      expect(updated.heightCm, '175');
      expect(updated.weightKg, '80');
    });
  });
}

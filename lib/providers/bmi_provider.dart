import 'package:flutter_riverpod/flutter_riverpod.dart';

class BmiState {
  final String age;
  final String gender; // 'Male' | 'Female'
  final String heightCm;
  final String weightKg;
  final double? bmiValue;
  final String? category;

  const BmiState({
    this.age = '25',
    this.gender = 'Male',
    this.heightCm = '170',
    this.weightKg = '70',
    this.bmiValue,
    this.category,
  });

  BmiState copyWith({
    String? age,
    String? gender,
    String? heightCm,
    String? weightKg,
    double? bmiValue,
    String? category,
  }) {
    return BmiState(
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      bmiValue: bmiValue,
      category: category,
    );
  }
}

class BmiNotifier extends Notifier<BmiState> {
  @override
  BmiState build() {
    return const BmiState();
  }

  void setAge(String age) {
    state = state.copyWith(age: age);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void setHeight(String height) {
    state = state.copyWith(heightCm: height);
  }

  void setWeight(String weight) {
    state = state.copyWith(weightKg: weight);
  }

  void calculate() {
    final double? height = double.tryParse(state.heightCm);
    final double? weight = double.tryParse(state.weightKg);

    if (height == null || weight == null || height <= 0 || weight <= 0) {
      state = state.copyWith(bmiValue: null, category: 'Invalid Inputs');
      return;
    }

    final double heightMeters = height / 100;
    final double bmi = weight / (heightMeters * heightMeters);

    String cat;
    if (bmi < 18.5) {
      cat = 'Underweight';
    } else if (bmi < 25.0) {
      cat = 'Normal weight';
    } else if (bmi < 30.0) {
      cat = 'Overweight';
    } else {
      cat = 'Obese';
    }

    state = BmiState(
      age: state.age,
      gender: state.gender,
      heightCm: state.heightCm,
      weightKg: state.weightKg,
      bmiValue: bmi,
      category: cat,
    );
  }
}

final bmiProvider = NotifierProvider<BmiNotifier, BmiState>(
  BmiNotifier.new,
);

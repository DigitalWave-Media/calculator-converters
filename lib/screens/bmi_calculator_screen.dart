import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/bmi_provider.dart';
import '../../widgets/shared/detail_header.dart';
import '../../widgets/shared/form_input_field.dart';
import '../../widgets/shared/toggle_radio_pair.dart';
import '../../widgets/shared/cta_button.dart';

class BMICalculatorScreen extends ConsumerWidget {
  const BMICalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bmiProvider);
    final notifier = ref.read(bmiProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const DetailHeader(title: 'BMI Calculator'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // Age and Gender Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FormInputField(
                      label: 'Age',
                      initialValue: state.age,
                      onChanged: (val) => notifier.setAge(val),
                      suffixText: 'yrs',
                    ),
                  ),
                  Expanded(
                    child: ToggleRadioPair(
                      label: 'Gender',
                      value1: 'Male',
                      value2: 'Female',
                      selectedValue: state.gender,
                      onChanged: (val) => notifier.setGender(val),
                      icon1: Icons.male,
                      icon2: Icons.female,
                    ),
                  ),
                ],
              ),
              
              // Height & Weight Inputs
              FormInputField(
                label: 'Height',
                initialValue: state.heightCm,
                onChanged: (val) => notifier.setHeight(val),
                suffixText: 'cm',
              ),
              FormInputField(
                label: 'Weight',
                initialValue: state.weightKg,
                onChanged: (val) => notifier.setWeight(val),
                suffixText: 'kg',
              ),

              // Calculate Trigger
              CTAButton(
                label: 'Calculate',
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  notifier.calculate();
                },
              ),

              // Result Banner
              if (state.bmiValue != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'BMI SCORE',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.bmiValue!.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'HEALTH CATEGORY',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.category ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _getCategoryColor(state.category),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              // Static Informative section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 0,
                  color: Colors.white.withValues(alpha: 0.7),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'About BMI',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Body Mass Index (BMI) is a measurement of a person\'s weight with respect to their height. It is more of an indicator than a direct measurement of a person\'s total body fat.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    if (category == null) return AppColors.textDark;
    if (category.contains('Normal')) return Colors.green;
    if (category.contains('Underweight')) return Colors.orange;
    if (category.contains('Overweight')) return Colors.amber;
    return Colors.red;
  }
}

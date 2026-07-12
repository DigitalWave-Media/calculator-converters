import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/num_to_word_provider.dart';
import '../../widgets/shared/detail_header.dart';
import '../../widgets/shared/numeric_keypad.dart';
import '../../widgets/shared/bottom_drag_handle.dart';

class NumberToWordConverterScreen extends ConsumerWidget {
  const NumberToWordConverterScreen({super.key});

  String _formatDisplayValue(String expression) {
    if (expression.isEmpty) return '0';
    if (expression.contains(RegExp(r'[+\−\×\÷%]'))) {
      return expression;
    }
    if (expression.startsWith('-')) {
      return '-${_formatDigits(expression.substring(1))}';
    }
    return _formatDigits(expression);
  }

  String _formatDigits(String clean) {
    if (clean.length <= 3) return clean;
    final lastThree = clean.substring(clean.length - 3);
    final remaining = clean.substring(0, clean.length - 3);
    
    final List<String> groups = [];
    int i = remaining.length;
    while (i > 0) {
      if (i >= 2) {
        groups.insert(0, remaining.substring(i - 2, i));
        i -= 2;
      } else {
        groups.insert(0, remaining.substring(0, i));
        i = 0;
      }
    }
    return '${groups.join(',')},$lastThree';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(numToWordProvider);
    final notifier = ref.read(numToWordProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const DetailHeader(
        title: 'Number to Word',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Designated Display Area for Input Number / Expression
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        _formatDisplayValue(state.inputExpression),
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Stacked Language Outputs
                  _buildLanguageCard(
                    title: 'ENGLISH',
                    sub: 'International System',
                    word: state.englishWord,
                    icon: Icons.language,
                    gradientStart: const Color(0xFF2C3E50),
                    gradientEnd: const Color(0xFF3498DB),
                  ),
                  const SizedBox(height: 12),
                  _buildLanguageCard(
                    title: 'HINDI (हिन्दी)',
                    sub: 'Indian System (Devanagari)',
                    word: state.hindiWord,
                    icon: Icons.translate,
                    gradientStart: const Color(0xFFE67E22),
                    gradientEnd: const Color(0xFFD35400),
                  ),
                  const SizedBox(height: 12),
                  _buildLanguageCard(
                    title: 'BENGALI (বাংলা)',
                    sub: 'Indian System (Bengali)',
                    word: state.bengaliWord,
                    icon: Icons.text_fields,
                    gradientStart: const Color(0xFF27AE60),
                    gradientEnd: const Color(0xFF2ECC71),
                  ),
                ],
              ),
            ),
          ),
          
          // Custom Keypad in Standard Mode
          NumericKeypad(
            mode: KeypadMode.standard,
            onKeyPressed: (key) => notifier.onKeypadInput(key),
          ),
          const BottomDragHandle(),
        ],
      ),
    );
  }

  Widget _buildLanguageCard({
    required String title,
    required String sub,
    required String word,
    required IconData icon,
    required Color gradientStart,
    required Color gradientEnd,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5E5EA),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: gradientStart,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Text(
                    sub,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: gradientStart.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: gradientStart,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            word,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/calculator_provider.dart';
import '../../widgets/shared/numeric_keypad.dart';
import '../../widgets/shared/history_popover.dart';
import '../../widgets/shared/bottom_drag_handle.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calcState = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with History Toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.history, color: AppColors.textDark, size: 28),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (context) => HistoryPopover(
                      history: calcState.history,
                      onClear: () => notifier.clearAllHistory(),
                      onItemTapped: (expr) => notifier.setInputFromHistory(expr),
                    ),
                  );
                },
              ),
            ),
            
            // Expression and Result displays
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Scrolling Expression Input
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Text(
                            calcState.currentInput.isEmpty ? '0' : calcState.currentInput,
                            style: const TextStyle(
                              fontSize: 32,
                              color: AppColors.textGray,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Large Bold Live Result
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Text(
                            calcState.result.isEmpty ? '' : calcState.result,
                            style: const TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Keyboard Layout
            NumericKeypad(
              mode: KeypadMode.standard,
              onKeyPressed: (key) {
                if (key == 'C') {
                  notifier.onClear();
                } else if (key == '⌫') {
                  notifier.onBackspace();
                } else if (key == '=') {
                  notifier.onEquals();
                } else if (key == '÷' || key == '×' || key == '−' || key == '+') {
                  notifier.onOperatorPressed(key);
                } else {
                  notifier.onDigitPressed(key);
                }
              },
            ),
            const BottomDragHandle(),
          ],
        ),
      ),
    );
  }
}

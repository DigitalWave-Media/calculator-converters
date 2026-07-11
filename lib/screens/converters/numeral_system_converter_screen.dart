import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/unit_tables.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/converter_provider.dart';
import '../../widgets/shared/detail_header.dart';
import '../../widgets/shared/unit_selector_field.dart';
import '../../widgets/shared/numeric_keypad.dart';
import '../../widgets/shared/bottom_drag_handle.dart';

class NumeralSystemConverterScreen extends ConsumerWidget {
  const NumeralSystemConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const category = ConverterCategory.numeral;
    final state = ref.watch(converterProvider(category));
    final notifier = ref.read(converterProvider(category).notifier);
    final allUnits = UnitTables.getUnitsForCategory(category);

    final int activeRadix = state.activeField == 1
        ? state.unitA.multiplier.toInt()
        : state.unitB.multiplier.toInt();

    bool isKeyEnabled(String key) {
      if (key == '.') return false; // Fractions not supported for integer base converter
      if (key == 'C' || key == '⌫') return true;

      // Check digit bounds
      final val = int.tryParse(key);
      if (val != null) {
        return val < activeRadix;
      }

      // Check letter bounds (A-F)
      final letterMap = {'A': 10, 'B': 11, 'C': 12, 'D': 13, 'E': 14, 'F': 15};
      final letterVal = letterMap[key];
      if (letterVal != null) {
        return letterVal < activeRadix;
      }

      return false;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DetailHeader(
        title: 'Numeral System',
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_vert, color: AppColors.primary, size: 28),
            onPressed: () => notifier.swapUnits(),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Field A
          UnitSelectorField(
            label: 'From',
            selectedUnit: state.unitA,
            displayValue: state.valueA.isEmpty ? '0' : state.valueA,
            options: allUnits.where((u) => u != state.unitB).toList(),
            onUnitChanged: (unit) => notifier.onUnitSelected(1, unit),
            isActive: state.activeField == 1,
            onTapField: () => notifier.onFieldTapped(1),
          ),
          const SizedBox(height: 8),
          // Field B
          UnitSelectorField(
            label: 'To',
            selectedUnit: state.unitB,
            displayValue: state.valueB.isEmpty ? '0' : state.valueB,
            options: allUnits.where((u) => u != state.unitA).toList(),
            onUnitChanged: (unit) => notifier.onUnitSelected(2, unit),
            isActive: state.activeField == 2,
            onTapField: () => notifier.onFieldTapped(2),
          ),
          const Spacer(),
          // Hex Keypad with dynamic validation
          NumericKeypad(
            mode: KeypadMode.hex,
            onKeyPressed: (key) => notifier.onKeypadInput(key),
            isKeyEnabled: isKeyEnabled,
          ),
          const BottomDragHandle(),
        ],
      ),
    );
  }
}

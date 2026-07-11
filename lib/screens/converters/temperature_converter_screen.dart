import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/unit_tables.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/converter_provider.dart';
import '../../widgets/shared/detail_header.dart';
import '../../widgets/shared/unit_selector_field.dart';
import '../../widgets/shared/numeric_keypad.dart';
import '../../widgets/shared/bottom_drag_handle.dart';

class TemperatureConverterScreen extends ConsumerWidget {
  const TemperatureConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const category = ConverterCategory.temperature;
    final state = ref.watch(converterProvider(category));
    final notifier = ref.read(converterProvider(category).notifier);
    final allUnits = UnitTables.getUnitsForCategory(category);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DetailHeader(
        title: 'Temperature',
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
          // Numeric Keyboard (Temperature Mode with +/- toggle)
          NumericKeypad(
            mode: KeypadMode.temperature,
            onKeyPressed: (key) => notifier.onKeypadInput(key),
          ),
          const BottomDragHandle(),
        ],
      ),
    );
  }
}

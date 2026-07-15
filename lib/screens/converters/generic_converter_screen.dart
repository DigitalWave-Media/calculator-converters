import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/unit_tables.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/converter_provider.dart';
import '../../widgets/shared/detail_header.dart';
import '../../widgets/shared/unit_selector_field.dart';
import '../../widgets/shared/numeric_keypad.dart';

import '../../widgets/shared/unit_result_card.dart';

class GenericConverterScreen extends ConsumerWidget {
  final ConverterCategory category;

  const GenericConverterScreen({
    super.key,
    required this.category,
  });

  String _getCategoryTitle() {
    switch (category) {
      case ConverterCategory.length:
        return 'Length';
      case ConverterCategory.mass:
        return 'Mass';
      case ConverterCategory.area:
        return 'Area';
      case ConverterCategory.volume:
        return 'Volume';
      case ConverterCategory.time:
        return 'Time';
      case ConverterCategory.speed:
        return 'Speed';
      case ConverterCategory.data:
        return 'Data';
      default:
        return 'Converter';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(converterProvider(category));
    final notifier = ref.read(converterProvider(category).notifier);
    final allUnits = UnitTables.getUnitsForCategory(category);
    
    final bool hasValue = state.valueA.isNotEmpty || state.valueB.isNotEmpty;
    final sourceUnit = state.activeField == 1 ? state.unitA : state.unitB;
    final remainingUnits = allUnits.where((u) => u != sourceUnit).toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.primaryDark : AppColors.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: DetailHeader(
        title: _getCategoryTitle(),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_vert, color: primaryColor, size: 28),
            onPressed: () => notifier.swapUnits(),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
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
                    if (hasValue)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextButton.icon(
                          onPressed: () => notifier.toggleExpanded(),
                          icon: Icon(
                            state.isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: AppColors.primary,
                          ),
                          label: Text(
                            state.isExpanded ? 'Collapse' : 'Show All Units',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    if (state.isExpanded) ...[
                      const Divider(indent: 16, endIndent: 16),
                      const SizedBox(height: 8),
                      ...remainingUnits.map((unit) {
                        final sourceVal = state.activeField == 1 ? state.valueA : state.valueB;
                        final convertedVal = notifier.convertValueTo(sourceVal, sourceUnit, unit);
                        return UnitResultCard(unit: unit, value: convertedVal);
                      }),
                    ],
                  ],
                ),
              ),
            ),
            // Numeric Keyboard
            if (!state.isExpanded)
              NumericKeypad(
                mode: KeypadMode.standard,
                onKeyPressed: (key) => notifier.onKeypadInput(key),
              ),
          ],
        ),
      ),
    );
  }
}

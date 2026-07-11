import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/unit_tables.dart';
import '../core/utils/temperature_converter.dart';
import '../core/utils/base_converter.dart';
import '../models/unit_option.dart';
import '../services/unit_preference_service.dart';

final unitPreferenceProvider = Provider<UnitPreferenceService>((ref) {
  return UnitPreferenceService();
});

class ConverterState {
  final UnitOption unitA;
  final UnitOption unitB;
  final String valueA;
  final String valueB;
  final int activeField; // 1 = fieldA, 2 = fieldB

  const ConverterState({
    required this.unitA,
    required this.unitB,
    this.valueA = '',
    this.valueB = '',
    this.activeField = 1,
  });

  ConverterState copyWith({
    UnitOption? unitA,
    UnitOption? unitB,
    String? valueA,
    String? valueB,
    int? activeField,
  }) {
    return ConverterState(
      unitA: unitA ?? this.unitA,
      unitB: unitB ?? this.unitB,
      valueA: valueA ?? this.valueA,
      valueB: valueB ?? this.valueB,
      activeField: activeField ?? this.activeField,
    );
  }
}

class ConverterNotifier extends Notifier<ConverterState> {
  final ConverterCategory category;

  ConverterNotifier(this.category);

  @override
  ConverterState build() {
    final units = UnitTables.getUnitsForCategory(category);
    _loadPreferences(category);
    
    return ConverterState(
      unitA: units[0],
      unitB: units[1],
    );
  }

  Future<void> _loadPreferences(ConverterCategory category) async {
    final prefService = ref.read(unitPreferenceProvider);
    final String catName = category.name;
    final lastA = await prefService.getLastUnitA(catName);
    final lastB = await prefService.getLastUnitB(catName);

    final units = UnitTables.getUnitsForCategory(category);
    UnitOption selectedA = units[0];
    UnitOption selectedB = units[1];

    if (lastA != null) {
      selectedA = units.firstWhere((u) => u.name == lastA, orElse: () => units[0]);
    }
    if (lastB != null) {
      selectedB = units.firstWhere((u) => u.name == lastB, orElse: () => units[1]);
    }

    state = state.copyWith(unitA: selectedA, unitB: selectedB);
  }

  void onFieldTapped(int field) {
    state = state.copyWith(activeField: field);
  }

  void onUnitSelected(int field, UnitOption unit) {
    if (field == 1) {
      state = state.copyWith(unitA: unit);
    } else {
      state = state.copyWith(unitB: unit);
    }
    
    ref.read(unitPreferenceProvider).saveLastUnits(category.name, state.unitA.name, state.unitB.name);
    _recalculate(triggeredByField: state.activeField);
  }

  void onKeypadInput(String key) {
    final int active = state.activeField;
    String currentVal = active == 1 ? state.valueA : state.valueB;

    if (key == 'C') {
      currentVal = '';
    } else if (key == '⌫') {
      if (currentVal.isNotEmpty) {
        currentVal = currentVal.substring(0, currentVal.length - 1);
      }
    } else if (key == '+/-') {
      if (currentVal.startsWith('-')) {
        currentVal = currentVal.substring(1);
      } else if (currentVal.isNotEmpty) {
        currentVal = '-$currentVal';
      }
    } else {
      if (category == ConverterCategory.numeral) {
        final radix = active == 1 ? state.unitA.multiplier.toInt() : state.unitB.multiplier.toInt();
        final testVal = currentVal + key;
        if (!BaseConverter.isValidInput(testVal, radix)) {
          return;
        }
      } else {
        if (key == '.' && currentVal.contains('.')) return;
      }

      currentVal += key;
    }

    if (active == 1) {
      state = state.copyWith(valueA: currentVal);
    } else {
      state = state.copyWith(valueB: currentVal);
    }

    _recalculate(triggeredByField: active);
  }

  void swapUnits() {
    state = state.copyWith(
      unitA: state.unitB,
      unitB: state.unitA,
      valueA: state.valueB,
      valueB: state.valueA,
      activeField: state.activeField == 1 ? 2 : 1,
    );
    ref.read(unitPreferenceProvider).saveLastUnits(category.name, state.unitA.name, state.unitB.name);
  }

  void _recalculate({required int triggeredByField}) {
    if (triggeredByField == 1) {
      if (state.valueA.isEmpty) {
        state = state.copyWith(valueB: '');
        return;
      }
      final computed = _convertValue(state.valueA, state.unitA, state.unitB);
      state = state.copyWith(valueB: computed);
    } else {
      if (state.valueB.isEmpty) {
        state = state.copyWith(valueA: '');
        return;
      }
      final computed = _convertValue(state.valueB, state.unitB, state.unitA);
      state = state.copyWith(valueA: computed);
    }
  }

  String _convertValue(String val, UnitOption from, UnitOption to) {
    if (category == ConverterCategory.temperature) {
      final double parsed = double.tryParse(val) ?? 0.0;
      final double converted = TemperatureConverter.convert(parsed, from.name, to.name);
      return _formatDouble(converted);
    } else if (category == ConverterCategory.numeral) {
      final int fromRadix = from.multiplier.toInt();
      final int toRadix = to.multiplier.toInt();
      return BaseConverter.convert(val, fromRadix, toRadix);
    } else {
      final double parsed = double.tryParse(val) ?? 0.0;
      final double baseVal = parsed * from.multiplier;
      final double converted = baseVal / to.multiplier;
      return _formatDouble(converted);
    }
  }

  String _formatDouble(double val) {
    if (val.isNaN) return 'Error';
    if (val.isInfinite) return 'Infinity';
    if (val == val.roundToDouble()) {
      return val.round().toString();
    }
    String str = val.toString();
    if (str.contains('.')) {
      int idx = str.indexOf('.');
      if (str.length - idx > 8) {
        str = val.toStringAsFixed(6);
        while (str.endsWith('0')) {
          str = str.substring(0, str.length - 1);
        }
        if (str.endsWith('.')) {
          str = str.substring(0, str.length - 1);
        }
      }
    }
    return str;
  }
}

final converterProvider = NotifierProvider.family<ConverterNotifier, ConverterState, ConverterCategory>(
  ConverterNotifier.new,
);

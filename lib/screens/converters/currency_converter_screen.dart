import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/unit_option.dart';
import '../../providers/currency_provider.dart';
import '../../widgets/shared/detail_header.dart';
import '../../widgets/shared/unit_selector_field.dart';
import '../../widgets/shared/numeric_keypad.dart';

class CurrencyConverterScreen extends ConsumerStatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  ConsumerState<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends ConsumerState<CurrencyConverterScreen> {
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    // Refresh exchange rates on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currencyProvider.notifier).refreshRates();
    });

    // Poll every 15 minutes to save API requests and bandwidth
    _pollingTimer = Timer.periodic(const Duration(minutes: 15), (_) {
      ref.read(currencyProvider.notifier).refreshRates();
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currencyProvider);
    final notifier = ref.read(currencyProvider.notifier);

    // Map CurrencyOption to UnitOption to reuse UnitSelectorField directly!
    UnitOption mapToUnitOption(dynamic c) {
      return UnitOption(
        name: c.name,
        abbreviation: c.isoCode,
        multiplier: c.rate,
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.primaryDark : AppColors.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: DetailHeader(
        title: 'Currency Converter',
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: primaryColor, size: 28),
            onPressed: () {
              // Add a currency that is not already selected
              final unused = state.allCurrencies.firstWhere(
                (c) => !state.selectedCurrencies.any((s) => s.isoCode == c.isoCode),
                orElse: () => state.allCurrencies.isEmpty ? state.selectedCurrencies[0] : state.allCurrencies[0],
              );
              notifier.addSelectedCurrency(unused);
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            if (state.errorMessage != null)
              Container(
                color: Colors.red.shade50,
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            
            Expanded(
              child: () {
                final List<UnitOption> pickerOptions = state.allCurrencies
                    .map((c) => mapToUnitOption(c))
                    .toList();

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: state.selectedCurrencies.length,
                  itemBuilder: (context, index) {
                    final currency = state.selectedCurrencies[index];
                    final bool isActive = state.activeIsoCode == currency.isoCode;
                    
                    // Active field gets raw typing value; others show computed converted value
                    final String displayVal = isActive
                        ? (state.activeValue.isEmpty ? '0' : state.activeValue)
                        : notifier.getDisplayValue(currency.isoCode);

                    return Dismissible(
                      key: ValueKey(currency.isoCode),
                      direction: state.selectedCurrencies.length > 1
                          ? DismissDirection.endToStart
                          : DismissDirection.none,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        notifier.removeSelectedCurrency(index);
                      },
                      child: UnitSelectorField(
                        label: currency.name,
                        selectedUnit: mapToUnitOption(currency),
                        displayValue: displayVal,
                        options: pickerOptions,
                        showSearch: true, // Enable search filter inside currency selector modal
                        onUnitChanged: (unit) {
                          final chosenCurrency = state.allCurrencies.firstWhere(
                            (c) => c.isoCode == unit.abbreviation,
                          );
                          notifier.updateSelectedCurrency(index, chosenCurrency);
                        },
                        isActive: isActive,
                        onTapField: () {
                          notifier.selectActiveCurrency(currency.isoCode, displayVal == '0' ? '' : displayVal);
                        },
                      ),
                    );
                  },
                );
              }(),
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                state.isLoading
                    ? 'Updating exchange rates...'
                    : 'Exchange rates provided by Open Exchange Rates API.',
                style: AppTextStyles.bodySmall,
              ),
            ),

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

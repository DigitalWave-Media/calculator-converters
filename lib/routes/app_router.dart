import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/routes.dart';
import '../core/constants/unit_tables.dart';
import '../screens/main_shell_screen.dart';
import '../screens/converters/generic_converter_screen.dart';
import '../screens/converters/temperature_converter_screen.dart';
import '../screens/converters/numeral_system_converter_screen.dart';
import '../screens/converters/currency_converter_screen.dart';
import '../screens/gst_calculator_screen.dart';
import '../screens/discount_calculator_screen.dart';
import '../screens/bmi_calculator_screen.dart';
import '../screens/finance_calculator_screen.dart';
import '../screens/date_calculator_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.root,
    routes: [
      // Main Hub (Calculator & Converter Hub)
      GoRoute(
        path: AppRoutes.root,
        builder: (context, state) => const MainShellScreen(),
      ),
      
      // Generic converters
      GoRoute(
        path: AppRoutes.length,
        builder: (context, state) => const GenericConverterScreen(category: ConverterCategory.length),
      ),
      GoRoute(
        path: AppRoutes.mass,
        builder: (context, state) => const GenericConverterScreen(category: ConverterCategory.mass),
      ),
      GoRoute(
        path: AppRoutes.area,
        builder: (context, state) => const GenericConverterScreen(category: ConverterCategory.area),
      ),
      GoRoute(
        path: AppRoutes.time,
        builder: (context, state) => const GenericConverterScreen(category: ConverterCategory.time),
      ),
      GoRoute(
        path: AppRoutes.volume,
        builder: (context, state) => const GenericConverterScreen(category: ConverterCategory.volume),
      ),
      GoRoute(
        path: AppRoutes.speed,
        builder: (context, state) => const GenericConverterScreen(category: ConverterCategory.speed),
      ),
      GoRoute(
        path: AppRoutes.data,
        builder: (context, state) => const GenericConverterScreen(category: ConverterCategory.data),
      ),

      // Special converters
      GoRoute(
        path: AppRoutes.temperature,
        builder: (context, state) => const TemperatureConverterScreen(),
      ),
      GoRoute(
        path: AppRoutes.numeral,
        builder: (context, state) => const NumeralSystemConverterScreen(),
      ),
      GoRoute(
        path: AppRoutes.currency,
        builder: (context, state) => const CurrencyConverterScreen(),
      ),

      // Specialized calculators
      GoRoute(
        path: AppRoutes.gst,
        builder: (context, state) => const GstCalculatorScreen(),
      ),
      GoRoute(
        path: AppRoutes.discount,
        builder: (context, state) => const DiscountCalculatorScreen(),
      ),
      GoRoute(
        path: AppRoutes.bmi,
        builder: (context, state) => const BMICalculatorScreen(),
      ),
      GoRoute(
        path: AppRoutes.finance,
        builder: (context, state) => const FinanceCalculatorScreen(),
      ),
      GoRoute(
        path: AppRoutes.date,
        builder: (context, state) => const DateCalculatorScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('No route defined for ${state.uri}'),
      ),
    ),
  );
});

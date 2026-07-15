# Calculator & Converters

An all-in-one Flutter calculator and converter app for everyday math, unit conversions, and financial calculations.

## Features

| Tool | Description |
|---|---|
| **Calculator** | Standard calculator with expression evaluation and calculation history |
| **Unit Converters** | Length, mass, area, volume, time, speed, temperature, and data storage |
| **Numeral/Base Converter** | Convert between binary, octal, decimal, and hexadecimal |
| **Currency Converter** | Live exchange rates (via open.er-api.com) with offline caching |
| **BMI Calculator** | Body Mass Index with WHO category classification |
| **GST Calculator** | Add or remove GST at Indian tax slab rates (3%, 5%, 12%, 18%, 28%) with CGST/SGST split |
| **Discount Calculator** | Calculate final price and savings from percentage discounts |
| **Finance Calculator** | Loan EMI, lump-sum investment, and SIP (systematic investment plan) |
| **Date Difference** | Calculate the difference between two dates in years, months, and days |
| **Number to Words** | Convert numeric values to their English word representation |

## Tech Stack

- **Framework:** Flutter (Dart 3)
- **State Management:** Riverpod
- **Routing:** go_router
- **Networking:** Dio
- **Local Storage:** shared_preferences
- **Math Parsing:** math_expressions

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.12+)
- Android Studio or VS Code with Flutter extensions

### Run

```bash
# Get dependencies
flutter pub get

# Run on connected device / emulator
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze
```

### Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# Web
flutter build web
```

> **Note:** For release builds, you need to set up signing. See `android/key.properties.example` for instructions.

## Project Structure

```
lib/
├── core/
│   ├── constants/    # Unit tables, app constants
│   ├── theme/        # App theme configuration
│   └── utils/        # Expression evaluator, converters, calculators
├── models/           # Data models (CurrencyOption, FinanceInput, etc.)
├── providers/        # Riverpod state management
├── routes/           # go_router configuration
├── screens/          # UI screens
├── services/         # Currency API, history storage, preferences
└── widgets/          # Reusable UI components
```

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

class BaseConverter {
  static String convert(String value, int fromRadix, int toRadix) {
    if (value.isEmpty) return '';
    try {
      // BigInt allows handling huge bit representations without overflow
      final BigInt parsed = BigInt.parse(value.trim(), radix: fromRadix);
      return parsed.toRadixString(toRadix).toUpperCase();
    } catch (e) {
      return 'Error';
    }
  }

  static bool isValidInput(String value, int radix) {
    if (value.isEmpty) return true;
    final regexMap = {
      2: RegExp(r'^[01]+$'),
      8: RegExp(r'^[0-7]+$'),
      10: RegExp(r'^[0-9]+$'),
      16: RegExp(r'^[0-9A-Fa-f]+$'),
    };
    return regexMap[radix]?.hasMatch(value) ?? false;
  }
}

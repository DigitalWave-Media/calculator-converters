class TemperatureConverter {
  static double convert(double value, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return value;

    // Convert from source to Celsius first
    double celsius;
    if (fromUnit.contains('C')) {
      celsius = value;
    } else if (fromUnit.contains('F')) {
      celsius = (value - 32) * 5 / 9;
    } else if (fromUnit.contains('K')) {
      celsius = value - 273.15;
    } else {
      celsius = value;
    }

    // Convert from Celsius to destination
    if (toUnit.contains('C')) {
      return celsius;
    } else if (toUnit.contains('F')) {
      return (celsius * 9 / 5) + 32;
    } else if (toUnit.contains('K')) {
      return celsius + 273.15;
    } else {
      return celsius;
    }
  }
}

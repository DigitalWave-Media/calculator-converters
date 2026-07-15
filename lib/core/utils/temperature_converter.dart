class TemperatureConverter {
  static double convert(double value, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return value;

    // Convert from source to Celsius first
    double celsius;
    if (fromUnit == 'Celsius' || fromUnit == '°C') {
      celsius = value;
    } else if (fromUnit == 'Fahrenheit' || fromUnit == '°F') {
      celsius = (value - 32) * 5 / 9;
    } else if (fromUnit == 'Kelvin' || fromUnit == 'K') {
      celsius = value - 273.15;
    } else if (fromUnit == 'Réaumur' || fromUnit == '°Re') {
      celsius = value * 1.25;
    } else if (fromUnit == 'Rankine' || fromUnit == '°R') {
      celsius = (value - 491.67) * 5 / 9;
    } else {
      celsius = value;
    }

    // Convert from Celsius to destination
    if (toUnit == 'Celsius' || toUnit == '°C') {
      return celsius;
    } else if (toUnit == 'Fahrenheit' || toUnit == '°F') {
      return (celsius * 9 / 5) + 32;
    } else if (toUnit == 'Kelvin' || toUnit == 'K') {
      return celsius + 273.15;
    } else if (toUnit == 'Réaumur' || toUnit == '°Re') {
      return celsius * 0.8;
    } else if (toUnit == 'Rankine' || toUnit == '°R') {
      return (celsius + 273.15) * 9 / 5;
    } else {
      return celsius;
    }
  }
}

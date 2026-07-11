import '../../models/unit_option.dart';

enum ConverterCategory {
  length,
  mass,
  area,
  volume,
  time,
  speed,
  temperature,
  data,
  numeral,
  currency,
}

class UnitTables {
  static const List<UnitOption> lengthUnits = [
    UnitOption(name: 'Meter', abbreviation: 'm', multiplier: 1.0),
    UnitOption(name: 'Kilometer', abbreviation: 'km', multiplier: 1000.0),
    UnitOption(name: 'Centimeter', abbreviation: 'cm', multiplier: 0.01),
    UnitOption(name: 'Millimeter', abbreviation: 'mm', multiplier: 0.001),
    UnitOption(name: 'Mile', abbreviation: 'mi', multiplier: 1609.344),
    UnitOption(name: 'Yard', abbreviation: 'yd', multiplier: 0.9144),
    UnitOption(name: 'Foot', abbreviation: 'ft', multiplier: 0.3048),
    UnitOption(name: 'Inch', abbreviation: 'in', multiplier: 0.0254),
  ];

  static const List<UnitOption> massUnits = [
    UnitOption(name: 'Kilogram', abbreviation: 'kg', multiplier: 1.0),
    UnitOption(name: 'Gram', abbreviation: 'g', multiplier: 0.001),
    UnitOption(name: 'Milligram', abbreviation: 'mg', multiplier: 0.000001),
    UnitOption(name: 'Pound', abbreviation: 'lb', multiplier: 0.45359237),
    UnitOption(name: 'Ounce', abbreviation: 'oz', multiplier: 0.028349523),
    UnitOption(name: 'Ton', abbreviation: 't', multiplier: 1000.0),
  ];

  static const List<UnitOption> areaUnits = [
    UnitOption(name: 'Square Meter', abbreviation: 'm²', multiplier: 1.0),
    UnitOption(name: 'Square Kilometer', abbreviation: 'km²', multiplier: 1000000.0),
    UnitOption(name: 'Square Mile', abbreviation: 'mi²', multiplier: 2589988.11),
    UnitOption(name: 'Square Yard', abbreviation: 'yd²', multiplier: 0.83612736),
    UnitOption(name: 'Square Foot', abbreviation: 'ft²', multiplier: 0.09290304),
    UnitOption(name: 'Square Inch', abbreviation: 'in²', multiplier: 0.00064516),
    UnitOption(name: 'Hectare', abbreviation: 'ha', multiplier: 10000.0),
    UnitOption(name: 'Acre', abbreviation: 'ac', multiplier: 4046.8564),
  ];

  static const List<UnitOption> volumeUnits = [
    UnitOption(name: 'Liter', abbreviation: 'L', multiplier: 1.0),
    UnitOption(name: 'Milliliter', abbreviation: 'mL', multiplier: 0.001),
    UnitOption(name: 'Cubic Meter', abbreviation: 'm³', multiplier: 1000.0),
    UnitOption(name: 'Gallon (US)', abbreviation: 'gal', multiplier: 3.78541178),
    UnitOption(name: 'Quart (US)', abbreviation: 'qt', multiplier: 0.946352946),
    UnitOption(name: 'Pint (US)', abbreviation: 'pt', multiplier: 0.473176473),
    UnitOption(name: 'Cup (US)', abbreviation: 'cup', multiplier: 0.236588236),
    UnitOption(name: 'Fluid Ounce (US)', abbreviation: 'fl oz', multiplier: 0.029573529),
  ];

  static const List<UnitOption> timeUnits = [
    UnitOption(name: 'Second', abbreviation: 's', multiplier: 1.0),
    UnitOption(name: 'Millisecond', abbreviation: 'ms', multiplier: 0.001),
    UnitOption(name: 'Minute', abbreviation: 'min', multiplier: 60.0),
    UnitOption(name: 'Hour', abbreviation: 'h', multiplier: 3600.0),
    UnitOption(name: 'Day', abbreviation: 'd', multiplier: 86400.0),
    UnitOption(name: 'Week', abbreviation: 'wk', multiplier: 604800.0),
    UnitOption(name: 'Month (30 Days)', abbreviation: 'mo', multiplier: 2592000.0),
    UnitOption(name: 'Year (365 Days)', abbreviation: 'yr', multiplier: 31536000.0),
  ];

  static const List<UnitOption> speedUnits = [
    UnitOption(name: 'Meter per Second', abbreviation: 'm/s', multiplier: 1.0),
    UnitOption(name: 'Kilometer per Hour', abbreviation: 'km/h', multiplier: 0.277777777),
    UnitOption(name: 'Mile per Hour', abbreviation: 'mph', multiplier: 0.44704),
    UnitOption(name: 'Knot', abbreviation: 'kt', multiplier: 0.514444444),
    UnitOption(name: 'Foot per Second', abbreviation: 'ft/s', multiplier: 0.3048),
  ];

  static const List<UnitOption> dataUnits = [
    UnitOption(name: 'Byte', abbreviation: 'B', multiplier: 1.0),
    UnitOption(name: 'Kilobyte', abbreviation: 'KB', multiplier: 1024.0),
    UnitOption(name: 'Megabyte', abbreviation: 'MB', multiplier: 1048576.0),
    UnitOption(name: 'Gigabyte', abbreviation: 'GB', multiplier: 1073741824.0),
    UnitOption(name: 'Terabyte', abbreviation: 'TB', multiplier: 1099511627776.0),
    UnitOption(name: 'Petabyte', abbreviation: 'PB', multiplier: 1125899906842624.0),
  ];

  static const List<UnitOption> temperatureUnits = [
    UnitOption(name: 'Celsius', abbreviation: '°C', multiplier: 1.0),
    UnitOption(name: 'Fahrenheit', abbreviation: '°F', multiplier: 1.0),
    UnitOption(name: 'Kelvin', abbreviation: 'K', multiplier: 1.0),
  ];

  static const List<UnitOption> numeralUnits = [
    UnitOption(name: 'Decimal', abbreviation: 'DEC', multiplier: 10.0),
    UnitOption(name: 'Binary', abbreviation: 'BIN', multiplier: 2.0),
    UnitOption(name: 'Octal', abbreviation: 'OCT', multiplier: 8.0),
    UnitOption(name: 'Hexadecimal', abbreviation: 'HEX', multiplier: 16.0),
  ];

  static List<UnitOption> getUnitsForCategory(ConverterCategory category) {
    switch (category) {
      case ConverterCategory.length:
        return lengthUnits;
      case ConverterCategory.mass:
        return massUnits;
      case ConverterCategory.area:
        return areaUnits;
      case ConverterCategory.volume:
        return volumeUnits;
      case ConverterCategory.time:
        return timeUnits;
      case ConverterCategory.speed:
        return speedUnits;
      case ConverterCategory.temperature:
        return temperatureUnits;
      case ConverterCategory.data:
        return dataUnits;
      case ConverterCategory.numeral:
        return numeralUnits;
      default:
        return [];
    }
  }
}

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
    UnitOption(name: 'Kilometer', abbreviation: 'km', multiplier: 1000.0),
    UnitOption(name: 'Meter', abbreviation: 'm', multiplier: 1.0),
    UnitOption(name: 'Decimeter', abbreviation: 'dm', multiplier: 0.1),
    UnitOption(name: 'Centimeter', abbreviation: 'cm', multiplier: 0.01),
    UnitOption(name: 'Millimeter', abbreviation: 'mm', multiplier: 0.001),
    UnitOption(name: 'Micrometer', abbreviation: 'μm', multiplier: 0.000001),
    UnitOption(name: 'Nanometer', abbreviation: 'nm', multiplier: 0.000000001),
    UnitOption(name: 'Mile', abbreviation: 'mi', multiplier: 1609.344),
    UnitOption(name: 'Yard', abbreviation: 'yd', multiplier: 0.9144),
    UnitOption(name: 'Foot', abbreviation: 'ft', multiplier: 0.3048),
    UnitOption(name: 'Inch', abbreviation: 'in', multiplier: 0.0254),
    UnitOption(name: 'Nautical mile', abbreviation: 'nmi', multiplier: 1852.0),
  ];

  static const List<UnitOption> massUnits = [
    UnitOption(name: 'Tonne', abbreviation: 't', multiplier: 1000.0),
    UnitOption(name: 'Kilogram', abbreviation: 'kg', multiplier: 1.0),
    UnitOption(name: 'Gram', abbreviation: 'g', multiplier: 0.001),
    UnitOption(name: 'Milligram', abbreviation: 'mg', multiplier: 0.000001),
    UnitOption(name: 'Microgram', abbreviation: 'μg', multiplier: 0.000000001),
    UnitOption(name: 'Quintal', abbreviation: 'q', multiplier: 100.0),
    UnitOption(name: 'Pound', abbreviation: 'lb', multiplier: 0.45359237),
    UnitOption(name: 'Ounce', abbreviation: 'oz', multiplier: 0.028349523125),
    UnitOption(name: 'Carat', abbreviation: 'ct', multiplier: 0.0002),
    UnitOption(name: 'Grain', abbreviation: 'gr', multiplier: 0.00006479891),
    UnitOption(name: 'Long ton', abbreviation: 'lt', multiplier: 1016.0469088),
    UnitOption(name: 'Short ton', abbreviation: 'st', multiplier: 907.18474),
    UnitOption(name: 'UK hundredweight', abbreviation: 'cwt', multiplier: 50.80234544),
    UnitOption(name: 'US hundredweight', abbreviation: 'cwt', multiplier: 45.359237),
    UnitOption(name: 'Stone', abbreviation: 'st', multiplier: 6.35029318),
    UnitOption(name: 'Dram', abbreviation: 'dr', multiplier: 0.0017718451953125),
  ];

  static const List<UnitOption> areaUnits = [
    UnitOption(name: 'Square kilometer', abbreviation: 'km^2', multiplier: 1000000.0),
    UnitOption(name: 'Hectare', abbreviation: 'ha', multiplier: 10000.0),
    UnitOption(name: 'Are', abbreviation: 'a', multiplier: 100.0),
    UnitOption(name: 'Square meter', abbreviation: 'm^2', multiplier: 1.0),
    UnitOption(name: 'Square decimeter', abbreviation: 'dm^2', multiplier: 0.01),
    UnitOption(name: 'Square centimeter', abbreviation: 'cm^2', multiplier: 0.0001),
    UnitOption(name: 'Square millimeter', abbreviation: 'mm^2', multiplier: 0.000001),
    UnitOption(name: 'Square micron', abbreviation: 'μm^2', multiplier: 0.000000000001),
    UnitOption(name: 'Acre', abbreviation: 'ac', multiplier: 4046.8564224),
    UnitOption(name: 'Square mile', abbreviation: 'mi^2', multiplier: 2589988.110336),
    UnitOption(name: 'Square yard', abbreviation: 'yd^2', multiplier: 0.83612736),
    UnitOption(name: 'Square foot', abbreviation: 'ft^2', multiplier: 0.09290304),
    UnitOption(name: 'Square inch', abbreviation: 'in^2', multiplier: 0.00064516),
    UnitOption(name: 'Square rod', abbreviation: 'rd', multiplier: 25.29285264),
  ];

  static const List<UnitOption> volumeUnits = [
    UnitOption(name: 'Cubic meter', abbreviation: 'm^3', multiplier: 1000.0),
    UnitOption(name: 'Cubic decimeter', abbreviation: 'dm^3', multiplier: 1.0),
    UnitOption(name: 'Cubic centimeter', abbreviation: 'cm^3', multiplier: 0.001),
    UnitOption(name: 'Cubic millimeter', abbreviation: 'mm^3', multiplier: 0.000001),
    UnitOption(name: 'Hectoliter', abbreviation: 'hl', multiplier: 100.0),
    UnitOption(name: 'Liter', abbreviation: 'l', multiplier: 1.0),
    UnitOption(name: 'Deciliter', abbreviation: 'dl', multiplier: 0.1),
    UnitOption(name: 'Centiliter', abbreviation: 'cl', multiplier: 0.01),
    UnitOption(name: 'Milliliter', abbreviation: 'ml', multiplier: 0.001),
    UnitOption(name: 'Cubic foot', abbreviation: 'ft^3', multiplier: 28.316846592),
    UnitOption(name: 'Cubic inch', abbreviation: 'in^3', multiplier: 0.016387064),
  ];

  static const List<UnitOption> timeUnits = [
    UnitOption(name: 'Year', abbreviation: 'yr', multiplier: 31536000.0),
    UnitOption(name: 'Week', abbreviation: 'wk', multiplier: 604800.0),
    UnitOption(name: 'Day', abbreviation: 'd', multiplier: 86400.0),
    UnitOption(name: 'Hour', abbreviation: 'hr', multiplier: 3600.0),
    UnitOption(name: 'Minute', abbreviation: 'min', multiplier: 60.0),
    UnitOption(name: 'Second', abbreviation: 's', multiplier: 1.0),
    UnitOption(name: 'Millisecond', abbreviation: 'ms', multiplier: 0.001),
    UnitOption(name: 'Microsecond', abbreviation: 'μs', multiplier: 0.000001),
    UnitOption(name: 'Picosecond', abbreviation: 'ps', multiplier: 0.000000000001),
  ];

  static const List<UnitOption> speedUnits = [
    UnitOption(name: 'Lightspeed', abbreviation: 'c', multiplier: 299792458.0),
    UnitOption(name: 'Mach', abbreviation: 'Ma', multiplier: 340.3),
    UnitOption(name: 'Meter per second', abbreviation: 'm/s', multiplier: 1.0),
    UnitOption(name: 'Kilometer per hour', abbreviation: 'km/h', multiplier: 0.2777777777777778),
    UnitOption(name: 'Kilometer per second', abbreviation: 'km/s', multiplier: 1000.0),
    UnitOption(name: 'Knot', abbreviation: 'kn', multiplier: 0.5144444444444445),
    UnitOption(name: 'Mile per hour', abbreviation: 'mph', multiplier: 0.44704),
    UnitOption(name: 'Foot per second', abbreviation: 'fps', multiplier: 0.3048),
    UnitOption(name: 'Inch per second', abbreviation: 'ips', multiplier: 0.0254),
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
    UnitOption(name: 'Rankine', abbreviation: '°R', multiplier: 1.0),
    UnitOption(name: 'Réaumur', abbreviation: '°Re', multiplier: 1.0),
  ];

  static const List<UnitOption> numeralUnits = [
    UnitOption(name: 'Binary', abbreviation: 'BIN', multiplier: 2.0),
    UnitOption(name: 'Octal', abbreviation: 'OCT', multiplier: 8.0),
    UnitOption(name: 'Decimal', abbreviation: 'DEC', multiplier: 10.0),
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

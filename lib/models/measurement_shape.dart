enum MeasurementType { area, volume }

enum VolumeCategory {
  cubesAndPrisms,
  prismsAndPyramids,
  cylindersAndCones,
  spheresAndOthers,
  complexSiteWorks,
}

extension VolumeCategoryX on VolumeCategory {
  String get displayName {
    switch (this) {
      case VolumeCategory.cubesAndPrisms:
        return 'Cubes & Prisms';
      case VolumeCategory.prismsAndPyramids:
        return 'Prisms & Pyramids';
      case VolumeCategory.cylindersAndCones:
        return 'Cylinders & Cones';
      case VolumeCategory.spheresAndOthers:
        return 'Spheres & Domes';
      case VolumeCategory.complexSiteWorks:
        return 'Complex Site Works';
    }
  }
}

class DimensionFieldConfig {
  final String key;
  final String label;
  final String hint;
  final String symbol;

  const DimensionFieldConfig({
    required this.key,
    required this.label,
    required this.hint,
    required this.symbol,
  });
}

class ShapeDefinition {
  final String id;
  final String name;
  final MeasurementType type;
  final VolumeCategory? volumeCategory;
  final String description;
  final List<DimensionFieldConfig> fields;

  const ShapeDefinition({
    required this.id,
    required this.name,
    required this.type,
    this.volumeCategory,
    required this.description,
    required this.fields,
  });
}

class MeasurementResult {
  final double rawValue; // Raw Area (m² or sq ft) or Volume (m³ or cu ft)
  final double grossValueWithWastage;
  final double? totalCost;
  final double wastagePercentage;
  final double? unitCost;
  final String unitSymbol;
  final List<String> calculationSteps;

  const MeasurementResult({
    required this.rawValue,
    required this.grossValueWithWastage,
    this.totalCost,
    required this.wastagePercentage,
    this.unitCost,
    required this.unitSymbol,
    this.calculationSteps = const [],
  });
}

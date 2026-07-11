class UnitOption {
  final String name;
  final String abbreviation;
  final double multiplier; // Conversion multiplier relative to the base unit

  const UnitOption({
    required this.name,
    required this.abbreviation,
    required this.multiplier,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitOption &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          abbreviation == other.abbreviation;

  @override
  int get hashCode => name.hashCode ^ abbreviation.hashCode;
}

class CurrencyOption {
  final String name;
  final String isoCode;
  final double rate; // Rate relative to USD (USD = 1.0)

  const CurrencyOption({
    required this.name,
    required this.isoCode,
    required this.rate,
  });

  factory CurrencyOption.fromJson(Map<String, dynamic> json) {
    return CurrencyOption(
      name: json['name'] as String,
      isoCode: json['isoCode'] as String,
      rate: (json['rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isoCode': isoCode,
      'rate': rate,
    };
  }

  CurrencyOption copyWith({
    String? name,
    String? isoCode,
    double? rate,
  }) {
    return CurrencyOption(
      name: name ?? this.name,
      isoCode: isoCode ?? this.isoCode,
      rate: rate ?? this.rate,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyOption &&
          runtimeType == other.runtimeType &&
          isoCode == other.isoCode;

  @override
  int get hashCode => isoCode.hashCode;
}

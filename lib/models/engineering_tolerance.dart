enum ToleranceType {
  bilateral,
  unilateral,
  limit,
  geometric,
  general,
  unknown,
}

enum ToleranceSource {
  source,
  calculated,
  estimated,
}

class EngineeringTolerance {
  final String id;

  final ToleranceType type;

  final double? upper;
  final double? lower;

  final String? symbol;
  final String? datum;
  final String? zone;

  final String unit;

  final ToleranceSource source;
  final double confidence;

  final String? note;

  const EngineeringTolerance({
    required this.id,
    required this.type,
    this.upper,
    this.lower,
    this.symbol,
    this.datum,
    this.zone,
    this.unit = 'mm',
    required this.source,
    required this.confidence,
    this.note,
  });

  bool get hasUpper =>
      upper != null;

  bool get hasLower =>
      lower != null;

  bool get isBilateral =>
      type == ToleranceType.bilateral;

  bool get isUnilateral =>
      type == ToleranceType.unilateral;

  bool get isLimit =>
      type == ToleranceType.limit;

  bool get isGeometric =>
      type == ToleranceType.geometric;

  bool get isSource =>
      source == ToleranceSource.source;

  bool get isCalculated =>
      source == ToleranceSource.calculated;

  bool get isEstimated =>
      source == ToleranceSource.estimated;

  bool get requiresVerification =>
      source == ToleranceSource.estimated ||
      confidence < 0.8;
}

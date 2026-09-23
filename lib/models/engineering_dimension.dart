enum DimensionSource {
  source,
  calculated,
  estimated,
}

enum DimensionType {
  linear,
  diameter,
  radius,
  angle,
  depth,
  thread,
  tolerance,
  unknown,
}

class EngineeringDimension {
  final String id;
  final double value;
  final String unit;

  final DimensionType type;
  final DimensionSource source;

  final double confidence;

  final String? label;
  final String? tolerance;
  final String? note;

  const EngineeringDimension({
    required this.id,
    required this.value,
    required this.unit,
    required this.type,
    required this.source,
    required this.confidence,
    this.label,
    this.tolerance,
    this.note,
  });

  bool get isSource =>
      source == DimensionSource.source;

  bool get isCalculated =>
      source == DimensionSource.calculated;

  bool get isEstimated =>
      source == DimensionSource.estimated;

  bool get requiresVerification =>
      source == DimensionSource.estimated ||
      confidence < 0.8;
}

enum HoleType {
  through,
  blind,
  counterbore,
  countersink,
  threaded,
  unknown,
}

enum HoleSource {
  source,
  calculated,
  estimated,
}

class EngineeringHole {
  final String id;

  final double? diameter;
  final String diameterUnit;

  final double? depth;
  final String depthUnit;

  final HoleType type;
  final HoleSource source;

  final String? threadSpecification;
  final String? position;
  final String? tolerance;
  final String? note;

  final double confidence;

  const EngineeringHole({
    required this.id,
    this.diameter,
    this.diameterUnit = 'mm',
    this.depth,
    this.depthUnit = 'mm',
    required this.type,
    required this.source,
    required this.confidence,
    this.threadSpecification,
    this.position,
    this.tolerance,
    this.note,
  });

  bool get hasDiameter =>
      diameter != null;

  bool get hasDepth =>
      depth != null;

  bool get isThreaded =>
      type == HoleType.threaded ||
      threadSpecification != null;

  bool get isSource =>
      source == HoleSource.source;

  bool get isCalculated =>
      source == HoleSource.calculated;

  bool get isEstimated =>
      source == HoleSource.estimated;

  bool get requiresVerification =>
      source == HoleSource.estimated ||
      confidence < 0.8;
}

enum ThreadStandard {
  metric,
  unified,
  pipe,
  bsp,
  npt,
  unknown,
}

enum ThreadType {
  internal,
  external,
  unknown,
}

enum ThreadSource {
  source,
  calculated,
  estimated,
}

class EngineeringThread {
  final String id;

  final ThreadStandard standard;
  final ThreadType type;

  final String designation;
  final double? nominalDiameter;
  final double? pitch;

  final String diameterUnit;
  final String pitchUnit;

  final String? classOfFit;
  final String? depth;
  final String? tolerance;
  final String? note;

  final ThreadSource source;
  final double confidence;

  const EngineeringThread({
    required this.id,
    required this.standard,
    required this.type,
    required this.designation,
    this.nominalDiameter,
    this.pitch,
    this.diameterUnit = 'mm',
    this.pitchUnit = 'mm',
    this.classOfFit,
    this.depth,
    this.tolerance,
    this.note,
    required this.source,
    required this.confidence,
  });

  bool get isMetric =>
      standard == ThreadStandard.metric;

  bool get isInternal =>
      type == ThreadType.internal;

  bool get isExternal =>
      type == ThreadType.external;

  bool get isSource =>
      source == ThreadSource.source;

  bool get isCalculated =>
      source == ThreadSource.calculated;

  bool get isEstimated =>
      source == ThreadSource.estimated;

  bool get requiresVerification =>
      source == ThreadSource.estimated ||
      confidence < 0.8;
}

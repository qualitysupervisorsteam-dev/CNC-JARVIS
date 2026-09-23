enum EngineeringFeatureType {
  hole,
  threadedHole,
  slot,
  pocket,
  boss,
  groove,
  chamfer,
  fillet,
  step,
  shaft,
  flange,
  keyway,
  thread,
  surface,
  unknown,
}

enum FeatureSource {
  source,
  calculated,
  estimated,
}

class EngineeringFeature {
  final String id;
  final EngineeringFeatureType type;

  final String? name;
  final String? description;

  final Map<String, double> dimensions;
  final Map<String, String> parameters;

  final FeatureSource source;
  final double confidence;

  final String? note;

  const EngineeringFeature({
    required this.id,
    required this.type,
    this.name,
    this.description,
    this.dimensions = const {},
    this.parameters = const {},
    required this.source,
    required this.confidence,
    this.note,
  });

  bool get hasDimensions =>
      dimensions.isNotEmpty;

  bool get hasParameters =>
      parameters.isNotEmpty;

  bool get isHole =>
      type == EngineeringFeatureType.hole ||
      type == EngineeringFeatureType.threadedHole;

  bool get isThread =>
      type == EngineeringFeatureType.thread;

  bool get isSource =>
      source == FeatureSource.source;

  bool get isCalculated =>
      source == FeatureSource.calculated;

  bool get isEstimated =>
      source == FeatureSource.estimated;

  bool get requiresVerification =>
      source == FeatureSource.estimated ||
      confidence < 0.8;
}

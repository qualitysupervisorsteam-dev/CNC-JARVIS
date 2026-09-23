import 'engineering_model.dart';

enum DrawingSourceType {
  image,
  pdf,
  dxf,
  dwg,
  step,
  iges,
  unknown,
}

enum EngineeringValueSource {
  source,
  calculated,
  estimated,
}

class EngineeringValue<T> {
  final T value;
  final EngineeringValueSource source;
  final double confidence;
  final String? note;

  const EngineeringValue({
    required this.value,
    required this.source,
    required this.confidence,
    this.note,
  });
}

class DrawingDimension {
  final String id;
  final EngineeringValue<double> value;
  final String unit;
  final String? tolerance;
  final String? label;

  const DrawingDimension({
    required this.id,
    required this.value,
    required this.unit,
    this.tolerance,
    this.label,
  });
}

class DrawingHole {
  final String id;
  final EngineeringValue<double>? diameter;
  final EngineeringValue<double>? depth;
  final String? holeType;
  final String? threadSpecification;
  final String? note;

  const DrawingHole({
    required this.id,
    this.diameter,
    this.depth,
    this.holeType,
    this.threadSpecification,
    this.note,
  });
}

class DrawingAnalysis {
  final DrawingSourceType sourceType;

  final List<DrawingDimension> dimensions;
  final List<DrawingHole> holes;
  final List<String> threads;
  final List<String> tolerances;
  final List<String> materials;
  final List<String> features;

  final double overallConfidence;
  final bool geometryReady;

  final EngineeringModel? engineeringModel;

  final String? warning;

  const DrawingAnalysis({
    required this.sourceType,
    this.dimensions = const [],
    this.holes = const [],
    this.threads = const [],
    this.tolerances = const [],
    this.materials = const [],
    this.features = const [],
    this.overallConfidence = 0,
    this.geometryReady = false,
    this.engineeringModel,
    this.warning,
  });

  const DrawingAnalysis.empty()
      : sourceType = DrawingSourceType.unknown,
        dimensions = const [],
        holes = const [],
        threads = const [],
        tolerances = const [],
        materials = const [],
        features = const [],
        overallConfidence = 0,
        geometryReady = false,
        engineeringModel = null,
        warning = null;

  bool get hasEngineeringModel =>
      engineeringModel != null;

  bool get requiresVerification =>
      engineeringModel?.requiresVerification ?? true;
}

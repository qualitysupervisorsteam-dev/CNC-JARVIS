import 'drawing_analysis.dart';
import 'engineering_model.dart';

class AnalysisResult {
  final List<DrawingDimension> dimensions;
  final List<DrawingHole> holes;
  final List<String> threads;
  final List<String> tolerances;
  final List<String> materials;
  final List<String> features;

  final double confidence;
  final bool geometryReady;

  final EngineeringModel? engineeringModel;

  final List<AnalysisWarning> warnings;

  const AnalysisResult({
    this.dimensions = const [],
    this.holes = const [],
    this.threads = const [],
    this.tolerances = const [],
    this.materials = const [],
    this.features = const [],
    this.confidence = 0,
    this.geometryReady = false,
    this.engineeringModel,
    this.warnings = const [],
  });

  const AnalysisResult.empty()
      : dimensions = const [],
        holes = const [],
        threads = const [],
        tolerances = const [],
        materials = const [],
        features = const [],
        confidence = 0,
        geometryReady = false,
        engineeringModel = null,
        warnings = const [];

  bool get hasWarnings =>
      warnings.isNotEmpty;

  bool get hasGeometry =>
      geometryReady;

  bool get hasEngineeringModel =>
      engineeringModel != null;
}

enum AnalysisWarningType {
  lowConfidence,
  missingDimension,
  ambiguousGeometry,
  unsupportedFormat,
  processingError,
}

class AnalysisWarning {
  final AnalysisWarningType type;
  final String message;
  final String? relatedFeature;

  const AnalysisWarning({
    required this.type,
    required this.message,
    this.relatedFeature,
  });
}

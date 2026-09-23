import '../models/analysis_result.dart';
import '../models/drawing_analysis.dart';
import '../models/drawing_project.dart';
import 'analyzers/drawing_analyzer_registry.dart';

class DrawingAnalysisService {
  Future<DrawingAnalysis> analyze(
    DrawingProject project,
  ) async {
    final result = await DrawingAnalyzerRegistry.analyze(
      project,
    );

    return _convertResult(
      project,
      result,
    );
  }

  DrawingAnalysis _convertResult(
    DrawingProject project,
    AnalysisResult result,
  ) {
    final sourceType = _detectSourceType(
      project.fileExtension,
    );

    final warning = result.warnings.isNotEmpty
        ? result.warnings.first.message
        : null;

    return DrawingAnalysis(
      sourceType: sourceType,
      dimensions: result.dimensions,
      holes: result.holes,
      threads: result.threads,
      tolerances: result.tolerances,
      materials: result.materials,
      features: result.features,
      overallConfidence: result.confidence,
      geometryReady: result.geometryReady,
      engineeringModel: result.engineeringModel,
      warning: warning,
    );
  }

  DrawingSourceType _detectSourceType(
    String extension,
  ) {
    switch (extension.toLowerCase()) {
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'webp':
        return DrawingSourceType.image;

      case 'pdf':
        return DrawingSourceType.pdf;

      case 'dxf':
        return DrawingSourceType.dxf;

      case 'dwg':
        return DrawingSourceType.dwg;

      case 'step':
      case 'stp':
        return DrawingSourceType.step;

      case 'iges':
      case 'igs':
        return DrawingSourceType.iges;

      default:
        return DrawingSourceType.unknown;
    }
  }
}

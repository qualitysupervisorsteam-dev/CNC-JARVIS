import '../../models/analysis_result.dart';
import '../../models/drawing_project.dart';
import 'drawing_analyzer.dart';

class IgesDrawingAnalyzer extends DrawingAnalyzer {
  const IgesDrawingAnalyzer();

  @override
  bool supports(String extension) {
    switch (extension.toLowerCase()) {
      case 'iges':
      case 'igs':
        return true;
      default:
        return false;
    }
  }

  @override
  Future<AnalysisResult> analyze(
    DrawingProject project,
  ) async {
    return const AnalysisResult(
      confidence: 0,
      geometryReady: false,
      warnings: [
        AnalysisWarning(
          type: AnalysisWarningType.processingError,
          message:
              'IGES CAD geometry engine is not connected yet.',
        ),
      ],
    );
  }
}

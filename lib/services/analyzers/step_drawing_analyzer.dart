import '../../models/analysis_result.dart';
import '../../models/drawing_project.dart';
import 'drawing_analyzer.dart';

class StepDrawingAnalyzer extends DrawingAnalyzer {
  const StepDrawingAnalyzer();

  @override
  bool supports(String extension) {
    switch (extension.toLowerCase()) {
      case 'step':
      case 'stp':
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
              'STEP CAD geometry engine is not connected yet.',
        ),
      ],
    );
  }
}

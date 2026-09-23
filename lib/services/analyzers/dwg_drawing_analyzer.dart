import '../../models/analysis_result.dart';
import '../../models/drawing_project.dart';
import 'drawing_analyzer.dart';

class DwgDrawingAnalyzer extends DrawingAnalyzer {
  const DwgDrawingAnalyzer();

  @override
  bool supports(String extension) {
    return extension.toLowerCase() == 'dwg';
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
              'DWG geometry engine is not connected yet.',
        ),
      ],
    );
  }
}

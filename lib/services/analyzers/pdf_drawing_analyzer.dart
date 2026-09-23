import '../../models/analysis_result.dart';
import '../../models/drawing_project.dart';
import 'drawing_analyzer.dart';

class PdfDrawingAnalyzer extends DrawingAnalyzer {
  const PdfDrawingAnalyzer();

  @override
  bool supports(String extension) {
    return extension.toLowerCase() == 'pdf';
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
              'PDF engineering analysis engine is not connected yet.',
        ),
      ],
    );
  }
}

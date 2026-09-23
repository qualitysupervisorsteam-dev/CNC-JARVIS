import '../../models/analysis_result.dart';
import '../../models/drawing_project.dart';
import 'drawing_analyzer.dart';

class DxfDrawingAnalyzer extends DrawingAnalyzer {
  const DxfDrawingAnalyzer();

  @override
  bool supports(String extension) {
    return extension.toLowerCase() == 'dxf';
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
              'DXF geometry parser is not connected yet.',
        ),
      ],
    );
  }
}

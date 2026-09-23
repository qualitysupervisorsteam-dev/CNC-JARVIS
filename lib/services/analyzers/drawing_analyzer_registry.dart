import '../../models/analysis_result.dart';
import '../../models/drawing_project.dart';
import 'drawing_analyzer.dart';
import 'dxf_drawing_analyzer.dart';
import 'dwg_drawing_analyzer.dart';
import 'iges_drawing_analyzer.dart';
import 'image_drawing_analyzer.dart';
import 'pdf_drawing_analyzer.dart';
import 'step_drawing_analyzer.dart';

class DrawingAnalyzerRegistry {
  static const List<DrawingAnalyzer> analyzers = [
    ImageDrawingAnalyzer(),
    PdfDrawingAnalyzer(),
    DxfDrawingAnalyzer(),
    DwgDrawingAnalyzer(),
    StepDrawingAnalyzer(),
    IgesDrawingAnalyzer(),
  ];

  static DrawingAnalyzer? findAnalyzer(
    String extension,
  ) {
    final normalizedExtension =
        extension.toLowerCase().replaceFirst('.', '');

    for (final analyzer in analyzers) {
      if (analyzer.supports(normalizedExtension)) {
        return analyzer;
      }
    }

    return null;
  }

  static Future<AnalysisResult> analyze(
    DrawingProject project,
  ) async {
    final analyzer = findAnalyzer(
      project.fileExtension,
    );

    if (analyzer == null) {
      return const AnalysisResult(
        confidence: 0,
        geometryReady: false,
        warnings: [
          AnalysisWarning(
            type: AnalysisWarningType.unsupportedFormat,
            message:
                'No analyzer is available for this file format.',
          ),
        ],
      );
    }

    return analyzer.analyze(project);
  }
}

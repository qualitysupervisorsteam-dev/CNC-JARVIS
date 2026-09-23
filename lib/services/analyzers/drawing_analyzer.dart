import '../../models/analysis_result.dart';
import '../../models/drawing_project.dart';

abstract class DrawingAnalyzer {
  const DrawingAnalyzer();

  bool supports(String extension);

  Future<AnalysisResult> analyze(
    DrawingProject project,
  );
}

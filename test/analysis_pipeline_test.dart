import 'package:flutter_test/flutter_test.dart';

import 'package:cnc_jarvis/models/drawing_project.dart';
import 'package:cnc_jarvis/services/analyzers/drawing_analyzer_registry.dart';

void main() {
  group('Drawing Analyzer Registry', () {
    test('finds image analyzer', () {
      final analyzer =
          DrawingAnalyzerRegistry.findAnalyzer('png');

      expect(analyzer, isNotNull);
    });

    test('finds PDF analyzer', () {
      final analyzer =
          DrawingAnalyzerRegistry.findAnalyzer('pdf');

      expect(analyzer, isNotNull);
    });

    test('finds DXF analyzer', () {
      final analyzer =
          DrawingAnalyzerRegistry.findAnalyzer('dxf');

      expect(analyzer, isNotNull);
    });

    test('finds DWG analyzer', () {
      final analyzer =
          DrawingAnalyzerRegistry.findAnalyzer('dwg');

      expect(analyzer, isNotNull);
    });

    test('finds STEP analyzer', () {
      final analyzer =
          DrawingAnalyzerRegistry.findAnalyzer('step');

      expect(analyzer, isNotNull);
    });

    test('finds IGES analyzer', () {
      final analyzer =
          DrawingAnalyzerRegistry.findAnalyzer('iges');

      expect(analyzer, isNotNull);
    });

    test('returns null for unsupported format', () {
      final analyzer =
          DrawingAnalyzerRegistry.findAnalyzer('xyz');

      expect(analyzer, isNull);
    });
  });

  group('Drawing Analyzer Execution', () {
    test('analyzes a PDF project', () async {
      const project = DrawingProject(
        name: 'Test Drawing',
        fileName: 'test.pdf',
        filePath: null,
        fileExtension: 'pdf',
      );

      final result =
          await DrawingAnalyzerRegistry.analyze(
        project,
      );

      expect(result.confidence, 0);
      expect(result.geometryReady, false);
      expect(result.warnings, isNotEmpty);
    });
  });
}

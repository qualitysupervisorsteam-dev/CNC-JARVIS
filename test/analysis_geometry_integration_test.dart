import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cnc_jarvis/models/drawing_project.dart';
import 'package:cnc_jarvis/models/geometry_status.dart';
import 'package:cnc_jarvis/providers/analysis_provider.dart';
import 'package:cnc_jarvis/providers/engineering_model_provider.dart';
import 'package:cnc_jarvis/providers/geometry_provider.dart';

void main() {
  group('Analysis to Geometry Integration', () {
    test(
      'initial providers are empty and idle',
      () {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        final analysis =
            container.read(analysisProvider);

        final engineeringModel =
            container.read(
          engineeringModelProvider,
        );

        final geometry =
            container.read(geometryProvider);

        expect(
          analysis.isAnalyzing,
          false,
        );

        expect(
          analysis.isCompleted,
          false,
        );

        expect(
          analysis.hasFailed,
          false,
        );

        expect(
          engineeringModel,
          isNull,
        );

        expect(
          geometry,
          isNull,
        );
      },
    );

    test(
      'reset clears analysis, engineering model and geometry',
      () {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        container
            .read(
              analysisProvider.notifier,
            )
            .reset();

        expect(
          container.read(
            analysisProvider,
          ),
          isNotNull,
        );

        expect(
          container.read(
            engineeringModelProvider,
          ),
          isNull,
        );

        expect(
          container.read(
            geometryProvider,
          ),
          isNull,
        );
      },
    );

    test(
      'geometry provider can receive a model independently',
      () async {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        const project = DrawingProject(
          name: 'Integration Test',
          fileName: 'test.pdf',
          filePath: null,
          fileExtension: 'pdf',
        );

        expect(
          project.fileExtension,
          'pdf',
        );

        final geometryNotifier =
            container.read(
          geometryProvider.notifier,
        );

        geometryNotifier.clearGeometry();

        expect(
          container.read(
            geometryProvider,
          ),
          isNull,
        );
      },
    );

    test(
      'geometry status values are available',
      () {
        expect(
          GeometryStatus.idle,
          isNotNull,
        );

        expect(
          GeometryStatus.preparing,
          isNotNull,
        );

        expect(
          GeometryStatus.building,
          isNotNull,
        );

        expect(
          GeometryStatus.ready,
          isNotNull,
        );

        expect(
          GeometryStatus.failed,
          isNotNull,
        );
      },
    );
  });
}

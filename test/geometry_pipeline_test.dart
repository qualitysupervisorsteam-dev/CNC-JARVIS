import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cnc_jarvis/models/engineering_model.dart';
import 'package:cnc_jarvis/models/geometry_status.dart';
import 'package:cnc_jarvis/providers/geometry_provider.dart';

void main() {
  group('Geometry Build Pipeline', () {
    test(
      'builds geometry from engineering model',
      () async {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        const engineeringModel = EngineeringModel(
          id: 'MODEL1',
          name: 'Test CNC Part',
          confidence: 1.0,
          geometryReady: false,
          verified: true,
        );

        await container
            .read(geometryProvider.notifier)
            .buildFromEngineeringModel(
              engineeringModel,
            );

        final geometry =
            container.read(geometryProvider);

        expect(geometry, isNotNull);

        expect(
          geometry!.id,
          'GEO-MODEL1',
        );

        expect(
          geometry.name,
          'Test CNC Part',
        );

        expect(
          geometry.status,
          GeometryStatus.ready,
        );

        expect(
          geometry.hasSolidGeometry,
          false,
        );

        expect(
          geometry.verified,
          false,
        );

        expect(
          geometry.hasError,
          false,
        );
      },
    );

    test(
      'mock geometry engine does not claim real solid geometry',
      () async {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        const engineeringModel = EngineeringModel(
          id: 'MODEL2',
          name: 'Mock Part',
          confidence: 0.95,
        );

        await container
            .read(geometryProvider.notifier)
            .buildFromEngineeringModel(
              engineeringModel,
            );

        final geometry =
            container.read(geometryProvider);

        expect(geometry, isNotNull);

        expect(
          geometry!.hasGeometry,
          false,
        );

        expect(
          geometry.solidCount,
          0,
        );

        expect(
          geometry.bodyCount,
          0,
        );
      },
    );
  });
}

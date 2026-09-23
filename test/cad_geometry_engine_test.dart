import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:cnc_jarvis/models/engineering_model.dart';
import 'package:cnc_jarvis/models/geometry_source.dart';
import 'package:cnc_jarvis/services/geometry/cad_geometry_engine.dart';

void main() {
  group(
    'CadGeometryEngine',
    () {
      test(
        'requires a geometry source',
        () async {
          final engine =
              CadGeometryEngine();

          const model = EngineeringModel(
            id: 'ENG-001',
            name: 'Test Part',
            geometryReady: true,
          );

          expect(
            () => engine.buildGeometry(model),
            throwsStateError,
          );
        },
      );

      test(
        'rejects non-direct CAD formats',
        () async {
          final engine =
              CadGeometryEngine();

          engine.setSource(
            const GeometrySource(
              path: 'drawing.pdf',
              format:
                  GeometrySourceFormat.pdf,
            ),
          );

          const model = EngineeringModel(
            id: 'ENG-002',
            name: 'Drawing Part',
            geometryReady: true,
          );

          expect(
            () => engine.buildGeometry(model),
            throwsUnsupportedError,
          );
        },
      );

      test(
        'imports STEP through native CAD',
        () async {
          if (!Platform.isWindows) {
            return;
          }

          final engine =
              CadGeometryEngine();

          engine.setSource(
            const GeometrySource(
              path: 'mock_part.step',
              format:
                  GeometrySourceFormat.step,
            ),
          );

          const model = EngineeringModel(
            id: 'ENG-003',
            name: 'STEP Test Part',
            confidence: 0.95,
            geometryReady: true,
          );

          final geometry =
              await engine.buildGeometry(
            model,
          );

          expect(
            geometry.geometryFormat,
            'STEP',
          );

          expect(
            geometry.geometryPath,
            'mock_part.step',
          );

          expect(
            geometry.name,
            'STEP Test Part',
          );

          expect(
            geometry.bodyCount,
            1,
          );

          expect(
            geometry.solidCount,
            1,
          );

          expect(
            geometry.surfaceCount,
            6,
          );

          expect(
            geometry.hasSolidGeometry,
            isTrue,
          );

          expect(
            geometry.verified,
            isTrue,
          );
        },
      );

      test(
        'imports IGES through native CAD',
        () async {
          if (!Platform.isWindows) {
            return;
          }

          final engine =
              CadGeometryEngine();

          engine.setSource(
            const GeometrySource(
              path: 'mock_part.iges',
              format:
                  GeometrySourceFormat.iges,
            ),
          );

          const model = EngineeringModel(
            id: 'ENG-004',
            name: 'IGES Test Part',
            confidence: 0.90,
            geometryReady: true,
          );

          final geometry =
              await engine.buildGeometry(
            model,
          );

          expect(
            geometry.geometryFormat,
            'IGES',
          );

          expect(
            geometry.geometryPath,
            'mock_part.iges',
          );

          expect(
            geometry.name,
            'IGES Test Part',
          );

          expect(
            geometry.bodyCount,
            1,
          );

          expect(
            geometry.solidCount,
            1,
          );

          expect(
            geometry.surfaceCount,
            6,
          );
        },
      );

      test(
        'can clear the configured source',
        () {
          final engine =
              CadGeometryEngine();

          const source = GeometrySource(
            path: 'mock_part.step',
            format:
                GeometrySourceFormat.step,
          );

          engine.setSource(source);

          expect(
            engine.source,
            isNotNull,
          );

          engine.clearSource();

          expect(
            engine.source,
            isNull,
          );
        },
      );
    },
  );
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:cnc_jarvis/models/engineering_model.dart';
import 'package:cnc_jarvis/models/geometry_source.dart';
import 'package:cnc_jarvis/services/geometry/geometry_service.dart';

void main() {
  group(
    'GeometryService',
    () {
      test(
        'builds geometry through native CAD for STEP',
        () async {
          if (!Platform.isWindows) {
            return;
          }

          final service =
              GeometryService();

          const engineeringModel =
              EngineeringModel(
            id: 'ENG-SERVICE-001',
            name: 'Service STEP Part',
            confidence: 0.97,
            geometryReady: true,
          );

          const source = GeometrySource(
            path: 'mock_part.step',
            format:
                GeometrySourceFormat.step,
          );

          final geometry =
              await service.buildGeometry(
            engineeringModel,
            source: source,
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
            'Service STEP Part',
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
        'builds geometry through native CAD for IGES',
        () async {
          if (!Platform.isWindows) {
            return;
          }

          final service =
              GeometryService();

          const engineeringModel =
              EngineeringModel(
            id: 'ENG-SERVICE-002',
            name: 'Service IGES Part',
            confidence: 0.92,
            geometryReady: true,
          );

          const source = GeometrySource(
            path: 'mock_part.iges',
            format:
                GeometrySourceFormat.iges,
          );

          final geometry =
              await service.buildGeometry(
            engineeringModel,
            source: source,
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
            'Service IGES Part',
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
        'keeps the legacy geometry path available',
        () async {
          final service =
              GeometryService();

          const engineeringModel =
              EngineeringModel(
            id: 'ENG-SERVICE-003',
            name: 'Legacy Geometry Part',
          );

          final geometry =
              await service.buildGeometry(
            engineeringModel,
          );

          expect(
            geometry,
            isNotNull,
          );

          expect(
            geometry.name,
            'Legacy Geometry Part',
          );
        },
      );
    },
  );
}

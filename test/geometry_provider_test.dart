import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cnc_jarvis/models/geometry_model.dart';
import 'package:cnc_jarvis/models/geometry_status.dart';
import 'package:cnc_jarvis/providers/geometry_provider.dart';

void main() {
  group(
    'GeometryNotifier',
    () {
      test(
        'starts with null geometry',
        () {
          final container =
              ProviderContainer();

          addTearDown(
            container.dispose,
          );

          final geometry =
              container.read(
            geometryProvider,
          );

          expect(
            geometry,
            isNull,
          );
        },
      );

      test(
        'can set geometry',
        () {
          final container =
              ProviderContainer();

          addTearDown(
            container.dispose,
          );

          final geometry =
              GeometryModel(
            id: 'GEO-001',
            name: 'Test Part',
            status:
                GeometryStatus.ready,
            confidence: 0.95,
            verified: true,
          );

          container
              .read(
                geometryProvider
                    .notifier,
              )
              .setGeometry(
                geometry,
              );

          final result =
              container.read(
            geometryProvider,
          );

          expect(
            result,
            isNotNull,
          );

          expect(
            result!.id,
            'GEO-001',
          );

          expect(
            result.name,
            'Test Part',
          );

          expect(
            result.status,
            GeometryStatus.ready,
          );
        },
      );

      test(
        'can update geometry',
        () {
          final container =
              ProviderContainer();

          addTearDown(
            container.dispose,
          );

          final first =
              GeometryModel(
            id: 'GEO-001',
            name: 'First Part',
            status:
                GeometryStatus.building,
            confidence: 0.80,
            verified: false,
          );

          final second =
              GeometryModel(
            id: 'GEO-001',
            name: 'First Part',
            status:
                GeometryStatus.ready,
            confidence: 0.95,
            verified: true,
          );

          container
              .read(
                geometryProvider
                    .notifier,
              )
              .setGeometry(
                first,
              );

          container
              .read(
                geometryProvider
                    .notifier,
              )
              .updateGeometry(
                second,
              );

          final result =
              container.read(
            geometryProvider,
          );

          expect(
            result,
            isNotNull,
          );

          expect(
            result!.status,
            GeometryStatus.ready,
          );

          expect(
            result.verified,
            isTrue,
          );
        },
      );

      test(
        'can change geometry status',
        () {
          final container =
              ProviderContainer();

          addTearDown(
            container.dispose,
          );

          final geometry =
              GeometryModel(
            id: 'GEO-001',
            name: 'Test Part',
            status:
                GeometryStatus.building,
            confidence: 0.90,
            verified: false,
          );

          container
              .read(
                geometryProvider
                    .notifier,
              )
              .setGeometry(
                geometry,
              );

          container
              .read(
                geometryProvider
                    .notifier,
              )
              .setStatus(
                GeometryStatus.ready,
              );

          final result =
              container.read(
            geometryProvider,
          );

          expect(
            result,
            isNotNull,
          );

          expect(
            result!.status,
            GeometryStatus.ready,
          );
        },
      );

      test(
        'can clear geometry',
        () {
          final container =
              ProviderContainer();

          addTearDown(
            container.dispose,
          );

          final geometry =
              GeometryModel(
            id: 'GEO-001',
            name: 'Test Part',
            status:
                GeometryStatus.ready,
            confidence: 0.95,
            verified: true,
          );

          container
              .read(
                geometryProvider
                    .notifier,
              )
              .setGeometry(
                geometry,
              );

          container
              .read(
                geometryProvider
                    .notifier,
              )
              .clearGeometry();

          final result =
              container.read(
            geometryProvider,
          );

          expect(
            result,
            isNull,
          );
        },
      );
    },
  );
}

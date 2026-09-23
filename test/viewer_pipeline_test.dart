import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cnc_jarvis/models/geometry_model.dart';
import 'package:cnc_jarvis/models/geometry_status.dart';
import 'package:cnc_jarvis/models/viewer_state.dart';
import 'package:cnc_jarvis/providers/viewer_provider.dart';

void main() {
  group('Viewer Pipeline', () {
    test(
      'viewer initializes successfully',
      () async {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        final notifier =
            container.read(
          viewerProvider.notifier,
        );

        await notifier.initialize();

        final state =
            container.read(viewerProvider);

        expect(
          state,
          isNotNull,
        );

        expect(
          state.projection,
          ViewerProjection.perspective,
        );
      },
    );

    test(
      'viewer loads geometry',
      () async {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        const geometry = GeometryModel(
          id: 'GEO-001',
          name: 'Test Part',
          status: GeometryStatus.ready,
          confidence: 1,
          hasSolidGeometry: false,
          verified: false,
        );

        final notifier =
            container.read(
          viewerProvider.notifier,
        );

        await notifier.initialize();

        await notifier.loadGeometry(
          geometry,
        );

        expect(
          geometry.id,
          'GEO-001',
        );

        expect(
          geometry.name,
          'Test Part',
        );

        expect(
          geometry.status,
          GeometryStatus.ready,
        );
      },
    );

    test(
      'viewer updates projection and render mode',
      () async {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        final notifier =
            container.read(
          viewerProvider.notifier,
        );

        await notifier.initialize();

        await notifier.setProjection(
          ViewerProjection.orthographic,
        );

        await notifier.setRenderMode(
          ViewerRenderMode.wireframe,
        );

        final state =
            container.read(viewerProvider);

        expect(
          state.projection,
          ViewerProjection.orthographic,
        );

        expect(
          state.renderMode,
          ViewerRenderMode.wireframe,
        );
      },
    );

    test(
      'viewer updates zoom and rotation',
      () async {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        final notifier =
            container.read(
          viewerProvider.notifier,
        );

        await notifier.initialize();

        await notifier.setZoom(3);

        await notifier.rotate(
          x: 45,
          y: 90,
          z: 180,
        );

        final state =
            container.read(viewerProvider);

        expect(
          state.zoom,
          3,
        );

        expect(
          state.rotationX,
          45,
        );

        expect(
          state.rotationY,
          90,
        );

        expect(
          state.rotationZ,
          180,
        );
      },
    );

    test(
      'viewer section mode updates correctly',
      () async {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        final notifier =
            container.read(
          viewerProvider.notifier,
        );

        await notifier.initialize();

        await notifier.enableSection(
          'XZ',
        );

        var state =
            container.read(viewerProvider);

        expect(
          state.sectionEnabled,
          true,
        );

        expect(
          state.sectionPlane,
          'XZ',
        );

        await notifier.disableSection();

        state =
            container.read(viewerProvider);

        expect(
          state.sectionEnabled,
          false,
        );

        expect(
          state.sectionPlane,
          isNull,
        );
      },
    );

    test(
      'reset restores viewer defaults',
      () async {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        final notifier =
            container.read(
          viewerProvider.notifier,
        );

        await notifier.initialize();

        await notifier.setProjection(
          ViewerProjection.orthographic,
        );

        await notifier.setRenderMode(
          ViewerRenderMode.wireframe,
        );

        await notifier.setZoom(5);

        await notifier.enableSection(
          'YZ',
        );

        await notifier.resetView();

        final state =
            container.read(viewerProvider);

        expect(
          state.projection,
          ViewerProjection.perspective,
        );

        expect(
          state.renderMode,
          ViewerRenderMode.shaded,
        );

        expect(
          state.zoom,
          1,
        );

        expect(
          state.sectionEnabled,
          false,
        );

        expect(
          state.sectionPlane,
          isNull,
        );
      },
    );
  });
}

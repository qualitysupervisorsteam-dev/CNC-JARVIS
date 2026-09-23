import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cnc_jarvis/models/viewer_state.dart';
import 'package:cnc_jarvis/providers/viewer_provider.dart';

void main() {
  group('Viewer Provider', () {
    test(
      'starts with default viewer state',
      () {
        final container = ProviderContainer();

        addTearDown(container.dispose);

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
          state.interactionMode,
          ViewerInteractionMode.orbit,
        );

        expect(
          state.zoom,
          1,
        );

        expect(
          state.showDimensions,
          true,
        );

        expect(
          state.showAxes,
          true,
        );

        expect(
          state.showGrid,
          true,
        );

        expect(
          state.sectionEnabled,
          false,
        );
      },
    );

    test(
      'changes projection',
      () {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        container
            .read(viewerProvider.notifier)
            .setProjection(
              ViewerProjection.orthographic,
            );

        expect(
          container.read(viewerProvider).projection,
          ViewerProjection.orthographic,
        );
      },
    );

    test(
      'changes render mode',
      () {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        container
            .read(viewerProvider.notifier)
            .setRenderMode(
              ViewerRenderMode.wireframe,
            );

        expect(
          container.read(viewerProvider).renderMode,
          ViewerRenderMode.wireframe,
        );
      },
    );

    test(
      'changes interaction mode',
      () {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        container
            .read(viewerProvider.notifier)
            .setInteractionMode(
              ViewerInteractionMode.measure,
            );

        expect(
          container.read(viewerProvider).interactionMode,
          ViewerInteractionMode.measure,
        );
      },
    );

    test(
      'changes zoom',
      () {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        container
            .read(viewerProvider.notifier)
            .setZoom(2);

        expect(
          container.read(viewerProvider).zoom,
          2,
        );

        container
            .read(viewerProvider.notifier)
            .zoomIn();

        expect(
          container.read(viewerProvider).zoom,
          greaterThan(2),
        );

        container
            .read(viewerProvider.notifier)
            .zoomOut();

        expect(
          container.read(viewerProvider).zoom,
          closeTo(2, 0.001),
        );
      },
    );

    test(
      'toggles viewer overlays',
      () {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        final notifier =
            container.read(viewerProvider.notifier);

        notifier.toggleDimensions();
        notifier.toggleAxes();
        notifier.toggleGrid();

        final state =
            container.read(viewerProvider);

        expect(
          state.showDimensions,
          false,
        );

        expect(
          state.showAxes,
          false,
        );

        expect(
          state.showGrid,
          false,
        );
      },
    );

    test(
      'enables and disables section mode',
      () {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        final notifier =
            container.read(viewerProvider.notifier);

        notifier.enableSection('XY');

        var state =
            container.read(viewerProvider);

        expect(
          state.sectionEnabled,
          true,
        );

        expect(
          state.sectionPlane,
          'XY',
        );

        notifier.disableSection();

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
      'reset view restores defaults',
      () {
        final container = ProviderContainer();

        addTearDown(container.dispose);

        final notifier =
            container.read(viewerProvider.notifier);

        notifier.setProjection(
          ViewerProjection.orthographic,
        );

        notifier.setRenderMode(
          ViewerRenderMode.wireframe,
        );

        notifier.setZoom(5);

        notifier.enableSection('YZ');

        notifier.resetView();

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

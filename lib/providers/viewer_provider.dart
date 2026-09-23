import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/geometry_model.dart';
import '../models/viewer_state.dart';
import '../services/viewer/viewer_service.dart';

class ViewerNotifier extends Notifier<ViewerState> {
  final ViewerService _service =
      ViewerService();

  @override
  ViewerState build() {
    return const ViewerState();
  }

  Future<void> initialize() async {
    await _service.initialize();
  }

  Future<void> loadGeometry(
    GeometryModel geometry,
  ) async {
    await _service.loadGeometry(
      geometry,
    );
  }

  Future<void> setProjection(
    ViewerProjection projection,
  ) async {
    state = state.copyWith(
      projection: projection,
    );

    await _service.updateView(
      state,
    );
  }

  Future<void> setRenderMode(
    ViewerRenderMode renderMode,
  ) async {
    state = state.copyWith(
      renderMode: renderMode,
    );

    await _service.updateView(
      state,
    );
  }

  Future<void> setInteractionMode(
    ViewerInteractionMode mode,
  ) async {
    state = state.copyWith(
      interactionMode: mode,
    );

    await _service.updateView(
      state,
    );
  }

  Future<void> rotate({
    double? x,
    double? y,
    double? z,
  }) async {
    state = state.copyWith(
      rotationX: x,
      rotationY: y,
      rotationZ: z,
    );

    await _service.updateView(
      state,
    );
  }

  Future<void> setZoom(double zoom) async {
    state = state.copyWith(
      zoom: zoom.clamp(0.1, 20.0),
    );

    await _service.updateView(
      state,
    );
  }

  Future<void> zoomIn() async {
    await setZoom(
      state.zoom * 1.1,
    );
  }

  Future<void> zoomOut() async {
    await setZoom(
      state.zoom / 1.1,
    );
  }

  Future<void> resetView() async {
    state = const ViewerState();

    await _service.resetView();
  }

  Future<void> toggleDimensions() async {
    state = state.copyWith(
      showDimensions:
          !state.showDimensions,
    );

    await _service.updateView(
      state,
    );
  }

  Future<void> toggleAxes() async {
    state = state.copyWith(
      showAxes: !state.showAxes,
    );

    await _service.updateView(
      state,
    );
  }

  Future<void> toggleGrid() async {
    state = state.copyWith(
      showGrid: !state.showGrid,
    );

    await _service.updateView(
      state,
    );
  }

  Future<void> enableSection(
    String plane,
  ) async {
    state = state.copyWith(
      sectionEnabled: true,
      sectionPlane: plane,
    );

    await _service.updateView(
      state,
    );
  }

  Future<void> disableSection() async {
    state = state.copyWith(
      sectionEnabled: false,
      clearSectionPlane: true,
    );

    await _service.updateView(
      state,
    );
  }

  Future<void> disposeViewer() async {
    await _service.dispose();
  }
}

final viewerProvider =
    NotifierProvider<
        ViewerNotifier,
        ViewerState>(
  ViewerNotifier.new,
);

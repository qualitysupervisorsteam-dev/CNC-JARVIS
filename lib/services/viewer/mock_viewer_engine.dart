import '../../models/geometry_model.dart';
import '../../models/viewer_state.dart';
import 'viewer_engine.dart';

class MockViewerEngine extends ViewerEngine {
  MockViewerEngine();

  GeometryModel? _geometry;
  ViewerState _viewerState =
      const ViewerState();

  bool _initialized = false;

  bool get isInitialized => _initialized;

  GeometryModel? get loadedGeometry =>
      _geometry;

  ViewerState get viewerState =>
      _viewerState;

  @override
  Future<void> initialize() async {
    _initialized = true;
  }

  @override
  Future<void> loadGeometry(
    GeometryModel geometry,
  ) async {
    if (!_initialized) {
      await initialize();
    }

    _geometry = geometry;
  }

  @override
  Future<void> updateView(
    ViewerState state,
  ) async {
    if (!_initialized) {
      await initialize();
    }

    _viewerState = state;
  }

  @override
  Future<void> resetView() async {
    _viewerState = const ViewerState();
  }

  @override
  Future<void> dispose() async {
    _geometry = null;
    _viewerState = const ViewerState();
    _initialized = false;
  }
}

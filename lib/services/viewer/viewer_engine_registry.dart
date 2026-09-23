import '../../models/geometry_model.dart';
import '../../models/viewer_state.dart';
import 'mock_viewer_engine.dart';
import 'viewer_engine.dart';

class ViewerEngineRegistry {
  static final ViewerEngine defaultEngine =
      MockViewerEngine();

  static ViewerEngine getEngine() {
    return defaultEngine;
  }

  static Future<void> initialize() async {
    final engine = getEngine();

    await engine.initialize();
  }

  static Future<void> loadGeometry(
    GeometryModel geometry,
  ) async {
    final engine = getEngine();

    await engine.loadGeometry(
      geometry,
    );
  }

  static Future<void> updateView(
    ViewerState state,
  ) async {
    final engine = getEngine();

    await engine.updateView(
      state,
    );
  }

  static Future<void> resetView() async {
    final engine = getEngine();

    await engine.resetView();
  }

  static Future<void> dispose() async {
    final engine = getEngine();

    await engine.dispose();
  }
}

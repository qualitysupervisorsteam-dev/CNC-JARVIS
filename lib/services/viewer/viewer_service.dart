import '../../models/geometry_model.dart';
import '../../models/viewer_state.dart';
import 'viewer_engine_registry.dart';

class ViewerService {
  Future<void> initialize() async {
    await ViewerEngineRegistry.initialize();
  }

  Future<void> loadGeometry(
    GeometryModel geometry,
  ) async {
    await ViewerEngineRegistry.loadGeometry(
      geometry,
    );
  }

  Future<void> updateView(
    ViewerState state,
  ) async {
    await ViewerEngineRegistry.updateView(
      state,
    );
  }

  Future<void> resetView() async {
    await ViewerEngineRegistry.resetView();
  }

  Future<void> dispose() async {
    await ViewerEngineRegistry.dispose();
  }
}

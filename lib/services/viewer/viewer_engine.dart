import '../../models/geometry_model.dart';
import '../../models/viewer_state.dart';

abstract class ViewerEngine {
  const ViewerEngine();

  Future<void> initialize();

  Future<void> loadGeometry(
    GeometryModel geometry,
  );

  Future<void> updateView(
    ViewerState state,
  );

  Future<void> resetView();

  Future<void> dispose();
}

import '../../models/engineering_model.dart';
import '../../models/geometry_model.dart';
import '../../models/geometry_status.dart';
import 'geometry_engine.dart';

class MockGeometryEngine extends GeometryEngine {
  const MockGeometryEngine();

  @override
  Future<GeometryModel> buildGeometry(
    EngineeringModel engineeringModel,
  ) async {
    return GeometryModel(
      id: 'GEO-${engineeringModel.id}',
      name: engineeringModel.name,
      status: GeometryStatus.ready,
      bodyCount: 0,
      solidCount: 0,
      surfaceCount: 0,
      confidence: engineeringModel.confidence,
      hasSolidGeometry: false,
      verified: false,
      note:
          'Mock geometry engine. Real CAD geometry engine is not connected yet.',
    );
  }
}

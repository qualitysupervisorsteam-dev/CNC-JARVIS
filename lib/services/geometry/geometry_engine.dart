import '../../models/engineering_model.dart';
import '../../models/geometry_model.dart';

abstract class GeometryEngine {
  const GeometryEngine();

  Future<GeometryModel> buildGeometry(
    EngineeringModel engineeringModel,
  );
}

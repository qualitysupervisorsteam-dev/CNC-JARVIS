import '../../models/engineering_model.dart';
import '../../models/geometry_model.dart';
import '../../models/geometry_source.dart';
import 'geometry_engine_registry.dart';

class GeometryService {
  Future<GeometryModel> buildGeometry(
    EngineeringModel engineeringModel, {
    GeometrySource? source,
  }) async {
    return GeometryEngineRegistry.buildGeometry(
      engineeringModel,
      source: source,
    );
  }
}

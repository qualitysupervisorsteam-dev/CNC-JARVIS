import '../../models/engineering_model.dart';
import '../../models/geometry_model.dart';
import '../../models/geometry_source.dart';
import 'cad_geometry_engine.dart';
import 'geometry_engine.dart';
import 'mock_geometry_engine.dart';

class GeometryEngineRegistry {
  static const GeometryEngine defaultEngine =
      MockGeometryEngine();

  static final CadGeometryEngine cadEngine =
      CadGeometryEngine();

  static GeometryEngine getEngine({
    GeometrySource? source,
  }) {
    if (source != null &&
        source.isDirectCadFormat) {
      return cadEngine;
    }

    return defaultEngine;
  }

  static Future<GeometryModel> buildGeometry(
    EngineeringModel engineeringModel, {
    GeometrySource? source,
  }) async {
    final engine = getEngine(
      source: source,
    );

    if (engine is CadGeometryEngine) {
      engine.setSource(source!);
    }

    return engine.buildGeometry(
      engineeringModel,
    );
  }
}

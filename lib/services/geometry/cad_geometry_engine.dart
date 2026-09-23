import '../../models/engineering_model.dart';
import '../../models/geometry_model.dart';
import '../../models/geometry_source.dart';
import '../cad/cad_native_service.dart';
import 'geometry_engine.dart';

class CadGeometryEngine
    extends GeometryEngine {
  CadGeometryEngine({
    CadNativeService? cadService,
  }) : _cadService =
            cadService ?? const CadNativeService();

  final CadNativeService _cadService;

  GeometrySource? _source;

  void setSource(
    GeometrySource source,
  ) {
    _source = source;
  }

  void clearSource() {
    _source = null;
  }

  GeometrySource? get source => _source;

  @override
  Future<GeometryModel> buildGeometry(
    EngineeringModel engineeringModel,
  ) async {
    final source = _source;

    if (source == null) {
      throw StateError(
        'No geometry source has been configured.',
      );
    }

    if (!source.isDirectCadFormat) {
      throw UnsupportedError(
        'Only direct CAD formats are supported '
        'by CadGeometryEngine currently.',
      );
    }

    return _cadService.importSource(
      source,
      engineeringModel: engineeringModel,
    );
  }
}
